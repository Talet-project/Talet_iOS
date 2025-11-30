//
//  VoiceCloningViewController.swift
//  TaletView
//
//  Created by 김승희 on 10/27/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then


final class VoiceCloningViewController: UIViewController {
    //MARK: Properties
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    private let contentView = UIView()
    
    private let makeVoicesView = VoiceCloningView()
    
    private let myVoiceTitleLabel = UILabel().then {
        $0.text = "My Voice"
        $0.font = .boldSystemFont(ofSize: 18)
        $0.textColor = .black
    }
    
    private let editButton = UIButton(type: .system).then {
        $0.setTitle("편집", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14)
        $0.setTitleColor(.systemOrange, for: .normal)
    }
    
    private let deleteButton = UIButton(type: .system).then {
        $0.setTitle("삭제", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14)
        $0.setTitleColor(.systemOrange, for: .normal)
        $0.isHidden = true
    }
    
    private let cancelButton = UIButton(type: .system).then {
        $0.setTitle("취소", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14)
        $0.setTitleColor(.darkGray, for: .normal)
        $0.isHidden = true
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout()).then {
        $0.register(VoiceCloningCell.self, forCellWithReuseIdentifier: VoiceCloningCell.identifier)
        $0.backgroundColor = .clear
        $0.dataSource = self
        $0.delegate = self
        $0.showsVerticalScrollIndicator = false
    }
    
    // MARK: - Data
    private var voiceList: [String] = ["아빠 목소리!!", "아빠 목소리!!", "아빠 목소리!!", "아빠 목소리!!"]
    private var isEditingMode = false
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupActions()
        setNavigation()
        bind()
    }
    
    // MARK: - methods
    private func toggleEditMode(_ enable: Bool) {
        isEditingMode = enable
        editButton.isHidden = enable
        deleteButton.isHidden = !enable
        cancelButton.isHidden = !enable
        collectionView.reloadData()
    }
    
    private func deleteSelectedVoices() {
        print("선택된 목소리 삭제")
        toggleEditMode(false)
    }
    
    private func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 120)
        layout.minimumLineSpacing = 12
        return layout
    }
    
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
    
    private func moveToVoiceCloningGuide() {
        let voiceCloningGuideVC = VoiceCloningGuideViewController()
        navigationController?.pushViewController(voiceCloningGuideVC, animated: true)
    }
    
    private func setupActions() {
        editButton.addAction(UIAction { [weak self] _ in
            self?.toggleEditMode(true)
        }, for: .touchUpInside)
        
        cancelButton.addAction(UIAction { [weak self] _ in
            self?.toggleEditMode(false)
        }, for: .touchUpInside)
        
        deleteButton.addAction(UIAction { [weak self] _ in
            self?.deleteSelectedVoices()
        }, for: .touchUpInside)
    }
    
    // MARK: - Bind
    private func bind() {
        makeVoicesView.tapMakeVoice
            .emit(onNext: { [weak self] _ in
                self?.moveToVoiceCloningGuide()
            }).disposed(by: disposeBag)
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [makeVoicesView, myVoiceTitleLabel, editButton, deleteButton, cancelButton, collectionView].forEach {
            contentView.addSubview($0)
        }
        
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        makeVoicesView.snp.makeConstraints {
            $0.top.equalTo(contentView.safeAreaLayoutGuide).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(makeVoicesView.snp.width).multipliedBy(0.49)
        }
        
        myVoiceTitleLabel.snp.makeConstraints {
            $0.top.equalTo(makeVoicesView.snp.bottom).offset(24)
            $0.leading.equalTo(makeVoicesView)
        }
        
        editButton.snp.makeConstraints {
            $0.centerY.equalTo(myVoiceTitleLabel)
            $0.trailing.equalTo(makeVoicesView)
        }
        
        deleteButton.snp.makeConstraints {
            $0.centerY.equalTo(myVoiceTitleLabel)
            $0.trailing.equalTo(cancelButton.snp.leading).offset(-8)
        }
        
        cancelButton.snp.makeConstraints {
            $0.centerY.equalTo(myVoiceTitleLabel)
            $0.trailing.equalTo(makeVoicesView)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(myVoiceTitleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(makeVoicesView)
            $0.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(voiceList.count * 120 + 36)
        }
    }
}

// MARK: - UICollectionViewDataSource & Delegate
extension VoiceCloningViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        voiceList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: VoiceCloningCell.identifier,
            for: indexPath
        ) as? VoiceCloningCell else { return UICollectionViewCell() }
        
        let title = voiceList[indexPath.item]
        cell.configure(title: title, isEditing: isEditingMode)
        return cell
    }
}
