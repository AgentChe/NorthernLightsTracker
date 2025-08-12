//
//  AuroraHeatmapController.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 12.08.2025.
//

import MapKit
import RxSwift

final class AuroraHeatmapController {
    enum Constants {
        static let minAbsLat: Double = 45
        static let refreshSeconds: TimeInterval = 300
        static let desiredCells: ClosedRange<Int> = 1500...4500
    }
    
    deinit {
        disposable?.dispose()
        disposable = nil
    }
    
    private weak var mapView: MKMapView?
    
    private var overlay: AuroraHeatmapOverlay?
    private var cached: [AuroraPoint] = []
    private var lastFetch: Date?
    
    private lazy var auroraManager = AuroraManager()
    
    private var disposable: Disposable?
    
    init(mapView: MKMapView) {
        self.mapView = mapView
    }
}

// MARK: Public
extension AuroraHeatmapController {
    func refresh(forceFetch: Bool = false) {
        let needFetch = forceFetch
        || cached.isEmpty
        || (lastFetch.map { Date().timeIntervalSince($0) > Constants.refreshSeconds } ?? true)

        if needFetch {
            disposable?.dispose()
            disposable = auroraManager
                .obtainRealTimeAuroraPoints()
                .asDriver(onErrorJustReturn: [])
                .drive(Binder(self) { base, pts in
                    base.cached = pts
                    base.lastFetch = Date()
                    base.applyOverlay()
                })
        } else {
            applyOverlay()
        }
    }
}

// MARK: Private
private extension AuroraHeatmapController {
    func applyOverlay() {
        guard let mapView, !cached.isEmpty else { return }

        let northBase = cached.filter { $0.lat >= Constants.minAbsLat && $0.probability > 0 }
        let southBase = cached.filter { $0.lat <= -Constants.minAbsLat && $0.probability > 0 }

        func pickThreshold(values: [Double], maxVal: Double) -> Double {
            guard !values.isEmpty else { return .infinity }
            
            var q = 0.90
            var thr = max(1.0, min(30.0, quantile(values, q)))
            
            func count(_ t: Double) -> Int { values.lazy.filter { $0 >= t }.count }
            
            for _ in 0..<8 {
                let c = count(thr)
                if c < Constants.desiredCells.lowerBound && q >= 0.60 {
                    q -= 0.05; thr = max(0.5, quantile(values, q))
                } else if c > Constants.desiredCells.upperBound && q <= 0.98 {
                    q += 0.03; thr = min(maxVal, quantile(values, q))
                } else { break }
            }
            
            return thr
        }

        let nVals = northBase.map(\.probability)
        let sVals = southBase.map(\.probability)
        let nMax = nVals.max() ?? 0
        let sMax = sVals.max() ?? 0

        let nThr = pickThreshold(values: nVals, maxVal: nMax)
        let sThr = pickThreshold(values: sVals, maxVal: sMax)

        var newOverlays: [AuroraHeatmapOverlay] = []
        if nThr.isFinite, nMax > 0 {
            newOverlays.append(AuroraHeatmapOverlay(points: cached, threshold: nThr, hemisphere: .north, minAbsLat: Constants.minAbsLat))
        }
        if sThr.isFinite, sMax > 0 {
            newOverlays.append(AuroraHeatmapOverlay(points: cached, threshold: sThr, hemisphere: .south, minAbsLat: Constants.minAbsLat))
        }

        DispatchQueue.main.async { [weak self] in
            if let old = self?.overlay { mapView.removeOverlay(old) }
            mapView.overlays.compactMap { $0 as? AuroraHeatmapOverlay }.forEach { mapView.removeOverlay($0) }
            newOverlays.forEach { mapView.addOverlay($0, level: .aboveLabels) }
            self?.overlay = newOverlays.first
        }
    }
    
    func quantile(_ values: [Double], _ q: Double) -> Double {
        guard !values.isEmpty else { return 0 }
        
        let s = values.sorted()
        let i = max(0, min(s.count - 1, Int(Double(s.count - 1) * q)))
        return s[i]
    }
}
