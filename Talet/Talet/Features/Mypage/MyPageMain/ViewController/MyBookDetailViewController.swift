//
//  MyBookDetailViewController.swift
//  Talet
//
//  Created by 김승희 on 8/14/25.
//

import UIKit

import SnapKit
import Then


class MyBookDetailViewController: UIViewController {
    //MARK: Constants
    
    //MARK: Properties
    
    //MARK: UI Components
    private let layout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 8
        $0.minimumInteritemSpacing = 16
        $0.sectionInset = .zero
    }
    
    private lazy var myBookCollectionView = UICollectionView(frame: .zero,collectionViewLayout: layout).then {
        $0.backgroundColor = .gray50
        $0.delegate = self
        $0.dataSource = self
        $0.alwaysBounceVertical = true
        $0.register(MyBookCell.self, forCellWithReuseIdentifier: MyBookCell.id)
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
        bind()
        setLayout()
        setNavigationBar()
    }
    
    //MARK: Methods
    private func setNavigationBar() {
        let mainLabel = UILabel().then {
            $0.text = "내 책장"
            $0.font = .nanum(.display1)
            $0.textColor = .black
        }
        navigationItem.titleView = mainLabel
        
        let leftButton = UIButton(type: .system).then {
            $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
            $0.tintColor = .black
            $0.addAction(UIAction { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }, for: .touchUpInside)
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
    }
    
    //MARK: Bindings
    private func bind() {
        
    }
    
    //MARK: Layout
    private func setLayout() {
        view.backgroundColor = .white
        [myBookCollectionView,
        ].forEach { view.addSubview($0) }
        
        myBookCollectionView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
    }

}


extension MyBookDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flow = layout as? UICollectionViewFlowLayout else { return .zero }
        let columns: CGFloat = 3
        let totalSpacing = flow.sectionInset.left
        + flow.sectionInset.right
        + flow.minimumInteritemSpacing * (columns - 1)
        
        let w = floor((collectionView.bounds.width - totalSpacing) / columns)
        return CGSize(width: w, height: w * 1.9)
    }
}

extension MyBookDetailViewController: UICollectionViewDelegate {
    
}

extension MyBookDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummyBooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyBookCell.id, for: indexPath) as? MyBookCell else {
            return UICollectionViewCell()
        }
        cell.configure(cellModel: dummyBooks[indexPath.item])
        return cell
    }
}
