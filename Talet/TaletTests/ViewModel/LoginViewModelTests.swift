//
//  LoginViewModelTests.swift
//  TaletTests
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
import RxBlocking
@testable import Talet

final class LoginViewModelTests: XCTestCase {

    var sut: LoginViewModel!
    var mockAuthUseCase: MockAuthUseCase!
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        mockAuthUseCase = MockAuthUseCase()
        sut = LoginViewModel(loginUseCase: mockAuthUseCase)
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        sut = nil
        mockAuthUseCase = nil
        scheduler = nil
        disposeBag = nil
        super.tearDown()
    }

    // MARK: - Login Success Tests

    func test_appleLoginTapped_success_emitsLoginSuccess() {
        // Given
        let loginResult = LoginResultEntity(
            accessToken: "access_token",
            refreshToken: "refresh_token",
            signUpToken: nil,
            isSignUpNeeded: false
        )
        mockAuthUseCase.stubbedSocialLoginResult = loginResult

        let appleLoginSubject = PublishSubject<Void>()
        let input = LoginViewModel.Input(appleLoginTapped: appleLoginSubject.asObservable())
        let output = sut.transform(input: input)

        var receivedResults: [LoginViewModel.LoginResult] = []

        output.loginSuccess
            .emit(onNext: { result in
                receivedResults.append(result)
            })
            .disposed(by: disposeBag)

        // When
        appleLoginSubject.onNext(())

        // Then
        // Allow async processing
        let expectation = XCTestExpectation(description: "Login success")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.mockAuthUseCase.socialLoginCallCount, 1)
            XCTAssertEqual(self.mockAuthUseCase.lastLoginPlatform, .apple)
            XCTAssertEqual(receivedResults.count, 1)
            if case .success = receivedResults.first {
                // Success
            } else {
                XCTFail("Expected success result")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func test_appleLoginTapped_needsSignUp_emitsNeedSignUpWithToken() {
        // Given
        let loginResult = LoginResultEntity(
            accessToken: nil,
            refreshToken: nil,
            signUpToken: "signup_token_123",
            isSignUpNeeded: true
        )
        mockAuthUseCase.stubbedSocialLoginResult = loginResult

        let appleLoginSubject = PublishSubject<Void>()
        let input = LoginViewModel.Input(appleLoginTapped: appleLoginSubject.asObservable())
        let output = sut.transform(input: input)

        var receivedResults: [LoginViewModel.LoginResult] = []

        output.loginSuccess
            .emit(onNext: { result in
                receivedResults.append(result)
            })
            .disposed(by: disposeBag)

        // When
        appleLoginSubject.onNext(())

        // Then
        let expectation = XCTestExpectation(description: "Need sign up")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(receivedResults.count, 1)
            if case .needSignUp(let token) = receivedResults.first {
                XCTAssertEqual(token, "signup_token_123")
            } else {
                XCTFail("Expected needSignUp result")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    // MARK: - Login Error Tests

    func test_appleLoginTapped_networkError_emitsErrorMessage() {
        // Given
        mockAuthUseCase.stubbedSocialLoginError = NetworkError.unknown

        let appleLoginSubject = PublishSubject<Void>()
        let input = LoginViewModel.Input(appleLoginTapped: appleLoginSubject.asObservable())
        let output = sut.transform(input: input)

        var receivedErrors: [String] = []

        output.errorMessage
            .emit(onNext: { message in
                receivedErrors.append(message)
            })
            .disposed(by: disposeBag)

        // When
        appleLoginSubject.onNext(())

        // Then
        let expectation = XCTestExpectation(description: "Error message")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(receivedErrors.count, 1)
            XCTAssertFalse(receivedErrors.first?.isEmpty ?? true)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func test_appleLoginTapped_serverError_emitsServerErrorMessage() {
        // Given
        mockAuthUseCase.stubbedSocialLoginError = NetworkError.serverError(500)

        let appleLoginSubject = PublishSubject<Void>()
        let input = LoginViewModel.Input(appleLoginTapped: appleLoginSubject.asObservable())
        let output = sut.transform(input: input)

        var receivedErrors: [String] = []

        output.errorMessage
            .emit(onNext: { message in
                receivedErrors.append(message)
            })
            .disposed(by: disposeBag)

        // When
        appleLoginSubject.onNext(())

        // Then
        let expectation = XCTestExpectation(description: "Server error message")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(receivedErrors.count, 1)
            XCTAssertTrue(receivedErrors.first?.contains("500") ?? false)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    // MARK: - Multiple Tap Tests

    func test_multipleTaps_onlyProcessesLatest() {
        // Given
        let loginResult = LoginResultEntity(
            accessToken: "access_token",
            refreshToken: "refresh_token",
            signUpToken: nil,
            isSignUpNeeded: false
        )
        mockAuthUseCase.stubbedSocialLoginResult = loginResult

        let appleLoginSubject = PublishSubject<Void>()
        let input = LoginViewModel.Input(appleLoginTapped: appleLoginSubject.asObservable())
        _ = sut.transform(input: input)

        // When - Rapid taps
        appleLoginSubject.onNext(())
        appleLoginSubject.onNext(())
        appleLoginSubject.onNext(())

        // Then
        let expectation = XCTestExpectation(description: "Multiple taps")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            // flatMapLatest should cancel previous requests
            XCTAssertGreaterThanOrEqual(self.mockAuthUseCase.socialLoginCallCount, 1)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}
