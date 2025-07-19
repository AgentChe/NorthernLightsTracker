//
//  SolarTableElement.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 19.07.2025.
//

import Foundation

final class SolarTableSection {
    let openedElements: [SolarTableElement]
    let closedElements: [SolarTableElement]
    var opened: Bool
    
    init(
        openedElements: [SolarTableElement],
        closedElements: [SolarTableElement],
        opened: Bool
    ) {
        self.openedElements = openedElements
        self.closedElements = closedElements
        self.opened = opened
    }
}

enum SolarTableElement {
    case title(String)
    case image(URL)
    case question(SolarTableQuestionElement)
    case answer(String)
}

struct SolarTableQuestionElement {
    let question: String
    let opened: Bool
}
