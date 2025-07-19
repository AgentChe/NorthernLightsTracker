//
//  SolarListViewModel.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 18.07.2025.
//

import RxSwift
import RxCocoa

final class SolarListViewModel {
    enum Action {
        case open(SolarTemplate)
    }
    
    private lazy var forecastManager = ForecastManager()
}

// MARK: Public
extension SolarListViewModel {
    struct Input {
        let didSelect: Signal<SolarTemplate>
    }
    
    struct Output {
        let elements: Driver<[SolarListCollectionElement]>
        let activity: Driver<Bool>
        let action: Driver<Action>
    }
    
    func configure(input: Input) -> Output {
        let activity = RxActivityIndicator()
        
        let templates = makeSolarTemplates(activity: activity)
        
        return Output(
            elements: makeElements(templates: templates),
            activity: activity.asDriver(),
            action: makeAction(didSelect: input.didSelect)
        )
    }
}

// MARK: Private
private extension SolarListViewModel {
    func makeElements(templates: Driver<[SolarTemplate]>) -> Driver<[SolarListCollectionElement]> {
        templates
            .map { templates -> [SolarListCollectionElement] in
                [.title] + templates.map { .template($0) }
            }
    }
    
    func makeSolarTemplates(activity: RxActivityIndicator) -> Driver<[SolarTemplate]> {
        forecastManager
            .obtainSolarTemplates()
            .map { $0 ?? [] }
            .trackActivity(activity)
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeAction(didSelect: Signal<SolarTemplate>) -> Driver<Action> {
        didSelect
            .map { Action.open($0) }
            .asDriver(onErrorDriveWith: .never())
    }
}
