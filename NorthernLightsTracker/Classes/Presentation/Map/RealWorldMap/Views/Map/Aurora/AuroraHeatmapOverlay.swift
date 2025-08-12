//
//  AuroraHeatmapOverlay.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 12.08.2025.
//

import MapKit

enum Hemisphere { case north, south, both }

final class AuroraHeatmapOverlay: NSObject, MKOverlay {
    let cells: [AuroraCell]
    let boundingMapRect: MKMapRect
    let coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    init(points: [AuroraPoint], threshold: Double, hemisphere: Hemisphere, minAbsLat: Double = 40) {
        var list: [AuroraCell] = []
        var union = MKMapRect.null
        
        var localMax = threshold
        for p in points {
            let inHem: Bool = {
                switch hemisphere {
                case .north: return p.lat >= minAbsLat
                case .south: return p.lat <= -minAbsLat
                case .both:  return abs(p.lat) >= minAbsLat
                }
            }()
            if inHem, p.probability > localMax { localMax = p.probability }
        }
        
        for p in points {
            let inHem: Bool = {
                switch hemisphere {
                case .north: return p.lat >= minAbsLat
                case .south: return p.lat <= -minAbsLat
                case .both:  return abs(p.lat) >= minAbsLat
                }
            }()
            guard inHem, p.probability >= threshold, p.lat < 90 else { continue }
            
            let w = normalizeLon(p.lon)
            let e = w + 1.0
            let s = p.lat
            let n = p.lat + 1.0
            
            let sw = MKMapPoint(.init(latitude: s, longitude: w))
            let ne = MKMapPoint(.init(latitude: n, longitude: e))
            let rect = MKMapRect(x: min(sw.x, ne.x),
                                 y: min(sw.y, ne.y),
                                 width: abs(ne.x - sw.x),
                                 height: abs(ne.y - sw.y))
            
            let t = (p.probability - threshold) / max(1e-6, (localMax - threshold))
            let intensity = max(0, min(1, pow(t, 0.7)))
            list.append(AuroraCell(mapRect: rect, intensity: intensity))
            union = union.isNull ? rect : union.union(rect)
        }
        
        self.cells = list
        self.boundingMapRect = union.isNull ? .world : union
        super.init()
    }
}

private func normalizeLon(_ lon: Double) -> Double { lon >= 180 ? lon - 360 : lon }
