//
//  AuthUseCaseTests.swift
//  TaletTests
//

import XCTest
import RxSwift
@testable import Talet


final class AuthUseCaseTests: XCTestCase {

    var sut: AuthUseCase!
    var mockRepository: MockAuthRepository!
    var mockTokenManager: MockTokenManager!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        mockRepository = MockAuthRepository()
        mockTokenManager = MockTokenManager()
        sut = AuthUseCase(
            appleService: AppleLoginService(),
            repository: mockRepository
        )
        sut.tokenManager = mockTokenManager
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        mockTokenManager = nil
        disposeBag = nil
        super.tearDown()
    }

    // MARK: - autoLogin: validate succeeds

    func test_autoLogin_whenValidateSucceeds_doesNotCallRefresh() {
        // Given
        mockTokenManager.accessToken = "valid_token"
        mockRepository.validateResult = .just(())

        let expectation = expectation(description: "autoLogin")

        // When
        sut.autoLogin()
            .subscribe(
                onSuccess: { _ in expectation.fulfill() },
                onFailure: { XCTFail("Should not fail: \($0)") }
            )
            .disposed(by: disposeBag)

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockRepository.validateCallCount, 1)
        XCTAssertEqual(mockRepository.refreshCallCount, 0)
    }

    // MARK: - autoLogin: validate fails, refresh succeeds

    func test_autoLogin_whenValidateFails_callsRefresh() {
        // Given
        mockTokenManager.accessToken = "expired_token"
        mockTokenManager.refreshToken = "valid_refresh"
        mockRepository.validateResult = .error(AuthError.expired)
        mockRepository.refreshResult = .just(TokenEntity(accessToken: "new_access", refreshToken: "new_refresh"))

        // After refresh, second validate should succeed
        var validateCount = 0
        mockRepository.validateResult = Single.deferred {
            validateCount += 1
            if validateCount == 1 {
                return .error(AuthError.expired)
            }
            return .just(())
        }

        let expectation = expectation(description: "autoLogin")

        // When
        sut.autoLogin()
            .subscribe(
                onSuccess: { _ in expectation.fulfill() },
                onFailure: { XCTFail("Should not fail: \($0)") }
            )
            .disposed(by: disposeBag)

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockRepository.refreshCallCount, 1)
    }

    // MARK: - autoLogin: validate fails, refresh fails

    func test_autoLogin_whenBothFail_returnsError() {
        // Given
        mockRepository.validateResult = .error(AuthError.expired)
        mockRepository.refreshResult = .error(AuthError.noToken)

        let expectation = expectation(description: "autoLogin")

        // When
        sut.autoLogin()
            .subscribe(
                onSuccess: { _ in XCTFail("Should not succeed") },
                onFailure: { _ in expectation.fulfill() }
            )
            .disposed(by: disposeBag)

        // Then
        wait(for: [expectation], timeout: 1.0)
    }

    // MARK: - autoLogin: refresh saves tokens

    func test_autoLogin_whenRefreshSucceeds_savesNewTokens() {
        // Given
        mockRepository.validateResult = .error(AuthError.expired)
        mockRepository.refreshResult = .just(TokenEntity(accessToken: "saved_access", refreshToken: "saved_refresh"))

        var validateCount = 0
        mockRepository.validateResult = Single.deferred {
            validateCount += 1
            if validateCount == 1 {
                return .error(AuthError.expired)
            }
            return .just(())
        }

        let expectation = expectation(description: "autoLogin")

        // When
        sut.autoLogin()
            .subscribe(
                onSuccess: { [weak self] _ in
                    // Then
                    XCTAssertEqual(self?.mockTokenManager.accessToken, "saved_access")
                    XCTAssertEqual(self?.mockTokenManager.refreshToken, "saved_refresh")
                    expectation.fulfill()
                },
                onFailure: { XCTFail("Should not fail: \($0)") }
            )
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)
    }

    // MARK: - logout: clears tokens

    func test_logout_clearsTokens() {
        // Given
        mockTokenManager.accessToken = "access"
        mockTokenManager.refreshToken = "refresh"
        mockRepository.logoutResult = .just(())

        let expectation = expectation(description: "logout")

        // When
        sut.logout()
            .subscribe(
                onSuccess: { [weak self] _ in
                    // Then
                    XCTAssertNil(self?.mockTokenManager.accessToken)
                    XCTAssertNil(self?.mockTokenManager.refreshToken)
                    expectation.fulfill()
                },
                onFailure: { XCTFail("\($0)") }
            )
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)
    }
}
