//
//  AuroraOvalLayerTableView.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 28.07.2025.
//

import UIKit

final class AuroraOvalLayerTableView: UITableView {
    private lazy var elements = [AuroraOvalLayerTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension AuroraOvalLayerTableView {
    func setup(elements: [AuroraOvalLayerTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension AuroraOvalLayerTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: String(describing: AuroraOvalLayerCell.self)) as! AuroraOvalLayerCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UITableViewDelegate
extension AuroraOvalLayerTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        404.scale
    }
}

// MARK: Private
private extension AuroraOvalLayerTableView {
    func initialize() {
        backgroundColor = UIColor.clear
        separatorStyle = .none
        showsVerticalScrollIndicator = false
        contentInset = UIEdgeInsets(b: 24.scale)
        setContentOffset(CGPoint.zero, animated: false)
        
        register(AuroraOvalLayerCell.self, forCellReuseIdentifier: String(describing: AuroraOvalLayerCell.self))
        
        dataSource = self
        delegate = self
    }
}
