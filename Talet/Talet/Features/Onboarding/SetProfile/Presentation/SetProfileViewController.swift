//
//  SetProfileViewController.swift
//  Talet
//
//  Created by 김승희 on 7/18/25.
//

import UIKit

import SnapKit


class SetProfileViewController: UIViewController {
    //MARK: Constants
    
    //MARK: Properties
    
    //MARK: UI Components
    
    private let topLabel: UILabel = {
        let label = UILabel()
        label.text = "거의 다 됐어요!"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let numberImage1: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.setProfileNumberImage1
        return imageView
    }()
    
    private let numberImage2: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.setProfileNumberImage2
        return imageView
    }()
    
    private let chooseLanguageLabel: UILabel = {
        let label = UILabel()
        label.text = "우리 가족이 사용하는 언어를 선택해주세요"
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let underLanguageLabel: UILabel = {
        let label = UILabel()
        label.text = "한국어는 선택하지 않아도 돼요"
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .lightGray
        return label
    }()
    
    private let languageLabel1: UILabel = {
        let label = UILabel()
        label.text = "Language 1"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .darkGray
        return label
    }()
    
    private let languageLabel2: UILabel = {
        let label = UILabel()
        label.text = "Language 2"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .darkGray
        return label
    }()
    
    private let childInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "아이의 정보를 입력해주세요"
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let infoName: UILabel = {
        let label = UILabel()
        label.text = "이름"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .darkGray
        return label
    }()
    
    private let infoBirth: UILabel = {
        let label = UILabel()
        label.text = "생년월일"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .darkGray
        return label
    }()
    
    private let infoGender: UILabel = {
        let label = UILabel()
        label.text = "성별"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .darkGray
        return label
    }()
    
    private let infoNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이름을 입력하세요"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .lightGray
        textField.font = .systemFont(ofSize: 15)
        return textField
    }()
    
    private let infoBirthPicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        return datePicker
    }()
    
    // 연 월 따로 구분하게 되면 사용
//    private let infoBirthYear: UIPickerView = {
//        let pickerView = UIPickerView()
//        return pickerView
//    }()
//    
//    private let infoBirthMonth: UIPickerView = {
//        let pickerView = UIPickerView()
//        return pickerView
//    }()
    private let checkBoxStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let checkBoxLabel1 = CheckBoxLabelView(text: "전체 동의합니다")
    private let checkBoxLabel2 = CheckBoxLabelView(text: "[필수] 이용약관 동의", linkURL: URL(string: "https://github.com/Talet-project/Talet_iOS"))
    private let checkBoxLabel3 = CheckBoxLabelView(text: "[필수] 개인정보 수집 및 이용동의", linkURL: URL(string: "https://github.com/Talet-project/Talet_iOS"))
    private let checkBoxLabel4 = CheckBoxLabelView(text: "[선택] 마케팅 동의", linkURL: URL(string: "https://github.com/Talet-project/Talet_iOS"))
    
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
        bind()
        setLayout()
    }
    
    //MARK: Methods
    
    //MARK: Bindings
    private func bind() {
        
    }
    
    //MARK: Layout
    private func setLayout() {
        [topLabel,
         numberImage1,
         numberImage2,
         chooseLanguageLabel,
         underLanguageLabel,
         languageLabel1,
         languageLabel2,
         childInfoLabel,
         infoName,
         infoBirth,
         infoGender,
         infoNameTextField,
         infoBirthPicker,
         checkBoxStackView
        ].forEach { view.addSubview($0) }
        
        [checkBoxLabel1,
         checkBoxLabel2,
         checkBoxLabel3,
         checkBoxLabel4
        ].forEach { checkBoxStackView.addArrangedSubview($0) }
        
        topLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(60)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        numberImage1.snp.makeConstraints {
            $0.top.equalTo(topLabel.snp.bottom).offset(40)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.width.height.equalTo(24)
        }
        
        chooseLanguageLabel.snp.makeConstraints {
            $0.leading.equalTo(numberImage1.snp.trailing).offset(20)
            $0.centerY.equalTo(numberImage1)
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
        
        numberImage2.snp.makeConstraints {
            $0.top.equalTo(languageLabel2.snp.bottom).offset(40)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.width.height.equalTo(24)
        }
        
        childInfoLabel.snp.makeConstraints {
            $0.leading.equalTo(numberImage2.snp.trailing).offset(20)
            $0.centerY.equalTo(numberImage2)
        }
        
        infoName.snp.makeConstraints {
            $0.leading.equalTo(childInfoLabel)
            $0.top.equalTo(childInfoLabel.snp.bottom).offset(24)
        }

        infoNameTextField.snp.makeConstraints {
            $0.leading.equalTo(infoName.snp.trailing).offset(12)
            $0.centerY.equalTo(infoName)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(40)
        }

        infoBirth.snp.makeConstraints {
            $0.leading.equalTo(infoName)
            $0.top.equalTo(infoName.snp.bottom).offset(40)
        }

        infoBirthPicker.snp.makeConstraints {
            $0.leading.equalTo(infoBirth.snp.trailing).offset(12)
            $0.centerY.equalTo(infoBirth)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(40)
        }
        
        checkBoxStackView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(150)
        }

    }
    
    //MARK: Extensions
}
