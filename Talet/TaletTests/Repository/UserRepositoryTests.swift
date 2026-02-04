//
//  UserRepositoryTests.swift
//  TaletTests
//

import XCTest
import RxSwift
@testable import Talet


final class UserRepositoryTests: XCTestCase {

    var sut: UserRepositoryImpl!
    var mockNetwork: MockNetworkManager!
    var mockTokenManager: MockTokenManager!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        mockNetwork = MockNetworkManager()
        mockTokenManager = MockTokenManager()
        sut = UserRepositoryImpl(networkManager: mockNetwork, tokenManager: mockTokenManager)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        sut = nil
        mockNetwork = nil
        mockTokenManager = nil
        disposeBag = nil
        super.tearDown()
    }

    // MARK: - fetchUserInfo

    func test_fetchUserInfo_whenNoToken_returnsAuthError() {
        mockTokenManager.accessToken = nil

        let expectation = expectation(description: "fetchUserInfo")

        sut.fetchUserInfo()
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
        XCTAssertEqual(mockNetwork.requestCallCount, 0)
    }

    func test_fetchUserInfo_whenTokenExists_callsCorrectEndpoint() {
        // Given
        mockTokenManager.accessToken = "my_token"
        let responseDTO = UserInfoResponseDTO(
            success: true,
            message: "ok",
            data: UserInfoDataResponseDTO(
                profileImage: "img.jpg",
                nickname: "테스트유저",
                gender: "여성",
                birthday: "2020-05",
                languages: ["KOREAN"]
            )
        )
        mockNetwork.requestResult = Single.just(responseDTO) as Single<UserInfoResponseDTO>

        let expectation = expectation(description: "fetchUserInfo")

        // When
        sut.fetchUserInfo()
            .subscribe(onSuccess: { user in
                XCTAssertEqual(user.name, "테스트유저")
                XCTAssertEqual(user.gender, .girl)
                XCTAssertEqual(user.languages, [.korean])
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockNetwork.lastEndpoint, "/member/me")
        XCTAssertEqual(mockNetwork.lastHeaders?["Authorization"], "Bearer my_token")
    }

    // MARK: - updateUserInfo

    func test_updateUserInfo_whenNoToken_returnsAuthError() {
        mockTokenManager.accessToken = nil
        let user = UserEntity(name: "A", birth: "2020-01", gender: .boy, profileImage: nil, languages: [])

        let expectation = expectation(description: "updateUserInfo")

        sut.updateUserInfo(request: user)
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

    func test_updateUserInfo_callsCorrectEndpoint() {
        // Given
        mockTokenManager.accessToken = "token"
        let responseDTO = UserInfoResponseDTO(
            success: true,
            message: "ok",
            data: UserInfoDataResponseDTO(
                profileImage: nil,
                nickname: "수정됨",
                gender: "남성",
                birthday: "2019-03",
                languages: ["KOREAN", "ENGLISH"]
            )
        )
        mockNetwork.requestResult = Single.just(responseDTO) as Single<UserInfoResponseDTO>
        let user = UserEntity(name: "수정됨", birth: "2019-03", gender: .boy, profileImage: nil, languages: [.korean, .english])

        let expectation = expectation(description: "updateUserInfo")

        // When
        sut.updateUserInfo(request: user)
            .subscribe(onSuccess: { result in
                XCTAssertEqual(result.name, "수정됨")
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockNetwork.lastEndpoint, "/member/update")
        XCTAssertEqual(mockNetwork.lastMethod, .post)
    }

    // MARK: - updateUserImage

    func test_updateUserImage_whenNoToken_returnsAuthError() {
        mockTokenManager.accessToken = nil

        let expectation = expectation(description: "updateImage")

        sut.updateUserImage(imageData: Data())
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

    func test_updateUserImage_callsUploadEndpoint() {
        // Given
        mockTokenManager.accessToken = "token"
        let responseDTO = UserInfoResponseDTO(
            success: true,
            message: "ok",
            data: UserInfoDataResponseDTO(
                profileImage: "uploaded.jpg",
                nickname: "유저",
                gender: "여성",
                birthday: "2020-01",
                languages: ["KOREAN"]
            )
        )
        mockNetwork.uploadResult = Single.just(responseDTO) as Single<UserInfoResponseDTO>
        let imageData = Data([0xFF, 0xD8])

        let expectation = expectation(description: "upload")

        // When
        sut.updateUserImage(imageData: imageData)
            .subscribe(onSuccess: { user in
                XCTAssertEqual(user.profileImage, "uploaded.jpg")
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockNetwork.uploadCallCount, 1)
        XCTAssertEqual(mockNetwork.lastEndpoint, "/member/update/image")
    }
}
