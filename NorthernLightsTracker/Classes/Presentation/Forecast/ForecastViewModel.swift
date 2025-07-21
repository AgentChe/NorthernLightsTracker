//
//  ForecastViewModel.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 20.07.2025.
//

import RxSwift
import RxCocoa

final class ForecastViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    private lazy var forecastManager = ForecastManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Public
extension ForecastViewModel {
    struct Input {}
    
    struct Output {
        let elements: Driver<[ForecastTableElement]>
        let activity: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        let activity = RxActivityIndicator()
        
        let forecast = makeForecast(activity: activity)
        
        return Output(
            elements: makeElements(forecast: forecast),
            activity: activity.asDriver()
        )
    }
}

// MARK: Private
private extension ForecastViewModel {
    func makeElements(forecast: Driver<Forecast>) -> Driver<[ForecastTableElement]> {
        forecast
            .map { forecast -> [ForecastTableElement] in
                var elements = [ForecastTableElement?]()
                
                let aurora: ForecastTableElement? = {
                    guard let aurora = forecast.aurora else { return nil }
                    
                    return ForecastTableElement(
                        element: .aurora(aurora),
                        opened: true
                    )
                }()
                elements.append(aurora)
                
                let kp: ForecastTableElement? = {
                    guard let kp = forecast.kp else { return nil }
                    
                    return ForecastTableElement(
                        element: .kpIndex(kp),
                        opened: true
                    )
                }()
                elements.append(kp)
                
                let cloudCover: ForecastTableElement? = {
                    guard let cloudCover = forecast.cloudCover else { return nil }
                    
                    return ForecastTableElement(
                        element: .cloudCover(cloudCover),
                        opened: true
                    )
                }()
                elements.append(cloudCover)
                
                let moonPhase: ForecastTableElement? = {
                    guard let moonPhase = forecast.moonPhase else { return nil }
                    
                    return ForecastTableElement(
                        element: .moonPhase(moonPhase),
                        opened: true
                    )
                }()
                elements.append(moonPhase)
                
                let solarWind: ForecastTableElement? = {
                    guard let solarWind = forecast.solarWind else { return nil }
                    
                    return ForecastTableElement(
                        element: .solarWind(solarWind),
                        opened: true
                    )
                }()
                elements.append(solarWind)
                
                let hemisphericPower: ForecastTableElement? = {
                    guard let hemisphericPower = forecast.hemisphericPower else { return nil }
                    
                    return ForecastTableElement(
                        element: .hemisphericPower(hemisphericPower),
                        opened: true
                    )
                }()
                elements.append(hemisphericPower)
                
                let planetaryA: ForecastTableElement? = {
                    guard let planetaryA = forecast.planetaryA else { return nil }
                    
                    return ForecastTableElement(
                        element: .planetaryA(planetaryA),
                        opened: true
                    )
                }()
                elements.append(planetaryA)
                
                return elements.compactMap { $0 }
            }
    }
    
    func makeForecast(activity: RxActivityIndicator) -> Driver<Forecast> {
        func source() -> Single<Forecast> {
            forecastManager
                .obtainForecast()
                .map { forecast -> Forecast in
                    guard let forecast else {
                        throw ContentError(.notContent)
                    }
                    
                    return forecast
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
