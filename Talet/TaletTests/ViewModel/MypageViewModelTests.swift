//
//  MypageViewModelTests.swift
//  TaletTests
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
import RxBlocking
@testable import Talet

final class MypageViewModelTests: XCTestCase {

    var sut: MypageViewModel!
    var mockUserUseCase: MockUserUseCase!
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        mockUserUseCase = MockUserUseCase()
        sut = MypageViewModel(useCase: mockUserUseCase)
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        sut = nil
        mockUserUseCase = nil
        scheduler = nil
        disposeBag = nil
        super.tearDown()
    }

    // MARK: - FetchUserInfo Tests

    func test_viewDidAppear_fetchesUserInfo() {
        // Given
        let user = UserEntity(
            name: "TestUser",
            birth: "2020-05",
            gender: .boy,
            profileImage: "https://example.com/image.jpg",
            languages: [.korean, .english]
        )
        mockUserUseCase.stubbedFetchUserResult = user

        let viewDidAppearSubject = PublishSubject<Void>()
        let input = MypageViewModel.Input(
            viewDidAppear: viewDidAppearSubject.asSignal(onErrorSignalWith: .empty())
        )
        _ = sut.transform(input: input)

        // When
        viewDidAppearSubject.onNext(())

        // Then
        let expectation = XCTestExpectation(description: "Fetch user info")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.mockUserUseCase.fetchUserInfoCallCount, 1)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func test_viewDidAppear_success_emitsProfileName() {
        // Given
        let user = UserEntity(
            name: "TestUser",
            birth: "2020-05",
            gender: .boy,
            profileImage: nil,
            languages: [.korean]
        )
        mockUserUseCase.stubbedFetchUserResult = user

        let viewDidAppearSubject = PublishSubject<Void>()
        let input = MypageViewModel.Input(
            viewDidAppear: viewDidAppearSubject.asSignal(onErrorSignalWith: .empty())
        )
        let output = sut.transform(input: input)

        var profileNames: [String] = []
        output.profileName
            .drive(onNext: { name in
                profileNames.append(name)
            })
            .disposed(by: disposeBag)

        // When
        viewDidAppearSubject.onNext(())

        // Then
        let expectation = XCTestExpectation(description: "Profile name")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(profileNames.contains("TestUser"))
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func test_viewDidAppear_success_emitsProfileInfoWithAgeAndGender() {
        // Given
        // Calculate expected age based on current year
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        let birthYear = 2020
        let expectedAge = currentYear - birthYear + 1  // Korean age

        let user = UserEntity(
            name: "TestUser",
            birth: "2020-05",
            gender: .girl,
            profileImage: nil,
            languages: [.korean]
        )
        mockUserUseCase.stubbedFetchUserResult = user

        let viewDidAppearSubject = PublishSubject<Void>()
        let input = MypageViewModel.Input(
            viewDidAppear: viewDidAppearSubject.asSignal(onErrorSignalWith: .empty())
        )
        let output = sut.transform(input: input)

        var profileInfoTexts: [String] = []
        output.profileInfoText
            .drive(onNext: { text in
                profileInfoTexts.append(text)
            })
            .disposed(by: disposeBag)

        // When
        viewDidAppearSubject.onNext(())

        // Then
        let expectation = XCTestExpectation(description: "Profile info")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let lastInfo = profileInfoTexts.last ?? ""
            XCTAssertTrue(lastInfo.contains("\(expectedAge)세"))
            XCTAssertTrue(lastInfo.contains("여아"))  // Gender display text
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func test_viewDidAppear_success_emitsProfileImage() {
        // Given
        let user = UserEntity(
            name: "TestUser",
            birth: "2020-05",
            gender: .boy,
            profileImage: "https://example.com/custom_image.jpg",
            languages: [.korean]
        )
        mockUserUseCase.stubbedFetchUserResult = user

        let viewDidAppearSubject = PublishSubject<Void>()
        let input = MypageViewModel.Input(
            viewDidAppear: viewDidAppearSubject.asSignal(onErrorSignalWith: .empty())
        )
        let output = sut.transform(input: input)

        var profileImages: [ProfileImage] = []
        output.profileImage
            .drive(onNext: { image in
                profileImages.append(image)
            })
            .disposed(by: disposeBag)

        // When
        viewDidAppearSubject.onNext(())

        // Then
        let expectation = XCTestExpectation(description: "Profile image")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let lastImage = profileImages.last
            XCTAssertEqual(lastImage?.url, "https://example.com/custom_image.jpg")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func test_viewDidAppear_withoutProfileImage_usesFallbackImage() {
        // Given
        let user = UserEntity(
            name: "TestUser",
            birth: "2020-05",
            gender: .girl,
            profileImage: nil,  // No custom image
            languages: [.korean]
        )
        mockUserUseCase.stubbedFetchUserResult = user

        let viewDidAppearSubject = PublishSubject<Void>()
        let input = MypageViewModel.Input(
            viewDidAppear: viewDidAppearSubject.asSignal(onErrorSignalWith: .empty())
        )
        let output = sut.transform(input: input)

        var profileImages: [ProfileImage] = []
        output.profileImage
            .drive(onNext: { image in
                profileImages.append(image)
            })
            .disposed(by: disposeBag)

        // When
        viewDidAppearSubject.onNext(())

        // Then
        let expectation = XCTestExpectation(description: "Fallback image")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let lastImage = profileImages.last
            XCTAssertNil(lastImage?.url)
            // Fallback should be .profileGirl for girl gender
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    // MARK: - Error Handling Tests

    func test_viewDidAppear_networkError_emitsErrorMessage() {
        // Given
        mockUserUseCase.stubbedFetchUserError = NetworkError.unknown

        let viewDidAppearSubject = PublishSubject<Void>()
        let input = MypageViewModel.Input(
            viewDidAppear: viewDidAppearSubject.asSignal(onErrorSignalWith: .empty())
        )
        let output = sut.transform(input: input)

        var errorMessages: [String] = []
        output.errorMessage
            .emit(onNext: { message in
                errorMessages.append(message)
            })
            .disposed(by: disposeBag)

        // When
        viewDidAppearSubject.onNext(())

        // Then
        let expectation = XCTestExpectation(description: "Error message")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(errorMessages.count, 1)
            XCTAssertFalse(errorMessages.first?.isEmpty ?? true)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func test_viewDidAppear_detailedError_emitsDetailedMessage() {
        // Given
        let errorResponse = ErrorResponse(code: "ERR001", status: nil, message: "상세한 에러 메시지입니다.", details: nil)
        mockUserUseCase.stubbedFetchUserError = NetworkError.detailedError(errorResponse)

        let viewDidAppearSubject = PublishSubject<Void>()
        let input = MypageViewModel.Input(
            viewDidAppear: viewDidAppearSubject.asSignal(onErrorSignalWith: .empty())
        )
        let output = sut.transform(input: input)

        var errorMessages: [String] = []
        output.errorMessage
            .emit(onNext: { message in
                errorMessages.append(message)
            })
            .disposed(by: disposeBag)

        // When
        viewDidAppearSubject.onNext(())

        // Then
        let expectation = XCTestExpectation(description: "Detailed error message")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(errorMessages.first, "상세한 에러 메시지입니다.")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    // MARK: - Age Calculation Tests

    func test_ageCalculation_validBirth_calculatesKoreanAge() {
        // Given
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())

        // Test with birth year 2015
        let user = UserEntity(
            name: "TestChild",
            birth: "2015-06",
            gender: .boy,
            profileImage: nil,
            languages: [.korean]
        )
        mockUserUseCase.stubbedFetchUserResult = user

        let viewDidAppearSubject = PublishSubject<Void>()
        let input = MypageViewModel.Input(
            viewDidAppear: viewDidAppearSubject.asSignal(onErrorSignalWith: .empty())
        )
        let output = sut.transform(input: input)

        var profileInfoTexts: [String] = []
        output.profileInfoText
            .drive(onNext: { text in
                profileInfoTexts.append(text)
            })
            .disposed(by: disposeBag)

        // When
        viewDidAppearSubject.onNext(())

        // Then
        let expectedAge = currentYear - 2015 + 1  // Korean age calculation
        let expectation = XCTestExpectation(description: "Age calculation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let lastInfo = profileInfoTexts.last ?? ""
            XCTAssertTrue(lastInfo.contains("\(expectedAge)세"))
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}
