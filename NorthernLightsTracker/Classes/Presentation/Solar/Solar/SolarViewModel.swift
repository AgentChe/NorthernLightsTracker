//
//  SolarViewModel.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 18.07.2025.
//

import RxSwift
import RxCocoa

final class SolarViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    private let template: Driver<SolarTemplate>
    
    private lazy var forecastManager = ForecastManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    init(template: SolarTemplate) {
        self.template = BehaviorRelay(value: template).asDriver()
    }
}

// MARK: Public
extension SolarViewModel {
    struct Input {}
    
    struct Output {
        let sections: Driver<[SolarTableSection]>
        let activity: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        let activity = RxActivityIndicator()
        
        let solar = makeSolar(
            template: template,
            activity: activity
        )
        
        return Output(
            sections: makeSections(solar: solar),
            activity: activity.asDriver()
        )
    }
}

// MARK: Private
private extension SolarViewModel {
    func makeSections(solar: Driver<Solar>) -> Driver<[SolarTableSection]> {
        solar
            .map { solar -> [SolarTableSection] in
                var sections = [SolarTableSection]()
                
                let title = SolarTableSection(
                    openedElements: [
                        .title(solar.description),
                        .image(solar.image)
                    ],
                    closedElements: [],
                    opened: true
                )
                sections.append(title)
                
                solar.faq.enumerated().forEach { index, faq in
                    let section = SolarTableSection(
                        openedElements: [
                            .question(SolarTableQuestionElement(
                                question: faq.question,
                                opened: true
                            )),
                            .answer(faq.answer)
                        ],
                        closedElements: [
                            .question(SolarTableQuestionElement(
                                question: faq.question,
                                opened: false
                            ))
                        ],
                        opened: index == 0
                    )
                    sections.append(section)
                }
                
                return sections
            }
    }
    
    func makeSolar(
        template: Driver<SolarTemplate>,
        activity: RxActivityIndicator
    ) -> Driver<Solar> {
        template
            .flatMapLatest { [weak self] template -> Driver<Solar> in
                guard let self else { return .never() }
                
                func source() -> Single<Solar> {
                    forecastManager
                        .obtainSolar(id: template.id)
                        .map { solar -> Solar in
                            guard let solar else {
                                throw ContentError(.notContent)
                            }
                            
                            return solar
                        }
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    tryAgain?(error) ?? .empty()
                }
                
                return observableRetrySingle
                    .retry(
                        source: { source() },
                        trigger: { trigger(error: $0) }
                    )
                    .trackActivity(activity)
                    .asDriver(onErrorDriveWith: .never())
            }
    }
}
