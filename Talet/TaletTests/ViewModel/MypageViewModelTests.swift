//
//  MypageViewModelTests.swift
//  TaletTests
//

import XCTest
import RxSwift
import RxCocoa
@testable import Talet


final class MypageViewModelTests: XCTestCase {

    var sut: MypageViewModel!
    var mockUseCase: MockUserUseCase!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        mockUseCase = MockUserUseCase()
        sut = MypageViewModel(useCase: mockUseCase)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        sut = nil
        mockUseCase = nil
        disposeBag = nil
        super.tearDown()
    }

    // MARK: - Profile Name

    func test_transform_whenFetchSuccess_emitsProfileName() {
        // Given
        let testUser = UserEntity(
            name: "김테스트",
            birth: "2020-05",
            gender: .girl,
            profileImage: nil,
            languages: [.korean]
        )
        mockUseCase.fetchUserInfoResult = .just(testUser)

        let viewDidAppear = PublishRelay<Void>()
        let input = MypageViewModel.Input(viewDidAppear: viewDidAppear.asSignal())
        let output = sut.transform(input: input)

        let expectation = expectation(description: "profileName")

        output.profileName
            .drive(onNext: { name in
                if name == "김테스트" {
                    expectation.fulfill()
                }
            })
            .disposed(by: disposeBag)

        // When
        viewDidAppear.accept(())

        // Then
        wait(for: [expectation], timeout: 1.0)
    }

    // MARK: - Profile Info Text

    func test_transform_profileInfoText_containsGenderDisplayText() {
        // Given
        let testUser = UserEntity(
            name: "Test",
            birth: "2020-05",
            gender: .boy,
            profileImage: nil,
            languages: [.korean]
        )
        mockUseCase.fetchUserInfoResult = .just(testUser)

        let viewDidAppear = PublishRelay<Void>()
        let input = MypageViewModel.Input(viewDidAppear: viewDidAppear.asSignal())
        let output = sut.transform(input: input)

        let expectation = expectation(description: "profileInfo")

        output.profileInfoText
            .drive(onNext: { text in
                if text.contains("남아") {
                    expectation.fulfill()
                }
            })
            .disposed(by: disposeBag)

        // When
        viewDidAppear.accept(())

        // Then
        wait(for: [expectation], timeout: 1.0)
    }

    // MARK: - Error Handling

    func test_transform_whenFetchFails_emitsErrorMessage() {
        // Given
        mockUseCase.fetchUserInfoResult = .error(NetworkError.serverError(500))

        let viewDidAppear = PublishRelay<Void>()
        let input = MypageViewModel.Input(viewDidAppear: viewDidAppear.asSignal())
        let output = sut.transform(input: input)

        let expectation = expectation(description: "error")

        output.errorMessage
            .emit(onNext: { message in
                XCTAssertFalse(message.isEmpty)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        // When
        viewDidAppear.accept(())

        // Then
        wait(for: [expectation], timeout: 1.0)
    }
}
