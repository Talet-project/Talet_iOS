//
//  LoginViewModelTests.swift
//  TaletTests
//

import XCTest
import RxSwift
import RxCocoa
@testable import Talet


final class LoginViewModelTests: XCTestCase {

    var sut: LoginViewModel!
    var mockUseCase: MockAuthUseCase!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        mockUseCase = MockAuthUseCase()
        sut = LoginViewModel(loginUseCase: mockUseCase)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        sut = nil
        mockUseCase = nil
        disposeBag = nil
        super.tearDown()
    }

    // MARK: - Login Success

    func test_appleLogin_whenSuccess_emitsSuccess() {
        // Given
        mockUseCase.socialLoginResult = .just(
            LoginResultEntity(accessToken: "a", refreshToken: "r", signUpToken: nil, isSignUpNeeded: false)
        )
        let trigger = PublishSubject<Void>()
        let input = LoginViewModel.Input(appleLoginTapped: trigger.asObservable())
        let output = sut.transform(input: input)

        let expectation = expectation(description: "loginSuccess")

        output.loginSuccess
            .emit(onNext: { result in
                if case .success = result {
                    expectation.fulfill()
                }
            })
            .disposed(by: disposeBag)

        // When
        trigger.onNext(())

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockUseCase.socialLoginCallCount, 1)
        XCTAssertEqual(mockUseCase.lastLoginPlatform, .apple)
    }

    // MARK: - SignUp Needed

    func test_appleLogin_whenSignUpNeeded_emitsNeedSignUp() {
        // Given
        mockUseCase.socialLoginResult = .just(
            LoginResultEntity(accessToken: nil, refreshToken: nil, signUpToken: "signup_token", isSignUpNeeded: true)
        )
        let trigger = PublishSubject<Void>()
        let input = LoginViewModel.Input(appleLoginTapped: trigger.asObservable())
        let output = sut.transform(input: input)

        let expectation = expectation(description: "needSignUp")

        output.loginSuccess
            .emit(onNext: { result in
                if case .needSignUp(let token) = result {
                    XCTAssertEqual(token, "signup_token")
                    expectation.fulfill()
                }
            })
            .disposed(by: disposeBag)

        // When
        trigger.onNext(())

        // Then
        wait(for: [expectation], timeout: 1.0)
    }

    // MARK: - Login Error

    func test_appleLogin_whenError_emitsErrorMessage() {
        // Given
        mockUseCase.socialLoginResult = .error(NetworkError.serverError(500))

        let trigger = PublishSubject<Void>()
        let input = LoginViewModel.Input(appleLoginTapped: trigger.asObservable())
        let output = sut.transform(input: input)

        let expectation = expectation(description: "errorMessage")

        output.errorMessage
            .emit(onNext: { message in
                XCTAssertFalse(message.isEmpty)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        // When
        trigger.onNext(())

        // Then
        wait(for: [expectation], timeout: 1.0)
    }
}
