//
//  UserUseCaseTests.swift
//  TaletTests
//

import XCTest
import RxSwift
@testable import Talet


final class UserUseCaseTests: XCTestCase {

    var sut: UserUseCase!
    var mockRepository: MockUserRepository!
    var disposeBag: DisposeBag!

    private let testUser = UserEntity(
        name: "테스트",
        birth: "2020-01-01",
        gender: .girl,
        profileImage: nil,
        languages: [.korean, .english]
    )

    override func setUp() {
        super.setUp()
        mockRepository = MockUserRepository()
        sut = UserUseCase(repository: mockRepository)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        disposeBag = nil
        super.tearDown()
    }

    // MARK: - fetchUserInfo

    func test_fetchUserInfo_returnsUserEntity() {
        // Given
        mockRepository.fetchUserInfoResult = .just(testUser)

        let expectation = expectation(description: "fetchUserInfo")

        // When
        sut.fetchUserInfo()
            .subscribe(onSuccess: { user in
                // Then
                XCTAssertEqual(user.name, "테스트")
                XCTAssertEqual(user.birth, "2020-01-01")
                XCTAssertEqual(user.gender, .girl)
                XCTAssertNil(user.profileImage)
                XCTAssertEqual(user.languages, [.korean, .english])
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)
    }

    func test_fetchUserInfo_callsRepository() {
        // Given
        mockRepository.fetchUserInfoResult = .just(testUser)

        let expectation = expectation(description: "fetchUserInfo")

        // When
        sut.fetchUserInfo()
            .subscribe(onSuccess: { _ in expectation.fulfill() })
            .disposed(by: disposeBag)

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockRepository.fetchUserInfoCallCount, 1)
    }

    func test_fetchUserInfo_whenError_propagatesError() {
        // Given
        mockRepository.fetchUserInfoResult = .error(NetworkError.serverError(500))

        let expectation = expectation(description: "error")

        // When
        sut.fetchUserInfo()
            .subscribe(
                onSuccess: { _ in XCTFail("Should not succeed") },
                onFailure: { error in
                    guard case NetworkError.serverError(let code) = error else {
                        XCTFail("Wrong error type")
                        return
                    }
                    XCTAssertEqual(code, 500)
                    expectation.fulfill()
                }
            )
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)
    }

    // MARK: - updateUserInfo

    func test_updateUserInfo_delegatesToRepository() {
        // Given
        let updatedUser = UserEntity(
            name: "수정됨",
            birth: "2020-06-15",
            gender: .boy,
            profileImage: "new_image.jpg",
            languages: [.korean]
        )
        mockRepository.updateUserInfoResult = .just(updatedUser)

        let expectation = expectation(description: "updateUserInfo")

        // When
        sut.updateUserInfo(user: updatedUser)
            .subscribe(onSuccess: { result in
                // Then
                XCTAssertEqual(result.name, "수정됨")
                XCTAssertEqual(result.gender, .boy)
                XCTAssertEqual(result.profileImage, "new_image.jpg")
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockRepository.updateUserInfoCallCount, 1)
        XCTAssertEqual(mockRepository.lastUpdatedUser?.name, "수정됨")
    }

    // MARK: - updateUserImage

    func test_updateUserImage_returnsUpdatedUser() {
        // Given
        let updatedUser = UserEntity(
            name: "테스트",
            birth: "2020-01-01",
            gender: .girl,
            profileImage: "uploaded_image.jpg",
            languages: [.korean]
        )
        mockRepository.updateUserImageResult = .just(updatedUser)
        let imageData = Data([0x00, 0x01, 0x02])

        let expectation = expectation(description: "updateUserImage")

        // When
        sut.updateUserImage(image: imageData)
            .subscribe(onSuccess: { result in
                // Then
                XCTAssertEqual(result.profileImage, "uploaded_image.jpg")
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)
    }
}
