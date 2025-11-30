//
//  VoiceRecordingViewController.swift
//  TaletView
//
//  Created by 김승희 on 11/3/25.
//

import UIKit

import SnapKit
import Then


enum RecordPhase {
    case normal    // 초기 상태
    case recording // 녹음 중
    case save      // 녹음 완료
}

final class VoiceRecordingViewController: UIViewController {
    private let loadingView = LoadingView().then {
        $0.isHidden = true
    }
    
    // MARK: - Properties
    private var currentPhase: RecordPhase = .normal {
        didSet { updateUIForCurrentPhase() }
    }
    
    private var currentStep = 1
    private var isPlaying = false
    private var recordContainerHeightConstraint: Constraint?
    private var progressTimer: Timer?
    private var currentPlaybackTime: TimeInterval = 0
    private var recordedDuration = 3.5 // TODO: 추후 음성 실제 연결
    
    // MARK: - UI Components
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    private let contentView = UIView()
    
    // progress Bar Stack
    private let progressStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.distribution = .fillEqually
    }
    
    private let progressBar1 = UIView().then {
        $0.backgroundColor = .systemOrange
        $0.layer.cornerRadius = 3
    }
    
    private let progressBar2 = UIView().then {
        $0.backgroundColor = .lightGray.withAlphaComponent(0.3)
        $0.layer.cornerRadius = 3
    }
    
    private let progressBar3 = UIView().then {
        $0.backgroundColor = .lightGray.withAlphaComponent(0.3)
        $0.layer.cornerRadius = 3
    }
    
    // 내용
    private let topOrangeLabel = UILabel().then {
        $0.text = "목소리를 듣고 따라해보세요."
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.textColor = .orange
        $0.numberOfLines = 0
        $0.textAlignment = .left
    }
    
    // sentenceContaierView 내부 - 고정
    private let sentenceContainerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.orange.cgColor
    }
    
    // TODO: 버튼으로 변경, 음성 연결
    private let speakIcon = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = .speakIcon
    }
    
    private let sentenceLabel = UILabel().then {
        $0.text = "자, 지금부터 재미있는 동화 여행을 시작해 볼까?"
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .black
        $0.numberOfLines = 0
        $0.textAlignment = .left
    }
    
    private let sentenceForeignLabel = UILabel().then {
        $0.text = "Ja, ji-geum-bu-teo jae-mi-in-neun dong-hwa yeo-haeng-eul si-jak-hae bol-kka?"
        $0.font = .systemFont(ofSize: 15)
        $0.textColor = .gray
        $0.numberOfLines = 0
        $0.textAlignment = .left
    }
    
    // recordContainer 내부
    private let recordButtonContainerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.white.cgColor
    }
    
    // recordContainer 내부 - normal, record phase
    private let sentenceLabel2 = UILabel().then {
        $0.text = "자, 지금부터 재미있는 동화 여행을 시작해 볼까?"
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .black
        $0.numberOfLines = 0
        $0.textAlignment = .left
    }
    
    private let sentenceForeignLabel2 = UILabel().then {
        $0.text = "Ja, ji-geum-bu-teo jae-mi-in-neun dong-hwa yeo-haeng-eul si-jak-hae bol-kka?"
        $0.font = .systemFont(ofSize: 15)
        $0.textColor = .gray
        $0.numberOfLines = 0
        $0.textAlignment = .left
    }
    
    private let recordButton = UIButton(type: .custom).then {
        $0.setImage(.recordIcon, for: .normal)
        $0.clipsToBounds = true
    }
    
    private let recordStartBubble = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = .tapAndRecordBubble
    }
    
    private let waveformImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
        $0.image = .recordingBar
    }
    
    private let waveformImageView2 = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
        $0.image = .recordingBar
    }
    
    // recordContainer 내부 - save phase
    private let playPauseButton = UIButton(type: .custom).then {
        $0.setImage(UIImage.playButton, for: .normal)
        $0.tintColor = .systemOrange
        $0.clipsToBounds = true
    }
        
    private let progressSlider = UISlider().then {
        $0.minimumValue = 0
        $0.maximumValue = 100
        $0.value = 30
        $0.minimumTrackTintColor = .systemOrange
        $0.maximumTrackTintColor = .lightGray.withAlphaComponent(0.3)
        $0.setThumbImage(.thumb, for: .normal)
    }
        
    private let trashButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(systemName: "trash.fill"), for: .normal)
        $0.tintColor = .lightGray
        $0.backgroundColor = .systemGray6
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
    }
    
    // containerview 바깥
    private let recordedBubbleImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
        $0.image = .savedVoiceBubble
    }
    
    private let nextButton = UIButton(type: .system).then {
        $0.setTitle("다음", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.setTitleColor(.lightGray, for: .normal)
        $0.backgroundColor = .systemGray6
        $0.layer.cornerRadius = 12
        $0.isEnabled = false
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupLayout()
        setupActions()
        bind()
        setNavigation()
        updateUIForCurrentPhase()
    }
    
    // MARK: - Methods
    private func updateUIForCurrentPhase() {
        switch currentPhase {
        case .normal:
            updateUIForNormalPhase()
        case .recording:
            updateUIForRecordingPhase()
        case .save:
            updateUIForSavePhase()
        }
    }
    
    // MARK: Phase에 따른 UI Update methods
    private func updateUIForNormalPhase() {
        print("updateUIForNormalPhase 호출됨")
        topOrangeLabel.text = "목소리를 듣고 따라해보세요."
        recordButton.setImage(.recordIcon, for: .normal)
        sentenceContainerView.layer.borderColor = UIColor.orange.cgColor
        recordButtonContainerView.layer.borderColor = UIColor.white.cgColor
        
        waveformImageView.isHidden = true
        waveformImageView2.isHidden = true
        playPauseButton.isHidden = true
        progressSlider.isHidden = true
        trashButton.isHidden = true
        recordedBubbleImageView.isHidden = true
        
        nextButton.setTitleColor(.lightGray, for: .normal)
        nextButton.backgroundColor = .systemGray6
        nextButton.isEnabled = false
        
        // 높이 제약 재설정
        recordContainerHeightConstraint?.update(offset: 333)
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.scrollView.layoutIfNeeded()
        } completion: { [weak self] _ in
            self?.sentenceLabel2.isHidden = false
            self?.sentenceForeignLabel2.isHidden = false
            self?.recordButton.isHidden = false
            self?.recordStartBubble.isHidden = false
        }
        
        recordStartBubble.transform = .identity
        recordButton.transform = .identity
        startBubbleAnimation()
    }
        
    private func updateUIForRecordingPhase() {
        print("updateUIForRecordingPhase 호출됨")
        topOrangeLabel.text = "듣고 있어요"
        recordButton.setImage(.recordStopIcon, for: .normal)
        sentenceContainerView.layer.borderColor = UIColor.gray100.cgColor
        recordButtonContainerView.layer.borderColor = UIColor.orange.cgColor
        
        recordStartBubble.isHidden = true
        waveformImageView.isHidden = false
        waveformImageView2.isHidden = false
        recordedBubbleImageView.isHidden = true
        
        playPauseButton.isHidden = true
        progressSlider.isHidden = true
        trashButton.isHidden = true
        recordedBubbleImageView.isHidden = true
        
        startRecordButtonAnimation()
        recordStartBubble.layer.removeAllAnimations()
    }
        
    private func updateUIForSavePhase() {
        print("updateUIForSavePhase 호출됨")
        topOrangeLabel.text = "잘했어요! 🎉"
        sentenceContainerView.layer.borderColor = UIColor.gray100.cgColor
        recordButtonContainerView.layer.borderColor = UIColor.orange.cgColor
        
        sentenceLabel2.isHidden = true
        sentenceForeignLabel2.isHidden = true
        recordButton.isHidden = true
        recordStartBubble.isHidden = true
        waveformImageView.isHidden = true
        waveformImageView2.isHidden = true
        recordedBubbleImageView.isHidden = true
        
        playPauseButton.isHidden = false
        progressSlider.isHidden = false
        trashButton.isHidden = false
        recordedBubbleImageView.isHidden = false
        
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.backgroundColor = .orange
        nextButton.isEnabled = true
        
        // 높이 제약 재설정
        recordButtonContainerView.snp.updateConstraints {
            $0.height.equalTo(100)
        }
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.scrollView.layoutIfNeeded()
        }
        
        progressSlider.maximumValue = Float(recordedDuration)
        progressSlider.value = 0
        
        startBubbleAnimation()
        recordButton.layer.removeAllAnimations()
    }
    
    // MARK: RecordButton, Bubble Animation
    private func startBubbleAnimation() {
        let targetBubble = currentPhase == .normal ? recordStartBubble : recordedBubbleImageView
        
        UIView.animate(withDuration: 1.0, delay: 0, options: [.repeat, .autoreverse, .curveEaseInOut]) {
            targetBubble.transform = CGAffineTransform(translationX: 0, y: 10)
        }
    }
    
    private func startRecordButtonAnimation() {
        let targetButton = recordButton
        
        UIView.animate(withDuration: 1.0, delay: 0, options: [.repeat, .autoreverse, .allowUserInteraction]) {
            targetButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }
    }
    
    
    // MARK: 버튼 Action 설정
    private func setupActions() {
        recordButton.addAction(UIAction { [weak self] _ in
            self?.handleRecordButtonTap()
            print("recordButton tapped")
        }, for: .touchUpInside)
        
        nextButton.addAction(UIAction { [weak self] _ in
            self?.goToNextSentence()
        }, for: .touchUpInside)
        
        playPauseButton.addAction(UIAction { [weak self] _ in
            self?.updatePlayStopButton()
        }, for: .touchUpInside)
        
        trashButton.addAction(UIAction { [weak self] _ in
            self?.showTrashAlert()
        }, for: .touchUpInside)
    }
    
    
    // MARK: 기타 메서드
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
    
    private func handleRecordButtonTap() {
        switch currentPhase {
        case .normal:
            print("현재 phase는 recording")
            currentPhase = .recording
            
        case .recording:
            print("현재 phase는 save")
            currentPhase = .save
            
        case .save:
            print("save에는 recordButton이 사라짐")
        }
    }
        
    private func goToNextSentence() {
        currentStep += 1
        updateProgressBars()
        
        if currentStep > 3 {
            loadingView.isHidden = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in
                let completionVC = SettingNewVoiceViewController()
                self?.navigationController?.pushViewController(completionVC, animated: true)
            }
        } else {
            currentPhase = .normal
        }
    }
        
    private func updateProgressBars() {
        progressBar1.backgroundColor = currentStep >= 1 ? .systemOrange : .lightGray.withAlphaComponent(0.3)
        progressBar2.backgroundColor = currentStep >= 2 ? .systemOrange : .lightGray.withAlphaComponent(0.3)
        progressBar3.backgroundColor = currentStep >= 3 ? .systemOrange : .lightGray.withAlphaComponent(0.3)
    }
        
    private func showTrashAlert() {
        showDestructiveAlert(title: "목소리를 삭제하고 다시 녹음하시겠습니까?",
                             message: nil,
                             cancelTitle: "취소",
                             confirmTitle: "네",
                             onConfirm: { [weak self] in
            
            self?.currentPhase = .normal
            self?.isPlaying = false
        })
    }
    
    private func updatePlayStopButton() {
        isPlaying.toggle()
        
        if isPlaying {
            // 재생 중 -> 일시정지 아이콘으로 변경
            playPauseButton.setImage(UIImage.stopButton, for: .normal)
            // TODO: 실제 오디오 재생 시작
            startProgressAnimation()
        } else {
            // 일시정지 -> 재생 아이콘으로 변경
            playPauseButton.setImage(UIImage.playButton, for: .normal)
            // TODO: 실제 오디오 일시정지
            stopProgressAnimation()
        }
    }
    
    private func startProgressAnimation() {
        let startValue = progressSlider.value  // 현재 슬라이더 위치 (재개 시 사용)
        let startTime = Date()
        
        progressTimer?.invalidate()
        progressTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            let elapsed = Date().timeIntervalSince(startTime)
            let newValue = startValue + Float(elapsed)
            
            if newValue >= Float(self.recordedDuration) {
                // 재생 완료
                self.progressSlider.setValue(Float(self.recordedDuration), animated: false)
                timer.invalidate()
                self.isPlaying = false
                self.playPauseButton.setImage(UIImage.playButton , for: .normal)
                self.progressSlider.value = 0
                // TODO: 실제 오디오 재생 완료 처리
            } else {
                self.progressSlider.setValue(newValue, animated: false)
                self.currentPlaybackTime = TimeInterval(newValue)
            }
        }
    }

    private func stopProgressAnimation() {
        progressTimer?.invalidate()
        progressTimer = nil
    }
    
    // MARK: - Bind
    private func bind() {
        
    }
    
    // MARK: - layout
    private func setupLayout() {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [
            UIColor.white.cgColor,
            UIColor.orange50.cgColor
        ]
        
        view.layer.addSublayer(gradientLayer)
        
        // 뷰 등록
        [progressBar1,
         progressBar2,
         progressBar3
        ].forEach { progressStackView.addArrangedSubview($0) }
        
        [progressStackView,
         scrollView,
         nextButton,
         loadingView,
        ].forEach { view.addSubview($0) }
        
        scrollView.addSubview(contentView)
        
        [topOrangeLabel,
         sentenceContainerView,
         recordButtonContainerView,
         recordedBubbleImageView,
        ].forEach { contentView.addSubview($0) }
        
        [speakIcon,
         sentenceLabel,
         sentenceForeignLabel,
        ].forEach { sentenceContainerView.addSubview($0) }
        
        [
        // normal, record phase
        sentenceLabel2,
         sentenceForeignLabel2,
         recordButton,
         recordStartBubble,
         waveformImageView,
         waveformImageView2,
         // save phase
         playPauseButton,
         progressSlider,
         trashButton,
        ].forEach { recordButtonContainerView.addSubview($0) }
        
        // 가장 상위뷰
        loadingView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
        progressStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(6)
        }
        
        nextButton.snp.makeConstraints {
            $0.width.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.45)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(48)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(progressStackView.snp.bottom).offset(50)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.bottom.equalTo(nextButton.snp.top).offset(-20)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        // 스크롤 뷰 내부
        topOrangeLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        sentenceContainerView.snp.makeConstraints {
            $0.top.equalTo(topOrangeLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(170)
        }
        
        recordButtonContainerView.snp.makeConstraints {
            $0.top.equalTo(sentenceContainerView.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview()
            recordContainerHeightConstraint = $0.height.equalTo(333).constraint
            $0.bottom.equalToSuperview().inset(20)
        }
        
        // sentenceContainerView 내부
        speakIcon.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(20)
            $0.width.height.equalTo(34)
        }
        
        sentenceLabel.snp.makeConstraints {
            $0.top.equalTo(speakIcon.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        sentenceForeignLabel.snp.makeConstraints {
            $0.top.equalTo(sentenceLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(sentenceLabel)
        }
        
        // recordButtonContainerView 내부 - normal, record phase
        sentenceLabel2.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(20)
        }
        
        sentenceForeignLabel2.snp.makeConstraints {
            $0.top.equalTo(sentenceLabel2.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(sentenceLabel)
        }
        
        recordStartBubble.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-30)
            $0.width.equalTo(161)
            $0.height.equalTo(44)
            $0.centerX.equalToSuperview()
        }
        
        recordButton.snp.makeConstraints {
            $0.bottom.equalTo(recordStartBubble.snp.top).offset(-10)
            $0.width.height.equalTo(121)
            $0.centerX.equalToSuperview()
        }
        
        waveformImageView.snp.makeConstraints {
            $0.centerY.equalTo(recordButton)
            $0.width.equalTo(86)
            $0.height.equalTo(75)
            $0.leading.equalToSuperview().offset(10)
        }
        
        waveformImageView2.snp.makeConstraints {
            $0.centerY.equalTo(recordButton)
            $0.width.equalTo(86)
            $0.height.equalTo(75)
            $0.trailing.equalToSuperview().offset(-10)
        }
        
        // recordButtonContainerView 내부 - save phase
        playPauseButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(60)
        }
                
        progressSlider.snp.makeConstraints {
            $0.leading.equalTo(playPauseButton.snp.trailing).offset(12)
            $0.trailing.equalTo(trashButton.snp.leading).offset(-12)
            $0.centerY.equalTo(playPauseButton)
        }
                
        trashButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalTo(playPauseButton)
            $0.width.height.equalTo(40)
        }
        
        recordedBubbleImageView.snp.makeConstraints {
            $0.top.equalTo(recordButtonContainerView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(147)
            $0.height.equalTo(44)
        }
    }
}
