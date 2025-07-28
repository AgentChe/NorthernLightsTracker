//
//  AuroraOvalLayerViewModel.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 28.07.2025.
//

import RxSwift
import RxCocoa

final class AuroraOvalLayerViewModel {
    private lazy var auroraManager = AuroraManager()
}

// MARK: Public
extension AuroraOvalLayerViewModel {
    struct Input {}
    
    struct Output {
        let activity: Driver<Bool>
        let elements: Driver<[AuroraOvalLayerTableElement]>
    }
    
    func configure(input: Input) -> Output {
        let activity = RxActivityIndicator()
        
        return Output(
            activity: activity.asDriver(),
            elements: makeElements(activity: activity)
        )
    }
}

// MARK: Private
private extension AuroraOvalLayerViewModel {
    func makeElements(activity: RxActivityIndicator) -> Driver<[AuroraOvalLayerTableElement]> {
        auroraManager
            .obtainAuroraMapOval()
            .trackActivity(activity)
            .asDriver(onErrorJustReturn: nil)
            .map { auroraMapOval -> [AuroraOvalLayerTableElement] in
                guard let auroraMapOval else { return [] }
                
                var elements = [AuroraOvalLayerTableElement]()
                
                if let url = auroraMapOval.north {
                    let element = AuroraOvalLayerTableElement(
                        title: "AuroraOvalLayer.North".localized,
                        url: url
                    )
                    elements.append(element)
                }
                
                if let url = auroraMapOval.south {
                    let element = AuroraOvalLayerTableElement(
                        title: "AuroraOvalLayer.South".localized,
                        url: url
                    )
                    elements.append(element)
                }
                
                return elements
            }
    }
}
