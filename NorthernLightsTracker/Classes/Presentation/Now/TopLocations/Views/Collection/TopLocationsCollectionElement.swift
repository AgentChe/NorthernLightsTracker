//
//  TopLocationsCollectionElement.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 24.07.2025.
//

final class TopLocationsCollectionElement {
    let location: AuroraTopLocation
    var selected: Bool
    
    init(location: AuroraTopLocation, selected: Bool) {
        self.location = location
        self.selected = selected
    }
}
