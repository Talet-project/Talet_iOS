//
//  SignUpViewModelTests.swift
//  TaletTests
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
import RxBlocking
@testable import Talet

final class SignUpViewModelTests: XCTestCase {

    var sut: SignUpViewModel!
    var mockAuthUseCase: MockAuthUseCase!
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        mockAuthUseCase = MockAuthUseCase()
        sut = SignUpViewModel(signUpToken: "test_signup_token", useCase: mockAuthUseCase)
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

    // MARK: - Helper to create default input

    private func createInput(
        firstLanguage: Observable<String> = .just("🇰🇷 한국어"),
        secondLanguage: Observable<String> = .just("없음"),
        name: Observable<String> = .just("TestName"),
        year: Observable<String> = .just("2020년"),
        month: Observable<String> = .just("5월"),
        gender: Observable<GenderEntity?> = .just(.boy),
        termsAllTapped: Observable<Void> = .never(),
        termsServiceTapped: Observable<Void> = .never(),
        termsPrivacyTapped: Observable<Void> = .never(),
        termsMarketingTapped: Observable<Void> = .never(),
        completeButtonTapped: Observable<Void> = .never()
    ) -> SignUpViewModel.Input {
        return SignUpViewModel.Input(
            firstLanguageSelected: firstLanguage,
            secondLanguageSelected: secondLanguage,
            nameText: name,
            yearSelected: year,
            monthSelected: month,
            genderSelected: gender,
            termsAllTapped: termsAllTapped,
            termsServiceTapped: termsServiceTapped,
            termsPrivacyTapped: termsPrivacyTapped,
            termsMarketingTapped: termsMarketingTapped,
            completeButtonTapped: completeButtonTapped
        )
    }

    // MARK: - Form Validation Tests

    func test_formValidation_allFieldsFilled_enablesCompleteButton() {
        // Given
        let termsServiceSubject = PublishSubject<Void>()
        let termsPrivacySubject = PublishSubject<Void>()

        let input = createInput(
            termsServiceTapped: termsServiceSubject.asObservable(),
            termsPrivacyTapped: termsPrivacySubject.asObservable()
        )
        let output = sut.transform(input: input)

        var isEnabled = false
        output.isCompleteButtonEnabled
            .drive(onNext: { enabled in
                isEnabled = enabled
            })
            .disposed(by: disposeBag)

        // When - Check required terms
        termsServiceSubject.onNext(())
        termsPrivacySubject.onNext(())

        // Then
        let expectation = XCTestExpectation(description: "Button enabled")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(isEnabled)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func test_formValidation_emptyName_disablesCompleteButton() {
        // Given
        let termsServiceSubject = PublishSubject<Void>()
        let termsPrivacySubject = PublishSubject<Void>()

        let input = createInput(
            name: .just(""),  // Empty name
            termsServiceTapped: termsServiceSubject.asObservable(),
            termsPrivacyTapped: termsPrivacySubject.asObservable()
        )
        let output = sut.transform(input: input)

        var isEnabled = true
        output.isCompleteButtonEnabled
            .drive(onNext: { enabled in
                isEnabled = enabled
            })
            .disposed(by: disposeBag)

        // When
        termsServiceSubject.onNext(())
        termsPrivacySubject.onNext(())

        // Then
        let expectation = XCTestExpectation(description: "Button disabled")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertFalse(isEnabled)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func test_formValidation_noGender_disablesCompleteButton() {
        // Given
        let termsServiceSubject = PublishSubject<Void>()
        let termsPrivacySubject = PublishSubject<Void>()

        let input = createInput(
            gender: .just(nil),  // No gender selected
            termsServiceTapped: termsServiceSubject.asObservable(),
            termsPrivacyTapped: termsPrivacySubject.asObservable()
        )
        let output = sut.transform(input: input)

        var isEnabled = true
        output.isCompleteButtonEnabled
            .drive(onNext: { enabled in
                isEnabled = enabled
            })
            .disposed(by: disposeBag)

        // When
        termsServiceSubject.onNext(())
        termsPrivacySubject.onNext(())

        // Then
        let expectation = XCTestExpectation(description: "Button disabled for no gender")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertFalse(isEnabled)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    // MARK: - Terms Checkbox Tests

    func test_termsServiceTapped_togglesState() {
        // Given
        let termsServiceSubject = PublishSubject<Void>()
        let input = createInput(termsServiceTapped: termsServiceSubject.asObservable())
        let output = sut.transform(input: input)

        var checkStates: [Bool] = []
        output.termsServiceChecked
            .drive(onNext: { checked in
                checkStates.append(checked)
            })
            .disposed(by: disposeBag)

        // When
        termsServiceSubject.onNext(())  // Toggle to true
        termsServiceSubject.onNext(())  // Toggle to false

        // Then
        let expectation = XCTestExpectation(description: "Terms service toggle")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Initial false, then true, then false
            XCTAssertEqual(checkStates, [false, true, false])
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func test_termsAllTapped_togglesAllCheckboxes() {
        // Given
        let termsAllSubject = PublishSubject<Void>()
        let input = createInput(termsAllTapped: termsAllSubject.asObservable())
        let output = sut.transform(input: input)

        var serviceStates: [Bool] = []
        var privacyStates: [Bool] = []
        var marketingStates: [Bool] = []

        output.termsServiceChecked
            .drive(onNext: { serviceStates.append($0) })
            .disposed(by: disposeBag)

        output.termsPrivacyChecked
            .drive(onNext: { privacyStates.append($0) })
            .disposed(by: disposeBag)

        output.termsMarketingChecked
            .drive(onNext: { marketingStates.append($0) })
            .disposed(by: disposeBag)

        // When - Toggle all on
        termsAllSubject.onNext(())

        // Then
        let expectation = XCTestExpectation(description: "All terms toggled")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(serviceStates.last ?? false)
            XCTAssertTrue(privacyStates.last ?? false)
            XCTAssertTrue(marketingStates.last ?? false)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func test_termsAllChecked_trueWhenAllChecked() {
        // Given
        let termsServiceSubject = PublishSubject<Void>()
        let termsPrivacySubject = PublishSubject<Void>()
        let termsMarketingSubject = PublishSubject<Void>()

        let input = createInput(
            termsServiceTapped: termsServiceSubject.asObservable(),
            termsPrivacyTapped: termsPrivacySubject.asObservable(),
            termsMarketingTapped: termsMarketingSubject.asObservable()
        )
        let output = sut.transform(input: input)

        var allCheckedStates: [Bool] = []
        output.termsAllChecked
            .drive(onNext: { allCheckedStates.append($0) })
            .disposed(by: disposeBag)

        // When - Check all individually
        termsServiceSubject.onNext(())
        termsPrivacySubject.onNext(())
        termsMarketingSubject.onNext(())

        // Then
        let expectation = XCTestExpectation(description: "All checked state")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(allCheckedStates.last ?? false)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    // MARK: - SignUp Tests

    func test_completeButtonTapped_success_emitsSignUpSuccess() {
        // Given
        let loginResult = LoginResultEntity(
            accessToken: "new_access_token",
            refreshToken: "new_refresh_token",
            signUpToken: nil,
            isSignUpNeeded: false
        )
        mockAuthUseCase.stubbedSignUpResult = loginResult

        let completeSubject = PublishSubject<Void>()
        let termsServiceSubject = PublishSubject<Void>()
        let termsPrivacySubject = PublishSubject<Void>()

        let input = createInput(
            termsServiceTapped: termsServiceSubject.asObservable(),
            termsPrivacyTapped: termsPrivacySubject.asObservable(),
            completeButtonTapped: completeSubject.asObservable()
        )
        let output = sut.transform(input: input)

        var signUpSuccessEmitted = false
        output.signUpSuccess
            .emit(onNext: {
                signUpSuccessEmitted = true
            })
            .disposed(by: disposeBag)

        // When
        termsServiceSubject.onNext(())
        termsPrivacySubject.onNext(())
        completeSubject.onNext(())

        // Then
        let expectation = XCTestExpectation(description: "SignUp success")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertEqual(self.mockAuthUseCase.signUpCallCount, 1)
            XCTAssertEqual(self.mockAuthUseCase.lastSignUpToken, "test_signup_token")
            XCTAssertEqual(self.mockAuthUseCase.lastSignUpRequest?.name, "TestName")
            XCTAssertTrue(signUpSuccessEmitted)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func test_completeButtonTapped_networkError_emitsErrorMessage() {
        // Given
        mockAuthUseCase.stubbedSignUpError = NetworkError.serverError(500)

        let completeSubject = PublishSubject<Void>()
        let termsServiceSubject = PublishSubject<Void>()
        let termsPrivacySubject = PublishSubject<Void>()

        let input = createInput(
            termsServiceTapped: termsServiceSubject.asObservable(),
            termsPrivacyTapped: termsPrivacySubject.asObservable(),
            completeButtonTapped: completeSubject.asObservable()
        )
        let output = sut.transform(input: input)

        var errorMessages: [String] = []
        output.errorMessage
            .emit(onNext: { message in
                errorMessages.append(message)
            })
            .disposed(by: disposeBag)

        // When
        termsServiceSubject.onNext(())
        termsPrivacySubject.onNext(())
        completeSubject.onNext(())

        // Then
        let expectation = XCTestExpectation(description: "Error message emitted")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertEqual(errorMessages.count, 1)
            XCTAssertFalse(errorMessages.first?.isEmpty ?? true)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}
