//
//  ForecastTableView.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 20.07.2025.
//

import UIKit

final class ForecastTableView: UITableView {
    private lazy var elements = [ForecastTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ForecastTableView {
    func setup(elements: [ForecastTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension ForecastTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = elements[indexPath.row]
        
        switch element.element {
        case .aurora(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ForecastAuroraCell.self), for: indexPath) as! ForecastAuroraCell
            cell.setup(element: element)
            return cell
        case .kpIndex(let kp):
            switch element.opened {
            case false:
                let cell = dequeueReusableCell(withIdentifier: String(describing: ForecastExpandableTitleCell.self), for: indexPath) as! ForecastExpandableTitleCell
                cell.setup(element: .kp)
                cell.didTap = { [weak self] in
                    self?.expand(indexPath: indexPath)
                }
                return cell
            case true:
                let cell = dequeueReusableCell(withIdentifier: String(describing: ForecastKPCell.self), for: indexPath) as! ForecastKPCell
                cell.setup(element: kp)
                cell.didTap = { [weak self] in
                    self?.expand(indexPath: indexPath)
                }
                return cell
            }
        case .cloudCover(let cloudCover):
            switch element.opened {
            case false:
                let cell = dequeueReusableCell(withIdentifier: String(describing: ForecastExpandableTitleCell.self), for: indexPath) as! ForecastExpandableTitleCell
                cell.setup(element: .cloudCover)
                cell.didTap = { [weak self] in
                    self?.expand(indexPath: indexPath)
                }
                return cell
            case true:
                let cell = dequeueReusableCell(withIdentifier: String(describing: ForecastCloudCoverCell.self), for: indexPath) as! ForecastCloudCoverCell
                cell.setup(element: cloudCover)
                cell.didTap = { [weak self] in
                    self?.expand(indexPath: indexPath)
                }
                return cell
            }
        case .moonPhase(let moonPhase):
            switch element.opened {
            case false:
                let cell = dequeueReusableCell(withIdentifier: String(describing: ForecastExpandableTitleCell.self), for: indexPath) as! ForecastExpandableTitleCell
                cell.setup(element: .moonPhase)
                cell.didTap = { [weak self] in
                    self?.expand(indexPath: indexPath)
                }
                return cell
            case true:
                let cell = dequeueReusableCell(withIdentifier: String(describing: ForecastMoonPhaseCell.self), for: indexPath) as! ForecastMoonPhaseCell
                cell.setup(element: moonPhase)
                cell.didTap = { [weak self] in
                    self?.expand(indexPath: indexPath)
                }
                return cell
            }
        case .solarWind(let solarWind):
            switch element.opened {
            case false:
                let cell = dequeueReusableCell(withIdentifier: String(describing: ForecastExpandableTitleCell.self), for: indexPath) as! ForecastExpandableTitleCell
                cell.setup(element: .solarWind)
                cell.didTap = { [weak self] in
                    self?.expand(indexPath: indexPath)
                }
                return cell
            case true:
                let cell = dequeueReusableCell(withIdentifier: String(describing: ForecastSolarWindCell.self), for: indexPath) as! ForecastSolarWindCell
                cell.setup(element: solarWind)
                cell.didTap = { [weak self] in
                    self?.expand(indexPath: indexPath)
                }
                return cell
            }
        case .hemisphericPower(let hemisphericPower):
            switch element.opened {
            case false:
                let cell = dequeueReusableCell(withIdentifier: String(describing: ForecastExpandableTitleCell.self), for: indexPath) as! ForecastExpandableTitleCell
                cell.setup(element: .hemisphericPower)
                cell.didTap = { [weak self] in
                    self?.expand(indexPath: indexPath)
                }
                return cell
            case true:
                let cell = dequeueReusableCell(withIdentifier: String(describing: ForecastHemisphericPowerCell.self), for: indexPath) as! ForecastHemisphericPowerCell
                cell.setup(element: hemisphericPower)
                cell.didTap = { [weak self] in
                    self?.expand(indexPath: indexPath)
                }
                return cell
            }
        case .planetaryA(let planetaryA):
            switch element.opened {
            case false:
                let cell = dequeueReusableCell(withIdentifier: String(describing: ForecastExpandableTitleCell.self), for: indexPath) as! ForecastExpandableTitleCell
                cell.setup(element: .planetaryA)
                cell.didTap = { [weak self] in
                    self?.expand(indexPath: indexPath)
                }
                return cell
            case true:
                let cell = dequeueReusableCell(withIdentifier: String(describing: ForecastPlanetaryACell.self), for: indexPath) as! ForecastPlanetaryACell
                cell.setup(element: planetaryA)
                cell.didTap = { [weak self] in
                    self?.expand(indexPath: indexPath)
                }
                return cell
            }
        }
    }
}

// MARK: UITableViewDelegate
extension ForecastTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch elements[indexPath.row].element {
        case .aurora:
            return 155.scale
        default:
            return UITableView.automaticDimension
        }
    }
}

// MARK: Private
private extension ForecastTableView {
    func initialize() {
        backgroundColor = UIColor.clear
        showsVerticalScrollIndicator = false
        contentInset = UIEdgeInsets(vertical: 16.scale)
        setContentOffset(CGPoint(x: 0, y: 16.scale), animated: false)
        separatorStyle = .none
        
        register(ForecastAuroraCell.self, forCellReuseIdentifier: String(describing: ForecastAuroraCell.self))
        register(ForecastExpandableTitleCell.self, forCellReuseIdentifier: String(describing: ForecastExpandableTitleCell.self))
        register(ForecastKPCell.self, forCellReuseIdentifier: String(describing: ForecastKPCell.self))
        register(ForecastCloudCoverCell.self, forCellReuseIdentifier: String(describing: ForecastCloudCoverCell.self))
        register(ForecastMoonPhaseCell.self, forCellReuseIdentifier: String(describing: ForecastMoonPhaseCell.self))
        register(ForecastSolarWindCell.self, forCellReuseIdentifier: String(describing: ForecastSolarWindCell.self))
        register(ForecastHemisphericPowerCell.self, forCellReuseIdentifier: String(describing: ForecastHemisphericPowerCell.self))
        register(ForecastPlanetaryACell.self, forCellReuseIdentifier: String(describing: ForecastPlanetaryACell.self))
        
        dataSource = self
        delegate = self
    }
    
    func expand(indexPath: IndexPath) {
        elements[indexPath.row].opened.toggle()
        
        reloadRows(at: [indexPath], with: .automatic)
    }
}
