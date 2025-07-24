//
//  TopLocationsCollectionView.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 24.07.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class TopLocationsCollectionView: UICollectionView {
    private lazy var elements = [TopLocationsCollectionElement]()
    
    private lazy var didSelectTrigger = PublishRelay<AuroraTopLocation>()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension TopLocationsCollectionView {
    func setup(elements: [TopLocationsCollectionElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didSelect: Signal<AuroraTopLocation> {
        didSelectTrigger.asSignal()
    }
}

// MARK: UICollectionViewDataSource
extension TopLocationsCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: TopLocationsCollectionCell.self), for: indexPath) as! TopLocationsCollectionCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension TopLocationsCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        elements.enumerated().forEach { index, element in
            element.selected = index == indexPath.row
        }
        
        reloadData()
        
        didSelectTrigger.accept(elements[indexPath.row].location)
    }
}

// MARK: Private
private extension TopLocationsCollectionView {
    func initialize() {
        backgroundColor = UIColor.clear
        showsHorizontalScrollIndicator = false
        contentInset = UIEdgeInsets(horizontal: 16.scale)
        setContentOffset(CGPoint(x: 16.scale, y: 0), animated: false)
        
        register(TopLocationsCollectionCell.self, forCellWithReuseIdentifier: String(describing: TopLocationsCollectionCell.self))
        
        dataSource = self
        delegate = self
    }
}
