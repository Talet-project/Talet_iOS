//
//  AuthRepositoryTests.swift
//  TaletTests
//

import XCTest
import RxSwift
@testable import Talet


final class AuthRepositoryTests: XCTestCase {

    var sut: AuthRepositoryImpl!
    var mockNetwork: MockNetworkManager!
    var mockTokenManager: MockTokenManager!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        mockNetwork = MockNetworkManager()
        mockTokenManager = MockTokenManager()
        sut = AuthRepositoryImpl(network: mockNetwork, tokenManager: mockTokenManager)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        sut = nil
        mockNetwork = nil
        mockTokenManager = nil
        disposeBag = nil
        super.tearDown()
    }

    // MARK: - validateAccessToken

    func test_validateAccessToken_whenNoToken_returnsAuthError() {
        // Given
        mockTokenManager.accessToken = nil

        let expectation = expectation(description: "validate")

        // When
        sut.validateAccessToken()
            .subscribe(
                onSuccess: { XCTFail("Should not succeed") },
                onFailure: { error in
                    guard case AuthError.noToken = error else {
                        XCTFail("Expected AuthError.noToken but got \(error)")
                        return
                    }
                    expectation.fulfill()
                }
            )
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockNetwork.requestVoidCallCount, 0)
    }

    func test_validateAccessToken_whenTokenExists_callsNetwork() {
        // Given
        mockTokenManager.accessToken = "valid_token"
        mockNetwork.requestVoidResult = .just(())

        let expectation = expectation(description: "validate")

        // When
        sut.validateAccessToken()
            .subscribe(onSuccess: { expectation.fulfill() })
            .disposed(by: disposeBag)

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockNetwork.requestVoidCallCount, 1)
        XCTAssertEqual(mockNetwork.lastEndpoint, "/auth/validate")
        XCTAssertEqual(mockNetwork.lastHeaders?["Authorization"], "Bearer valid_token")
    }

    // MARK: - refreshToken

    func test_refreshToken_whenNoToken_returnsAuthError() {
        // Given
        mockTokenManager.refreshToken = nil

        let expectation = expectation(description: "refresh")

        // When
        sut.refreshToken()
            .subscribe(
                onSuccess: { _ in XCTFail("Should not succeed") },
                onFailure: { error in
                    guard case AuthError.noToken = error else {
                        XCTFail("Expected AuthError.noToken")
                        return
                    }
                    expectation.fulfill()
                }
            )
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)
    }

    func test_refreshToken_whenTokenExists_callsNetworkWithRefreshToken() {
        // Given
        mockTokenManager.refreshToken = "my_refresh"
        let responseDTO = RefreshResponseDTO(
            success: true,
            message: "ok",
            data: RefreshDataResponseDTO(accessToken: "new_access", refreshToken: "new_refresh")
        )
        mockNetwork.requestResult = Single.just(responseDTO) as Single<RefreshResponseDTO>

        let expectation = expectation(description: "refresh")

        // When
        sut.refreshToken()
            .subscribe(onSuccess: { token in
                XCTAssertEqual(token.accessToken, "new_access")
                XCTAssertEqual(token.refreshToken, "new_refresh")
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockNetwork.lastEndpoint, "/auth/refresh")
        XCTAssertEqual(mockNetwork.lastHeaders?["Authorization"], "Bearer my_refresh")
    }

    // MARK: - logout

    func test_logout_whenNoToken_returnsAuthError() {
        // Given
        mockTokenManager.accessToken = nil

        let expectation = expectation(description: "logout")

        // When
        sut.logout()
            .subscribe(
                onSuccess: { XCTFail("Should not succeed") },
                onFailure: { error in
                    guard case AuthError.noToken = error else {
                        XCTFail("Expected AuthError.noToken")
                        return
                    }
                    expectation.fulfill()
                }
            )
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)
    }

    func test_logout_whenTokenExists_callsCorrectEndpoint() {
        // Given
        mockTokenManager.accessToken = "access_token"
        mockNetwork.requestVoidResult = .just(())

        let expectation = expectation(description: "logout")

        // When
        sut.logout()
            .subscribe(onSuccess: { expectation.fulfill() })
            .disposed(by: disposeBag)

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockNetwork.lastEndpoint, "/auth/logout")
        XCTAssertEqual(mockNetwork.lastMethod, .post)
    }

    // MARK: - deleteAccount

    func test_deleteAccount_whenNoToken_returnsAuthError() {
        mockTokenManager.accessToken = nil

        let expectation = expectation(description: "delete")

        sut.deleteAccount()
            .subscribe(
                onSuccess: { XCTFail("Should not succeed") },
                onFailure: { error in
                    guard case AuthError.noToken = error else {
                        XCTFail("Expected AuthError.noToken")
                        return
                    }
                    expectation.fulfill()
                }
            )
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)
    }

    func test_deleteAccount_whenTokenExists_callsDeleteEndpoint() {
        // Given
        mockTokenManager.accessToken = "token"
        mockNetwork.requestVoidResult = .just(())

        let expectation = expectation(description: "delete")

        // When
        sut.deleteAccount()
            .subscribe(onSuccess: { expectation.fulfill() })
            .disposed(by: disposeBag)

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockNetwork.lastEndpoint, "/auth/delete")
        XCTAssertEqual(mockNetwork.lastMethod, .delete)
    }

    // MARK: - socialLogin

    func test_socialLogin_callsCorrectEndpoint() {
        // Given
        let loginResponse = LoginResponseDTO(
            success: true,
            message: "ok",
            data: LoginDataResponseDTO(accessToken: "a", refreshToken: "r", signUpToken: nil)
        )
        mockNetwork.requestResult = Single.just(loginResponse) as Single<LoginResponseDTO>
        let socialToken = SocialTokenEntity(socialToken: "apple_id_token", platform: "apple")

        let expectation = expectation(description: "socialLogin")

        // When
        sut.socialLogin(socialToken: socialToken)
            .subscribe(onSuccess: { result in
                XCTAssertEqual(result.accessToken, "a")
                XCTAssertFalse(result.isSignUpNeeded)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockNetwork.lastEndpoint, "/auth/apple")
        XCTAssertEqual(mockNetwork.lastMethod, .post)
    }
}
