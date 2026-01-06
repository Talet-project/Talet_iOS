//
//  MypageEditViewController.swift
//  Talet
//
//  Created by 김승희 on 12/31/25.
//

import Photos
import UIKit

import Kingfisher
import RxCocoa
import RxSwift
import SnapKit
import Then


class MypageEditViewController: UIViewController {
    //MARK: Constants
    private let language1Options = LanguageEntity.allCases
        .filter { $0 != .korean }
        .map { $0.displayText }
    private let language2Options = ["없음"] + LanguageEntity.allCases
        .filter { $0 != .korean }
        .map { $0.displayText }
    private let yearOptions = (2010...2025).map { "\($0)년" }
    private let monthOptions = (1...12).map { "\($0)월" }
    
    //MARK: Properties
    private let viewModel: MypageEditViewModel
    private let disposeBag = DisposeBag()
    
    private let imageSelectedRelay = PublishRelay<Data>()
    private let genderSelectRelay = BehaviorRelay<GenderEntity?>(value: nil)
    
    //MARK: UI Components
    private lazy var profileButton = UIButton().then {
        $0.setImage(.placeholder, for: .normal)
        $0.clipsToBounds = true
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.orange400.cgColor
    }
    
    private let infoName = UILabel().then {
        $0.text = "이름"
        $0.font = .pretendard(.body2)
        $0.textColor = .gray600
    }
    
    private lazy var infoNameTextField = UITextField().then {
        $0.placeholder = "이름을 입력하세요"
        $0.layer.cornerRadius = 6
        $0.layer.borderWidth = 0
        $0.backgroundColor = .gray50
        $0.font = .nanum(.display1)
        $0.textColor = .black
        $0.leftView = self.leftPaddingView
        $0.leftViewMode = .always
    }
    
    private let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
    
    private let infoBirth = UILabel().then {
        $0.text = "생년월일"
        $0.font = .pretendard(.body2)
        $0.textColor = .gray600
        $0.setContentHuggingPriority(.required, for: .horizontal)
    }
    
    private lazy var YearPicker = CustomPickerView().then {
        $0.configure(options: yearOptions, placeholder: "2019년")
    }
    
    private lazy var MonthPicker = CustomPickerView().then {
        $0.configure(options: monthOptions, placeholder: "7월")
    }
    
    private let datepickerStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 10
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
    
    private let saveButton = CustomButton().then {
        $0.configure(title: "저장", isEnabled: false)
    }
    
    //MARK: init
    init(viewModel: MypageEditViewModel) {
        self.viewModel = viewModel
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
        setupGenderSelection()
        setNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileButton.layer.cornerRadius = profileButton.bounds.width / 2
    }
    
    //MARK: Methods
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
    
    private func updateGenderUI(selected: GenderEntity) {
        switch selected {
        case .boy:
            genderPickerBoy.setSelected(true)
            genderPickerGirl.setSelected(false)
        case .girl:
            genderPickerBoy.setSelected(false)
            genderPickerGirl.setSelected(true)
        }
    }
    
    private func setNavigationBar() {
        self.title = "내 정보 수정"

        let backButton = UIButton(type: .system).then {
            var config = UIButton.Configuration.plain()
            config.image = UIImage(systemName: "chevron.left")
            config.baseForegroundColor = .black
            config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 10)
            
            $0.configuration = config
            $0.addAction(UIAction(handler: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }), for: .touchUpInside)
        }
        let backItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = backItem
    }
    
    
    //MARK: Bindings
    private func bind() {
        
        // MARK: Input
        let input = MypageEditViewModel.Input(
            viewDidLoad: Observable.just(()),
            
            firstLanguageSelected: language1Picker.pickedValue.asObservable(),
            secondLanguageSelected: language2Picker.pickedValue.asObservable(),
            
            nameText: infoNameTextField.rx.text.orEmpty.asObservable(),
            
            yearSelected: YearPicker.pickedValue.asObservable(),
            monthSelected: MonthPicker.pickedValue.asObservable(),
            
            genderSelected: genderSelectRelay
                .compactMap { $0 }
                .asObservable(),
            
            imageSelected: imageSelectedRelay.asObservable(),
            
            saveButtonTapped: saveButton.rx.tap.asObservable()
        )
        
        //MARK: Output
        let output = viewModel.transform(input: input)
        
        output.currentUserInfo
            .drive(onNext: { [weak self] user in
                guard let self else { return }
                
                self.infoNameTextField.text = user.name
                
                let parts = user.birth.split(separator: "-")
                if parts.count == 2 {
                    let yearText = "\(parts[0])년"
                    
                    let monthInt = Int(parts[1]) ?? 1
                    let monthText = "\(monthInt)월"
                    
                    self.YearPicker.setSelectedValue(yearText)
                    self.MonthPicker.setSelectedValue(monthText)
                }
                
                self.genderSelectRelay.accept(user.gender)
                self.updateGenderUI(selected: user.gender)
                
                let langs = user.languages.filter { $0 != .korean }
                if let first = langs.first {
                    self.language1Picker.setSelectedValue(first.displayText)
                }
                
                if langs.count > 1 {
                    self.language2Picker.setSelectedValue(langs[1].displayText)
                } else {
                    self.language2Picker.setSelectedValue("없음")
                }
            })
            .disposed(by: disposeBag)
        
        output.profileImage
            .drive(onNext: { [weak self] image in
                guard let self else { return }
                
                if let urlString = image.url,
                   let url = URL(string: urlString) {
                    self.profileButton.kf.setImage(with: url, for: .normal)
                } else {
                    self.profileButton.setImage(image.fallback, for: .normal)
                }
            })
            .disposed(by: disposeBag)
        
        output.isSaveButtonEnabled
            .drive(onNext: { [weak self] isEnabled in
                self?.saveButton.configure(
                    title: "저장",
                    isEnabled: isEnabled
                )
            })
            .disposed(by: disposeBag)

        output.saveSuccess
            .emit(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        profileButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.presentImagePicker()
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: Layout
    private func setLayout() {
        view.backgroundColor = .white
        
        [profileButton,
         infoName,
         infoNameTextField,
         infoBirth,
         datepickerStackView,
         infoGender,
         genderStackView,
         languageLabel1,
         language1Picker,
         languageLabel2,
         language2Picker,
         saveButton
        ].forEach { view.addSubview($0) }
        
        [YearPicker, MonthPicker].forEach { datepickerStackView.addArrangedSubview($0) }
        [genderPickerBoy, genderPickerGirl].forEach { genderStackView.addArrangedSubview($0) }
        
        profileButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(120)
        }

        infoName.snp.makeConstraints {
            $0.top.equalTo(profileButton.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(20)
        }
        
        infoNameTextField.snp.makeConstraints {
            $0.centerY.equalTo(infoName)
            $0.leading.equalTo(language1Picker)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        
        infoBirth.snp.makeConstraints {
            $0.top.equalTo(infoName.snp.bottom).offset(30)
            $0.leading.equalTo(infoName)
        }
        
        datepickerStackView.snp.makeConstraints {
            $0.centerY.equalTo(infoBirth)
            $0.leading.equalTo(infoNameTextField)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        
        infoGender.snp.makeConstraints {
            $0.top.equalTo(infoBirth.snp.bottom).offset(24)
            $0.leading.equalTo(infoName)
        }
        
        genderStackView.snp.makeConstraints {
            $0.top.equalTo(datepickerStackView.snp.bottom).offset(10)
            $0.leading.equalTo(infoNameTextField)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(130)
        }
        
        languageLabel1.snp.makeConstraints {
            $0.top.equalTo(genderStackView.snp.bottom).offset(40)
            $0.leading.equalTo(infoName)
        }
        
        language1Picker.snp.makeConstraints {
            $0.centerY.equalTo(languageLabel1)
            $0.leading.equalTo(languageLabel1.snp.trailing).offset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        
        languageLabel2.snp.makeConstraints {
            $0.top.equalTo(languageLabel1.snp.bottom).offset(30)
            $0.leading.equalTo(infoName)
        }
        
        language2Picker.snp.makeConstraints {
            $0.centerY.equalTo(languageLabel2)
            $0.leading.equalTo(language1Picker)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        
        saveButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(44)
        }
    }
}

extension MypageEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func presentImagePicker() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        switch status {
        case .authorized, .limited:
            showImagePicker()
            
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] newStatus in
                DispatchQueue.main.async {
                    if newStatus == .authorized || newStatus == .limited {
                        self?.showImagePicker()
                    }
                }
            }
            
        case .denied, .restricted:
            presentPhotoPermissionAlert()
            
        @unknown default:
            break
        }
    }
    
    private func presentPhotoPermissionAlert() {
        let alert = UIAlertController(
            title: "사진 접근 권한 필요",
            message: "프로필 사진 변경을 위해 사진 보관함 접근 권한이 필요합니다.\n설정에서 권한을 허용해주세요.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
        
        present(alert, animated: true)
    }
    
    private func showImagePicker() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage,
              let data = image.jpegData(compressionQuality: 0.8)
        else { return }
        
        profileButton.setImage(image, for: .normal)
        imageSelectedRelay.accept(data)
    }
}
