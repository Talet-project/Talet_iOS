//
//  MypageSettingViewModelTests.swift
//  TaletTests
//

import XCTest
import RxSwift
import RxCocoa
@testable import Talet


final class MypageSettingViewModelTests: XCTestCase {

    var sut: MypageSettingViewModel!
    var mockUseCase: MockAuthUseCase!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        mockUseCase = MockAuthUseCase()
        sut = MypageSettingViewModel(useCase: mockUseCase)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        sut = nil
        mockUseCase = nil
        disposeBag = nil
        super.tearDown()
    }

    // MARK: - Privacy Policy

    func test_privacyPolicyTap_emitsURL() {
        // Given
        let privacyTap = PublishRelay<Void>()
        let input = MypageSettingViewModel.Input(
            privacyPolicyTap: privacyTap.asSignal(),
            logoutTap: Signal.empty(),
            withdrawTap: Signal.empty()
        )
        let output = sut.transform(input: input)

        let expectation = expectation(description: "privacyPolicy")

        output.openPrivacyPolicy
            .emit(onNext: { url in
                XCTAssertNotNil(url)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        // When
        privacyTap.accept(())

        // Then
        wait(for: [expectation], timeout: 1.0)
    }

    // MARK: - Logout

    func test_logoutTap_whenSuccess_emitsLogoutSuccess() {
        // Given
        mockUseCase.logoutResult = .just(())

        let logoutTap = PublishRelay<Void>()
        let input = MypageSettingViewModel.Input(
            privacyPolicyTap: Signal.empty(),
            logoutTap: logoutTap.asSignal(),
            withdrawTap: Signal.empty()
        )
        let output = sut.transform(input: input)

        let expectation = expectation(description: "logout")

        output.logoutSuccess
            .emit(onNext: {
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        // When
        logoutTap.accept(())

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockUseCase.logoutCallCount, 1)
    }

    func test_logoutTap_whenError_emitsErrorMessage() {
        // Given
        mockUseCase.logoutResult = .error(NetworkError.serverError(500))

        let logoutTap = PublishRelay<Void>()
        let input = MypageSettingViewModel.Input(
            privacyPolicyTap: Signal.empty(),
            logoutTap: logoutTap.asSignal(),
            withdrawTap: Signal.empty()
        )
        let output = sut.transform(input: input)

        let expectation = expectation(description: "logoutError")
        
        output.logoutSuccess
            .emit()
            .disposed(by: disposeBag)

        output.errorMessage
            .emit(onNext: { message in
                XCTAssertFalse(message.isEmpty)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        // When
        logoutTap.accept(())

        // Then
        wait(for: [expectation], timeout: 1.0)
    }

    // MARK: - Withdraw (Delete Account)

    func test_withdrawTap_whenSuccess_emitsWithdrawSuccess() {
        // Given
        mockUseCase.deleteAccountResult = .just(())

        let withdrawTap = PublishRelay<Void>()
        let input = MypageSettingViewModel.Input(
            privacyPolicyTap: Signal.empty(),
            logoutTap: Signal.empty(),
            withdrawTap: withdrawTap.asSignal()
        )
        let output = sut.transform(input: input)

        let expectation = expectation(description: "withdraw")

        output.withdrawSuccess
            .emit(onNext: {
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        // When
        withdrawTap.accept(())

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockUseCase.deleteAccountCallCount, 1)
    }

    func test_withdrawTap_whenError_emitsErrorMessage() {
        // Given
        mockUseCase.deleteAccountResult = .error(NetworkError.apiError("탈퇴 실패"))

        let withdrawTap = PublishRelay<Void>()
        let input = MypageSettingViewModel.Input(
            privacyPolicyTap: Signal.empty(),
            logoutTap: Signal.empty(),
            withdrawTap: withdrawTap.asSignal()
        )
        let output = sut.transform(input: input)

        let expectation = expectation(description: "withdrawError")
        
        output.withdrawSuccess
            .emit()
            .disposed(by: disposeBag)

        output.errorMessage
            .emit(onNext: { message in
                XCTAssertFalse(message.isEmpty)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        // When
        withdrawTap.accept(())

        // Then
        wait(for: [expectation], timeout: 1.0)
    }
}
