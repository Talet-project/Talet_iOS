//
//  VoiceSelectView.swift
//  Talet
//
//  Created by 김승희 on 7/31/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then


class VoiceSelectView: UIView {
    //MARK: Properties
    private var voices: [VoiceEntity] = []
    
    private let tapSettingButton = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    var tapSetting: Signal<Void> {
        tapSettingButton.asSignal()
    }
    
    //MARK: UI Components
    private let titleLabel = UILabel().then {
        $0.text = "나의 목소리"
        $0.textColor = .black
        $0.font = .nanum(.headline1)
    }
    
    private let settingButton = UIButton(type: .system).then {
        var configuration = UIButton.Configuration.plain()
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.pretendard(.bodyLong1)
        
        configuration.attributedTitle = AttributedString("보이스 관리", attributes: titleContainer)
        configuration.baseForegroundColor = .gray500
        configuration.image = .chevronRight
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 6
        
        $0.configuration = configuration
    }
    
    private let layout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 20
        $0.sectionInset = .zero
    }
    
    private lazy var voiceSelectCollectionView = UICollectionView(frame: .zero,collectionViewLayout: layout).then {
        $0.delegate = self
        $0.dataSource = self
        $0.isPagingEnabled = true
        $0.showsHorizontalScrollIndicator = false
        $0.clipsToBounds = false
        $0.register(VoiceSelectCell.self, forCellWithReuseIdentifier: VoiceSelectCell.id)
    }
    
    //MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Methods
    func setEntity(with voices: [VoiceEntity]) {
        self.voices = voices
        voiceSelectCollectionView.reloadData()
    }
    
    //MARK: Bindings
    private func bind() {
        settingButton.rx.tap
            .bind(to: tapSettingButton)
            .disposed(by: disposeBag)
    }

    //MARK: Layout
    private func setLayout() {
        [titleLabel,
         settingButton,
         voiceSelectCollectionView
        ].forEach { addSubview($0) }
        
        settingButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(settingButton)
            $0.leading.equalToSuperview().offset(20)
        }

        voiceSelectCollectionView.snp.makeConstraints {
            $0.top.equalTo(settingButton.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
}

extension VoiceSelectView: UICollectionViewDelegate {

}

extension VoiceSelectView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return voices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VoiceSelectCell.id, for: indexPath) as? VoiceSelectCell else {
            return UICollectionViewCell()
        }
        cell.configure(cellModel: voices[indexPath.item])
        return cell
    }
}

extension VoiceSelectView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 148, height: 180)
    }
}
