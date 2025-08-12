//
//  AuroraHeatmapRenderer.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 12.08.2025.
//

import MapKit

final class AuroraHeatmapRenderer: MKOverlayRenderer {
    private let cells: [AuroraCell]
    
    init(overlay: MKOverlay, cells: [AuroraCell]) {
        self.cells = cells
        
        super.init(overlay: overlay)
        
        alpha = 1
    }

    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in ctx: CGContext) {
        ctx.setAllowsAntialiasing(false)
        
        for c in cells where c.mapRect.intersects(mapRect) {
            let r = rect(for: c.mapRect)
            let a = CGFloat(0.15 + 0.85 * c.intensity)
            ctx.setFillColor(UIColor(hue: 120/360.0, saturation: 0.85, brightness: 0.9, alpha: a).cgColor)
            ctx.fill(r)
        }
    }
}
