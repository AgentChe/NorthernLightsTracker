//
//  SolarTableView.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 19.07.2025.
//

import UIKit

final class SolarTableView: UITableView {
    private lazy var sections = [SolarTableSection]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension SolarTableView {
    func setup(sections: [SolarTableSection]) {
        self.sections = sections
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension SolarTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        let elements = section.opened ? section.openedElements : section.closedElements
        return elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        let elements = section.opened ? section.openedElements : section.closedElements
        
        switch elements[indexPath.row] {
        case .title(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: SolarTableTitleCell.self), for: indexPath) as! SolarTableTitleCell
            cell.setup(element: element)
            return cell
        case .image(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: SolarTableImageCell.self), for: indexPath) as! SolarTableImageCell
            cell.setup(element: element)
            return cell
        case .question(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: SolarTableQuestionCell.self), for: indexPath) as! SolarTableQuestionCell
            cell.setup(element: element)
            return cell
        case .answer(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: SolarTableAnswerCell.self), for: indexPath) as! SolarTableAnswerCell
            cell.setup(element: element)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension SolarTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        let elements = section.opened ? section.openedElements : section.closedElements
        
        guard case .question = elements[indexPath.row] else { return }
        
        section.opened.toggle()
        
        reloadSections(IndexSet(indexPath), with: .automatic)
    }
}

// MARK: Private
private extension SolarTableView {
    func initialize() {
        backgroundColor = UIColor.clear
        contentInset = UIEdgeInsets(b: 8.scale)
        setContentOffset(CGPoint.zero, animated: false)
        showsVerticalScrollIndicator = false
        separatorStyle = .none
        
        register(SolarTableTitleCell.self, forCellReuseIdentifier: String(describing: SolarTableTitleCell.self))
        register(SolarTableImageCell.self, forCellReuseIdentifier: String(describing: SolarTableImageCell.self))
        register(SolarTableQuestionCell.self, forCellReuseIdentifier: String(describing: SolarTableQuestionCell.self))
        register(SolarTableAnswerCell.self, forCellReuseIdentifier: String(describing: SolarTableAnswerCell.self))
        
        dataSource = self
        delegate = self
    }
}
