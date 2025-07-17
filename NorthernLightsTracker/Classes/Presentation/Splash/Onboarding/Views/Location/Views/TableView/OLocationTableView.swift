//
//  OLocationTableView.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 16.07.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class OLocationTableView: UITableView {
    private lazy var elements = [Location]()
    
    private lazy var didScrollToBottomTrigger = PublishRelay<Void>()
    private lazy var didSelectLocationTrigger = PublishRelay<Location>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension OLocationTableView {
    func setup(elements: [Location]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didScrollToBottom: Signal<Void> {
        didScrollToBottomTrigger.asSignal()
    }
    
    var didSelectLocation: Signal<Location> {
        didSelectLocationTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension OLocationTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: String(describing: OLocationTableCell.self), for: indexPath) as! OLocationTableCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UITableViewDelegate
extension OLocationTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard (elements.count - 1) == indexPath.row else { return }
        didScrollToBottomTrigger.accept(Void())
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectLocationTrigger.accept(elements[indexPath.row])
    }
}

// MARK: Private
private extension OLocationTableView {
    func initialize() {
        backgroundColor = UIColor.clear
        showsVerticalScrollIndicator = false
        contentInset = UIEdgeInsets(vertical: 16.scale)
        setContentOffset(CGPoint(x: 0, y: -16.scale), animated: false)
        separatorStyle = .none
        
        register(OLocationTableCell.self, forCellReuseIdentifier: String(describing: OLocationTableCell.self))
        
        dataSource = self
        delegate = self
    }
}
