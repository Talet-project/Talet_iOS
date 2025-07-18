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
        label.textColor = .black
        return label
    }()
    
    private let chooseLanguageLabel: UILabel = {
        let label = UILabel()
        label.text = "우리 가족이 사용하는 언어를 선택해주세요"
        label.textColor = .black
        return label
    }()
    
    private let underLanguageLabel: UILabel = {
        let label = UILabel()
        label.text = "한국어는 선택하지 않아도 돼요"
        label.textColor = .darkGray
        return label
    }()
    
    private let childInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "아이의 정보를 입력해주세요"
        label.textColor = .black
        return label
    }()
    
    private let infoName: UILabel = {
        let label = UILabel()
        label.text = "이름"
        label.textColor = .darkGray
        return label
    }()
    
    private let infoBirth: UILabel = {
        let label = UILabel()
        label.text = "생년월일"
        label.textColor = .darkGray
        return label
    }()
    
    private let infoGender: UILabel = {
        let label = UILabel()
        label.text = "성별"
        label.textColor = .darkGray
        return label
    }()
    
    private let infoNameTextField: UITextField = {
        let textField = UITextField()
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
    
    private let infoGenderBoy: UIView = {
        let view = UIView()
        return view
    }()
    
    
    //MARK: init
    private init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setLayout()
    }
    
    //MARK: Methods
    
    //MARK: Bindings
    private func bind() {
        
    }
    
    //MARK: Layout
    private func setLayout() {
        view.backgroundColor = .white
    }
    
    //MARK: Extensions
}
