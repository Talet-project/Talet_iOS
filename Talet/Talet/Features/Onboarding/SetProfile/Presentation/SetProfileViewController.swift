//
//  SetProfileViewController.swift
//  Talet
//
//  Created by 김승희 on 7/18/25.
//

import UIKit

import SnapKit
import Then


// 임시 enum - 다른폴더로 이전예정
enum AppLanguage: String, CaseIterable {
    case korean = "한국어"
    case english = "영어"
    case chinese = "중국어"
    case japanese = "일본어"
    case vietnamese = "베트남어"
    case thai = "태국어"
}


class SetProfileViewController: UIViewController {
    //MARK: Constants
    private let languageOptions = AppLanguage.allCases
        .filter { $0 != .korean }
        .map { $0.rawValue }
    private let yearOptions = (2010...2025).map { "\($0)년" }
    private let monthOptions = (1...12).map { "\($0)월" }
    
    //MARK: Properties
    
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
        $0.configure(options: languageOptions, placeholder: "언어를 선택해주세요")
        $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }

    private lazy var language2Picker = CustomPickerView().then {
        $0.configure(options: languageOptions, placeholder: "언어를 선택해주세요")
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
        $0.setContentHuggingPriority(.required, for: .horizontal)
    }

    private let infoNameTextField = UITextField().then {
        $0.placeholder = "이름을 입력하세요"
        $0.borderStyle = .roundedRect
        $0.backgroundColor = .gray50
        $0.font = .nanum(.display1)
        $0.textColor = .gray300
        $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
//        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
//        $0.leftViewMode = .always
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
    private let checkBoxLabel2 = CheckBoxLabelView(text: "[필수] 이용약관 동의", linkURL: URL(string: "https://github.com/Talet-project/Talet_iOS"))
    private let checkBoxLabel3 = CheckBoxLabelView(text: "[필수] 개인정보 수집 및 이용동의", linkURL: URL(string: "https://github.com/Talet-project/Talet_iOS"))
    private let checkBoxLabel4 = CheckBoxLabelView(text: "[선택] 마케팅 동의", linkURL: URL(string: "https://github.com/Talet-project/Talet_iOS"))
    
    private let doneButton = CustomButton().then {
        $0.configure(title: "완료", isEnabled: true)
    }
    
    //MARK: init
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        infoNameTextField.delegate = self
        bind()
        setLayout()
    }
    
    //MARK: Methods
    
    //MARK: Bindings
    private func bind() {
        
    }
    
    //MARK: Layout
    private func setLayout() {
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

extension SetProfileViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == infoNameTextField {
            textField.textColor = .gray600
        }
    }
}
