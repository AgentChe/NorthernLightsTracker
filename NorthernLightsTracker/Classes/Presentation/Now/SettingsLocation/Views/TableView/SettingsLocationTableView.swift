//
//  SettingsLocationTableView.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 22.07.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class SettingsLocationTableView: UITableView {
    private lazy var elements = [SettingsLocationTableElement]()
    
    private lazy var didScrollToBottomTrigger = PublishRelay<Void>()
    private lazy var didSelectRecentTrigger = PublishRelay<String>()
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
extension SettingsLocationTableView {
    func setup(elements: [SettingsLocationTableElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didScrollToBottom: Signal<Void> {
        didScrollToBottomTrigger.asSignal()
    }
    
    var didSelectRecent: Signal<String> {
        didSelectRecentTrigger.asSignal()
    }
    
    var didSelectLocation: Signal<Location> {
        didSelectLocationTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension SettingsLocationTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
        case .currentLocation(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: SettingsLocationTableCurrentLocationCell.self), for: indexPath) as! SettingsLocationTableCurrentLocationCell
            cell.setup(element: element)
            return cell
        case .recentTitle:
            return dequeueReusableCell(withIdentifier: String(describing: SettingsLocationTableRecentTitleCell.self), for: indexPath)
        case .recent(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: SettingsLocationTableLocationCell.self), for: indexPath) as! SettingsLocationTableLocationCell
            cell.setup(element: element)
            return cell
        case .location(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: SettingsLocationTableLocationCell.self), for: indexPath) as! SettingsLocationTableLocationCell
            cell.setup(element: element.address)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension SettingsLocationTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard (elements.count - 1) == indexPath.row else { return }
        didScrollToBottomTrigger.accept(Void())
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch elements[indexPath.row] {
        case .recent(let recent):
            didSelectRecentTrigger.accept(recent)
        case .location(let location):
            didSelectLocationTrigger.accept(location)
        default:
            return 
        }
    }
}

// MARK: Private
private extension SettingsLocationTableView {
    func initialize() {
        backgroundColor = UIColor.clear
        showsVerticalScrollIndicator = false
        contentInset = UIEdgeInsets(vertical: 24.scale)
        setContentOffset(CGPoint(x: 0, y: -24.scale), animated: false)
        separatorStyle = .none
        
        register(SettingsLocationTableCurrentLocationCell.self, forCellReuseIdentifier: String(describing: SettingsLocationTableCurrentLocationCell.self))
        register(SettingsLocationTableRecentTitleCell.self, forCellReuseIdentifier: String(describing: SettingsLocationTableRecentTitleCell.self))
        register(SettingsLocationTableLocationCell.self, forCellReuseIdentifier: String(describing: SettingsLocationTableLocationCell.self))
        
        dataSource = self
        delegate = self
    }
}
