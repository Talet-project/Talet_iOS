//
//  SignUpViewController.swift
//  Talet
//
//  Created by 김승희 on 7/18/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then


class SignUpViewController: UIViewController {
    private let signUpToken: String
    private let viewModel: SignUpViewModel
    private let disposeBag = DisposeBag()
    
    //MARK: Constants
    private let language1Options = AppLanguage.allCases
        .filter { $0 != .korean }
        .map { $0.rawValue }
    private let language2Options = ["없음"] + AppLanguage.allCases
            .filter { $0 != .korean }
            .map { $0.rawValue }
    private let yearOptions = (2010...2025).map { "\($0)년" }
    private let monthOptions = (1...12).map { "\($0)월" }
    
    //MARK: Properties
    private let genderSelectRelay = BehaviorRelay<SignUpViewModel.Gender?>(value: nil)
    
    //MARK: UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let topLabel = UILabel().then {
        $0.text = "거의 다 됐어요!"
        $0.font = .nanum(.headline2)
        $0.textColor = .black
    }
    
    private let numberImage1 = UIImageView().then {
        $0.image = UIImage.setProfileNumberImage1
    }

    private let numberImage2 = UIImageView().then {
        $0.image = UIImage.setProfileNumberImage2
    }

    private let chooseLanguageLabel = UILabel().then {
        $0.text = "우리 가족이 사용하는 언어를 선택해주세요"
        $0.font = .nanum(.headline1)
        $0.textColor = .black
    }

    private let underLanguageLabel = UILabel().then {
        $0.text = "한국어는 선택하지 않아도 돼요"
        $0.font = .pretendard(.body1)
        $0.textColor = .lightGray
    }

    private let languageLabel1 = UILabel().then {
        $0.text = "Language 1"
        $0.font = .pretendard(.body2)
        $0.textColor = .gray600
        $0.setContentHuggingPriority(.required, for: .horizontal)
    }

    private let languageLabel2 = UILabel().then {
        $0.text = "Language 2"
        $0.font = .pretendard(.body2)
        $0.textColor = .gray600
        $0.setContentHuggingPriority(.required, for: .horizontal)
    }
    
    private lazy var language1Picker = CustomPickerView().then {
        $0.configure(options: language1Options, placeholder: "언어를 선택해주세요")
        $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }

    private lazy var language2Picker = CustomPickerView().then {
        $0.configure(options: language2Options, placeholder: "없음")
        $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }

    private let childInfoLabel = UILabel().then {
        $0.text = "아이의 정보를 입력해주세요"
        $0.font = .nanum(.headline1)
        $0.textColor = .black
    }

    private let infoName = UILabel().then {
        $0.text = "이름"
        $0.font = .pretendard(.body2)
        $0.textColor = .gray600
    }

    private let infoNameTextField = UITextField().then {
        $0.placeholder = "이름을 입력하세요"
        $0.borderStyle = .roundedRect
        $0.backgroundColor = .gray50
        $0.font = .nanum(.display1)
        $0.textColor = .gray300
    }

    private lazy var YearPicker = CustomPickerView().then {
        $0.configure(options: yearOptions, placeholder: "2019년")
    }
    
    private let infoBirth = UILabel().then {
        $0.text = "생년월일"
        $0.font = .pretendard(.body2)
        $0.textColor = .gray600
        $0.setContentHuggingPriority(.required, for: .horizontal)
    }
    
    private lazy var MonthPicker = CustomPickerView().then {
        $0.configure(options: monthOptions, placeholder: "7월")
    }
    
    private let datepickerStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 10
    }
    
    private let checkBoxStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
    }
    
    private let infoGender = UILabel().then {
        $0.text = "성별"
        $0.font = .pretendard(.body2)
        $0.textColor = .gray600
        $0.setContentHuggingPriority(.required, for: .horizontal)
    }
    
    private let genderPickerBoy = GenderPickerView().then {
        $0.configure(image: .genderBoy, name: "남아")
    }
    
    private let genderPickerGirl = GenderPickerView().then {
        $0.configure(image: .genderGirl, name: "여아")
    }
    
    private let genderStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.distribution = .fillEqually
        $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
    private let checkBoxLabel1 = CheckBoxLabelView(text: "전체 동의합니다")
    private let checkBoxLabel2 = CheckBoxLabelView(text: "[필수] 이용약관 동의",
                                                   linkURL: URL(string: "https://github.com/Talet-project/Talet_iOS"))
    private let checkBoxLabel3 = CheckBoxLabelView(text: "[필수] 개인정보 수집 및 이용동의",
                                                   linkURL: URL(string: "https://github.com/Talet-project/Talet_iOS"))
    private let checkBoxLabel4 = CheckBoxLabelView(text: "[선택] 마케팅 동의",
                                                   linkURL: URL(string: "https://github.com/Talet-project/Talet_iOS"))
    
    private let doneButton = CustomButton().then {
        $0.configure(title: "완료", isEnabled: false)
    }
    
    //MARK: init
    init(signUpToken: String, viewModel: SignUpViewModel) {
        self.signUpToken = signUpToken
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        infoNameTextField.delegate = self
        bind()
        setLayout()
        setNavigationController()
        setupGenderSelection()
    }
    
    //MARK: Methods
    private func setNavigationController() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupGenderSelection() {
        genderPickerBoy.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.genderSelectRelay.accept(.boy)
                owner.updateGenderUI(selected: .boy)
            }
            .disposed(by: disposeBag)
        
        genderPickerGirl.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.genderSelectRelay.accept(.girl)
                owner.updateGenderUI(selected: .girl)
            }
            .disposed(by: disposeBag)
    }
    
    private func updateGenderUI(selected: SignUpViewModel.Gender) {
        switch selected {
        case .boy:
            genderPickerBoy.setSelected(true)
            genderPickerGirl.setSelected(false)
        case .girl:
            genderPickerBoy.setSelected(false)
            genderPickerGirl.setSelected(true)
        }
    }
    
    //MARK: Bindings
    private func bind() {
        let input = SignUpViewModel.Input(
            firstLanguageSelected: language1Picker.pickedValue.asObservable(),
            secondLanguageSelected: language2Picker.pickedValue.asObservable(),
            nameText: infoNameTextField.rx.text.orEmpty.asObservable(),
            yearSelected: YearPicker.pickedValue.asObservable(),
            monthSelected: MonthPicker.pickedValue.asObservable(),
            genderSelected: genderSelectRelay.asObservable(),
            termsServiceAgreed: checkBoxLabel2.isChecked.asObservable(),
            termsPrivacyAgreed: checkBoxLabel3.isChecked.asObservable(),
            termsMarketingAgreed: checkBoxLabel4.isChecked.asObservable(),
            completeButtonTapped: doneButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        // 완료 버튼 활성화
        output.isCompleteButtonEnabled
            .drive(with: self) { owner, isEnabled in
                owner.doneButton.configure(title: "완료", isEnabled: isEnabled)
            }
            .disposed(by: disposeBag)
        
        // 전체 동의 자동 체크
        output.termsAllChecked
            .drive(with: self) { owner, isChecked in
                owner.checkBoxLabel1.isChecked.accept(isChecked)
            }
            .disposed(by: disposeBag)
        
        // 전체 동의 클릭 시 모두 체크
        checkBoxLabel1.isChecked
            .skip(1)  // 초기값 무시
            .subscribe(with: self) { owner, isChecked in
                owner.checkBoxLabel2.isChecked.accept(isChecked)
                owner.checkBoxLabel3.isChecked.accept(isChecked)
                owner.checkBoxLabel4.isChecked.accept(isChecked)
            }
            .disposed(by: disposeBag)

        
        // 회원가입 성공
        output.signUpSuccess
            .emit(with: self) { owner, _ in
                owner.navigateToMain()
            }
            .disposed(by: disposeBag)
        
        // 에러 메시지
        output.errorMessage
            .emit(with: self) { owner, message in
                owner.showDefaultAlert(title: "회원가입 실패", message: message)
            }
            .disposed(by: disposeBag)
    }
    
    //MARK: Navigation
    private func navigateToMain() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        let mainVC = AppDIContainer.shared.makeMainTabBarController()
        window.rootViewController = mainVC
        
        UIView.transition(with: window,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: nil)
    }
    
    //MARK: Layout
    private func setLayout() {
        view.backgroundColor = .white
        //뷰 등록
        [topLabel,
         scrollView,
         doneButton
        ].forEach { view.addSubview($0) }
        
        [numberImage1,
         numberImage2,
         chooseLanguageLabel,
         underLanguageLabel,
         languageLabel1,
         languageLabel2,
         language1Picker,
         language2Picker,
         childInfoLabel,
         infoName,
         infoNameTextField,
         infoBirth,
         datepickerStackView,
         infoGender,
         genderStackView,
         checkBoxStackView
        ].forEach { contentView.addSubview($0) }
        
        scrollView.addSubview(contentView)
        
        [YearPicker,
         MonthPicker
        ].forEach { datepickerStackView.addArrangedSubview($0) }
        
        [genderPickerBoy,
         genderPickerGirl
        ].forEach { genderStackView.addArrangedSubview($0) }
        
        [checkBoxLabel1,
         checkBoxLabel2,
         checkBoxLabel3,
         checkBoxLabel4
        ].forEach { checkBoxStackView.addArrangedSubview($0) }
        
        //스크롤뷰 영역설정
        scrollView.snp.makeConstraints {
            $0.top.equalTo(topLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(doneButton.snp.top).offset(-10)
        }

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView)
        }
        
        //레이아웃 시작
        topLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        //스크롤뷰 영역시작
        numberImage1.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.width.height.equalTo(24)
        }
        
        chooseLanguageLabel.snp.makeConstraints {
            $0.top.equalTo(numberImage1)
            $0.leading.equalTo(numberImage1.snp.trailing).offset(10)
        }
        
        underLanguageLabel.snp.makeConstraints {
            $0.leading.equalTo(chooseLanguageLabel)
            $0.top.equalTo(chooseLanguageLabel.snp.bottom).offset(10)
        }
        
        languageLabel1.snp.makeConstraints {
            $0.leading.equalTo(chooseLanguageLabel)
            $0.top.equalTo(underLanguageLabel.snp.bottom).offset(40)
        }
        
        languageLabel2.snp.makeConstraints {
            $0.leading.equalTo(chooseLanguageLabel)
            $0.top.equalTo(languageLabel1.snp.bottom).offset(30)
        }
        
        language1Picker.snp.makeConstraints {
            $0.leading.equalTo(languageLabel1.snp.trailing).offset(20)
            $0.centerY.equalTo(languageLabel1)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(40)
        }

        language2Picker.snp.makeConstraints {
            $0.leading.equalTo(language1Picker)
            $0.centerY.equalTo(languageLabel2)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(40)
        }
        
        numberImage2.snp.makeConstraints {
            $0.top.equalTo(languageLabel2.snp.bottom).offset(40)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.width.height.equalTo(24)
        }
        
        childInfoLabel.snp.makeConstraints {
            $0.leading.equalTo(numberImage2.snp.trailing).offset(10)
            $0.centerY.equalTo(numberImage2)
        }
        
        infoName.snp.makeConstraints {
            $0.leading.equalTo(childInfoLabel)
            $0.top.equalTo(childInfoLabel.snp.bottom).offset(24)
        }

        infoNameTextField.snp.makeConstraints {
            $0.leading.equalTo(infoName.snp.trailing).offset(40)
            $0.centerY.equalTo(infoName)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(40)
        }

        infoBirth.snp.makeConstraints {
            $0.leading.equalTo(infoName)
            $0.top.equalTo(infoName.snp.bottom).offset(40)
        }

        datepickerStackView.snp.makeConstraints {
            $0.leading.trailing.equalTo(infoNameTextField)
            $0.centerY.equalTo(infoBirth)
            $0.height.equalTo(40)
        }
        
        infoGender.snp.makeConstraints {
            $0.leading.equalTo(infoName)
            $0.centerY.equalTo(genderStackView)
        }
        
        genderStackView.snp.makeConstraints {
            $0.top.equalTo(datepickerStackView.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(datepickerStackView)
            $0.height.equalTo(130)
        }
        
        checkBoxStackView.snp.makeConstraints {
            $0.top.equalTo(genderStackView.snp.bottom).offset(30)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(160)
            $0.bottom.equalToSuperview()
        }
        //스크롤뷰 영역끝
        
        doneButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(44)
        }
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == infoNameTextField {
            textField.textColor = .gray600
        }
    }
}
