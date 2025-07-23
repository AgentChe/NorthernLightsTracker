//
//  NowTableView.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 23.07.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class NowTableView: UITableView {
    private lazy var elements = [NowTableElement]()
    
    private lazy var didTapOpenFullMapTrigger = PublishRelay<Void>()
    private lazy var didTapOpenTopLocationsTrigger = PublishRelay<Void>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension NowTableView {
    func setup(elements: [NowTableElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didTapOpenFullMap: Signal<Void> {
        didTapOpenFullMapTrigger.asSignal()
    }
    
    var didTapOpenTopLocations: Signal<Void> {
        didTapOpenTopLocationsTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension NowTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
        case .updated(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: NowTableUpdatedCell.self), for: indexPath) as! NowTableUpdatedCell
            cell.setup(element: element)
            return cell
        case .status(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: NowTableStatusCell.self), for: indexPath) as! NowTableStatusCell
            cell.setup(element: element)
            return cell
        case .indicators(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: NowTableIndicatorsCell.self), for: indexPath) as! NowTableIndicatorsCell
            cell.setup(element: element)
            return cell
        case .openMapRoute:
            return dequeueReusableCell(withIdentifier: String(describing: NowTableMapRouteCell.self), for: indexPath)
        case .currentLocation(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: NowTableCurrentLocationCell.self), for: indexPath) as! NowTableCurrentLocationCell
            cell.setup(element: element)
            return cell
        case .topLocationsRoute:
            return dequeueReusableCell(withIdentifier: String(describing: NowTableOpenTopLocationsCell.self), for: indexPath)
        case .noTopLocations:
            return dequeueReusableCell(withIdentifier: String(describing: NowTableNoTopLocationsCell.self), for: indexPath)
        }
    }
}

// MARK: UITableViewDelegate
extension NowTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch elements[indexPath.row] {
        case .openMapRoute:
            didTapOpenFullMapTrigger.accept(Void())
        case .topLocationsRoute:
            didTapOpenTopLocationsTrigger.accept(Void())
        default:
            return 
        }
    }
}

// MARK: Private
private extension NowTableView {
    func initialize() {
        backgroundColor = UIColor.clear
        contentInset = UIEdgeInsets(t: 53.scale, b: 16.scale)
        setContentOffset(CGPoint.zero, animated: false)
        showsVerticalScrollIndicator = false
        separatorStyle = .none
        
        register(NowTableUpdatedCell.self, forCellReuseIdentifier: String(describing: NowTableUpdatedCell.self))
        register(NowTableStatusCell.self, forCellReuseIdentifier: String(describing: NowTableStatusCell.self))
        register(NowTableIndicatorsCell.self, forCellReuseIdentifier: String(describing: NowTableIndicatorsCell.self))
        register(NowTableMapRouteCell.self, forCellReuseIdentifier: String(describing: NowTableMapRouteCell.self))
        register(NowTableCurrentLocationCell.self, forCellReuseIdentifier: String(describing: NowTableCurrentLocationCell.self))
        register(NowTableOpenTopLocationsCell.self, forCellReuseIdentifier: String(describing: NowTableOpenTopLocationsCell.self))
        register(NowTableNoTopLocationsCell.self, forCellReuseIdentifier: String(describing: NowTableNoTopLocationsCell.self))
        
        dataSource = self
        delegate = self
    }
}
