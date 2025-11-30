//
//  VoiceCloningGuideViewController.swift
//  TaletView
//
//  Created by 김승희 on 10/27/25.
//

import UIKit

import SnapKit
import Then

final class VoiceCloningGuideViewController: UIViewController {
    
    // MARK: - UI Components
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    private let contentView = UIView()
    
    private let titleLabel = UILabel().then {
        $0.text = "목소리 복제를 시작합니다"
        $0.font = .boldSystemFont(ofSize: 22)
        $0.textColor = .black
    }
    
    private let subtitleLabel = UILabel().then {
        $0.text = "가장 자연스러운 목소리를 위해, 잠시만 준비해주세요!"
        $0.font = .systemFont(ofSize: 15)
        $0.textColor = .darkGray
    }
    
    //TODO: guideImage 분리
    private let guideImageView = UIImageView().then {
        $0.image = UIImage.voiceCloneCaution
        $0.contentMode = .scaleAspectFill
    }
    
    private let checkBox = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "square"), for: .normal)
        $0.tintColor = .systemOrange
        $0.contentHorizontalAlignment = .leading
    }
    
    private let checkLabel = UILabel().then {
        $0.text = "안내 사항을 모두 확인했습니다."
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .darkGray
    }
    
    private let startButton = UIButton(type: .system).then {
        $0.setTitle("시작하기", for: .normal)
        $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .lightGray
        $0.layer.cornerRadius = 10
        $0.isEnabled = false
    }
    
    private var isChecked = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        setupLayout()
        setupActions()
        setNavigation()
    }
    
    //MARK: - Methods
    //TODO: 화면 이동 로직 분리
    private func setNavigation() {
        let backButton = UIBarButtonItem(
            image: UIImage.navigationBackButton,
            style: .plain,
            target: nil,
            action: nil
        )
        backButton.tintColor = .black
        backButton.primaryAction = UIAction { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        navigationItem.leftBarButtonItem = backButton
    }
    
    // MARK: - Actions
    private func setupActions() {
        checkBox.addAction(UIAction { [weak self] _ in
            self?.toggleCheck()
        }, for: .touchUpInside)
        
        startButton.addAction(UIAction { [weak self] _ in
            self?.startButtonTapped()
        }, for: .touchUpInside)
    }
    
    private func toggleCheck() {
        isChecked.toggle()
        let imageName = isChecked ? "checkmark.square.fill" : "square"
        checkBox.setImage(UIImage(systemName: imageName), for: .normal)
        
        startButton.isEnabled = isChecked
        startButton.backgroundColor = isChecked ? .systemOrange : .lightGray
    }
    
    private func startButtonTapped() {
        let voiceRecordingVC = VoiceRecordingViewController()
        navigationController?.pushViewController(voiceRecordingVC, animated: true)
    }
    
    // MARK: - Layout
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [titleLabel,
         subtitleLabel,
         guideImageView,
         checkBox,
         checkLabel,
         startButton
        ].forEach { contentView.addSubview($0) }
        
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        guideImageView.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(500)
        }
        
        checkBox.snp.makeConstraints {
            $0.top.equalTo(guideImageView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(24)
            $0.size.equalTo(24)
        }
        
        checkLabel.snp.makeConstraints {
            $0.centerY.equalTo(checkBox)
            $0.leading.equalTo(checkBox.snp.trailing).offset(8)
        }
        
        startButton.snp.makeConstraints {
            $0.top.equalTo(checkBox.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(54)
            $0.bottom.equalToSuperview().inset(40)
        }
    }
}
