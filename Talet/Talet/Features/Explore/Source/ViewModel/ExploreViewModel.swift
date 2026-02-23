//
//  ExploreViewModel.swift
//  Talet
//
//  Created by 윤대성 on 11/5/25.
//

import RxCocoa
import RxSwift

protocol ExploreViewModel {
    func transform(input: ExploreViewModelImpl.Input) -> ExploreViewModelImpl.Output
}

final class ExploreViewModelImpl: ExploreViewModel {
    private let disposeBag = DisposeBag()
    private let bookUseCase: BookUseCaseProtocol
    private let userUseCase: UserUseCaseProtocol

    init(bookUseCase: BookUseCaseProtocol, userUseCase: UserUseCaseProtocol) {
        self.bookUseCase = bookUseCase
        self.userUseCase = userUseCase
    }

    struct Input {
        let viewDidLoad: Observable<Void>
    }

    struct Output {
        let items: Driver<[ExploreModel]>
        let errorMessage: Signal<String>
    }

    func transform(input: Input) -> Output {
        let errorRelay = PublishRelay<String>()

        let items = input.viewDidLoad
            .flatMapLatest { [weak self] _ -> Observable<[ExploreModel]> in
                guard let self else { return .empty() }

                let langKey = self.userUseCase.fetchUserInfo()
                    .asObservable()
                    .map { user -> String in
                        LanguageMapper.toAPI(user.languages.first ?? .korean)
                    }
                    .catchAndReturn(LanguageMapper.toAPI(.korean))

                return Observable.zip(
                    self.bookUseCase.fetchBrowseBooks().asObservable(),
                    langKey
                )
                .map { responses, key -> [ExploreModel] in
                    return responses.map { response in
                        ExploreModel(
                            id: response.book.id,
                            name: response.book.title,
                            description: response.book.shortSummary?[key]
                                ?? response.book.shortSummary?["KOREAN"]
                                ?? response.book.shortSummary?.values.first ?? "",
                            thumbnail: response.book.image.absoluteString,
                            tags: (response.book.tags ?? []).map { BookTagStyleProvider.style(for: $0).title }
                        )
                    }
                }
                .catch { error in
                    let msg = (error as? NetworkError)?.errorDescription ?? "데이터를 불러올 수 없습니다."
                    errorRelay.accept(msg)
                    return .just([])
                }
            }
            .asDriver(onErrorJustReturn: [])

        return Output(items: items, errorMessage: errorRelay.asSignal())
    }
}
