//
//  SolarListCollectionView.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 18.07.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class SolarListCollectionView: UICollectionView {
    private lazy var elements = [SolarListCollectionElement]()
    
    private lazy var didSelectTrigger = PublishRelay<SolarTemplate>()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension SolarListCollectionView {
    func setup(elements: [SolarListCollectionElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didSelect: Signal<SolarTemplate> {
        didSelectTrigger.asSignal()
    }
}

// MARK: UICollectionViewDataSource
extension SolarListCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch elements[indexPath.row] {
        case .title:
            return dequeueReusableCell(withReuseIdentifier: String(describing: SolarListCollectionTitleCell.self), for: indexPath)
        case .template(let element):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: SolarListCollectionTemplateCell.self), for: indexPath) as! SolarListCollectionTemplateCell
            cell.setup(element: element)
            return cell
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension SolarListCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch elements[indexPath.row] {
        case .title:
            return CGSize(width: bounds.width - contentInset.left - contentInset.right, height: 110.scale)
        case .template:
            return CGSize(width: 163.scale, height: 195.scale)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard case .template(let template) = elements[indexPath.row] else { return }
        didSelectTrigger.accept(template)
    }
}

// MARK: Private
private extension SolarListCollectionView {
    func initialize() {
        backgroundColor = UIColor.clear
        showsVerticalScrollIndicator = false
        contentInset = UIEdgeInsets(value: 16.scale)
        setContentOffset(CGPoint(x: 0, y: -16.scale), animated: false)
        
        register(SolarListCollectionTitleCell.self, forCellWithReuseIdentifier: String(describing: SolarListCollectionTitleCell.self))
        register(SolarListCollectionTemplateCell.self, forCellWithReuseIdentifier: String(describing: SolarListCollectionTemplateCell.self))
        
        dataSource = self
        delegate = self
    }
}
