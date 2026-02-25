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
        let bookmarkTapped: Observable<String>
    }
    
    struct Output {
        let items: Driver<[ExploreModel]>
        let errorMessage: Signal<String>
    }
    
    func transform(input: Input) -> Output {
        let errorRelay = PublishRelay<String>()
        let itemsRelay = BehaviorRelay<[ExploreModel]>(value: [])
        
        input.viewDidLoad
            .flatMapLatest { [weak self] _ -> Observable<[ExploreModel]> in
                guard let self else { return .empty() }
                
                let langKey = self.userUseCase.fetchUserInfo()
                    .asObservable()
                    .map { LanguageMapper.toShortKey($0.languages.first ??
                        .korean) }
                    .catchAndReturn(LanguageMapper.toShortKey(.korean))
                
                return Observable.zip(self.bookUseCase.fetchBrowseBooks().asObservable(), langKey)
                    .map { responses, key -> [ExploreModel] in
                        responses.map { response in
                            ExploreModel(
                                id: response.book.id,
                                name: response.book.title,
                                description: response.book.shortSummary?[key] ?? "",
                                thumbnail: response.book.image.absoluteString,
                                tags: response.book.tags ?? [],
                                bookmark: response.isBookmarked
                            )
                        }
                    }
                    .catch { error in
                        let msg = (error as? NetworkError)?.errorDescription ??
                        "데이터를 불러올 수 없습니다."
                        errorRelay.accept(msg)
                        return .just([])
                    }
            }
            .bind(to: itemsRelay)
            .disposed(by: disposeBag)
        
        input.bookmarkTapped
            .flatMap { [weak self] (bookId: String) -> Observable<Void> in
                guard let self else { return Observable.empty() }

                let snapshot = itemsRelay.value
                itemsRelay.accept(snapshot.map { model in
                    model.id == bookId
                    ? ExploreModel(id: model.id,
                                   name: model.name,
                                   description: model.description,
                                   thumbnail: model.thumbnail,
                                   tags: model.tags,
                                   bookmark: !model.bookmark)
                    : model
                })
                
                return self.bookUseCase.toggleBookmark(bookId: bookId)
                    .asObservable()
                    .catch { error in
                        itemsRelay.accept(snapshot)
                        let msg = (error as? NetworkError)?.errorDescription ?? "북마크 처리 중 오류가 발생했습니다."
                        errorRelay.accept(msg)
                        return Observable.empty()
                    }
            }
            .subscribe()
            .disposed(by: disposeBag)
        
        return Output(
            items: itemsRelay.asObservable().asDriver(onErrorJustReturn: []),
            errorMessage: errorRelay.asSignal()
        )
    }
}
