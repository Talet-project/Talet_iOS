//
//  CustomPickerView.swift
//  Talet
//
//  Created by 김승희 on 7/29/25.
//

import UIKit

import RxSwift
import SnapKit
import Then


/// UITextField는 self.inputView를 커스텀 할 수 있음
/// 텍스트필드처럼 보이는 뷰를 클릭하면 pickerView가 표시되는 커스텀 뷰 클래스
class CustomPickerView: UITextField {
    //MARK: Rx
    let pickedValue = PublishSubject<String>() // 선택된 값 전달
    
    //MARK: Properties
    private var options = [String]()
    
    //MARK: UI Components
    private lazy var pickerView = UIPickerView().then {
        $0.delegate = self
        $0.dataSource = self
    }
    private let downIcon = UIImageView(image: UIImage.downIcon).then {
        $0.contentMode = .scaleAspectFit
        $0.frame = CGRect(x: 0, y: 0, width: 10, height: 40)
    }
    private let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 40))
    private let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
    
    //MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpTextField()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Methods
    private func setUpTextField() {
        self.font = .nanum(.display1)
        self.layer.cornerRadius = 6
        self.layer.borderWidth = 0
        self.backgroundColor = .gray50
        self.textColor = .gray300
        self.inputView = pickerView
        self.rightView = rightPaddingView
        self.rightViewMode = .always
        self.leftView = leftPaddingView
        self.leftViewMode = .always
        self.tintColor = .clear
    }
    
    func configure(options: [String], placeholder: String) {
        self.options = options
        self.placeholder = placeholder
        
        pickerView.reloadAllComponents()
        
        if let first = options.first {
            self.text = first
            pickedValue.onNext(first)
        }
    }
    
    func setSelectedValue(_ value: String?) {
        guard let value = value,
              let index = options.firstIndex(of: value) else {
            return
        }
        pickerView.selectRow(index, inComponent: 0, animated: false)
        self.text = value
        self.textColor = .gray600
        pickedValue.onNext(value)
    }
    
    //MARK: Bindings
    
    //MARK: Layout
    private func setLayout() {
        rightPaddingView.addSubview(downIcon)
    }
}


extension CustomPickerView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selected = options[row]
        self.text = selected
        self.textColor = .gray600
        pickedValue.onNext(selected)
    }
}

extension CustomPickerView: UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        options.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.text = options[row]
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18)
        label.textColor = .gray600
        return label
    }
}
