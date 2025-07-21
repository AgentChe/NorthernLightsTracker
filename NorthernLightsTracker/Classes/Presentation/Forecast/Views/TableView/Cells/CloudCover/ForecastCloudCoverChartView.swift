//
//  ForecastCloudCoverChartView.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 21.07.2025.
//

import UIKit
import DGCharts

final class ForecastCloudCoverChartView: UIView {
    lazy var chartView = makeChartView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ForecastCloudCoverChartView {
    func setup(forecast: [ForecastCloudCover.KPTimeCover]) {
        let entries = forecast.map { timeCover -> ChartDataEntry in
            ChartDataEntry(
                x: Double(timeCover.time),
                y: Double(timeCover.cover)
            )
        }.sorted { $0.x < $1.x }
        
        let set = LineChartDataSet(entries: entries)
        set.mode = .cubicBezier
        set.drawCirclesEnabled = false
        set.lineWidth = 2.scale
        set.setColor(Appearance.main300)
        
        set.drawFilledEnabled = true
        set.fillColor = Appearance.main300
        set.fillAlpha = 1
        
        let data = LineChartData(dataSet: set)
        data.setDrawValues(false)

        chartView.data = data
    }
}

// MARK: Private
private extension ForecastCloudCoverChartView {
    func initialize() {
        backgroundColor = Appearance.main400
        layer.cornerRadius = 12.scale
        layer.masksToBounds = true
    }
}

// MARK: Make constraints
private extension ForecastCloudCoverChartView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            chartView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            chartView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            chartView.topAnchor.constraint(equalTo: topAnchor, constant: 16.scale),
            chartView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ForecastCloudCoverChartView {
    func makeChartView() -> LineChartView {
        let view = LineChartView()
        view.backgroundColor = UIColor.clear
        view.chartDescription.enabled = false
        view.legend.enabled = false
        view.pinchZoomEnabled = false
        view.doubleTapToZoomEnabled = false
        view.dragEnabled = false
        view.drawMarkers = false
        
        view.leftAxis.enabled = true
        view.leftAxis.drawGridLinesEnabled = true
        view.leftAxis.gridLineDashLengths = [2.scale, 2.scale]
        view.leftAxis.gridColor = Appearance.mono100.withAlphaComponent(0.5)
        view.leftAxis.gridLineWidth = 0.5.scale
        view.leftAxis.drawAxisLineEnabled = false
        view.leftAxis.labelFont = Fonts.IBMPlexSans.regular(size: 12.scale)
        view.leftAxis.labelTextColor = Appearance.mono100.withAlphaComponent(0.5)
        view.leftAxis.valueFormatter = KPLeftAxisFormatter()
        view.leftAxis.axisMinimum = 0
        view.leftAxis.axisMaximum = 100
        view.leftAxis.granularityEnabled = true
        view.leftAxis.granularity = 50
        view.leftAxis.setLabelCount(3, force: true)
        
        view.xAxis.enabled = true
        view.xAxis.drawGridLinesEnabled = false
        view.xAxis.drawAxisLineEnabled = false
        view.xAxis.labelPosition = .bottom
        view.xAxis.labelFont = Fonts.IBMPlexSans.regular(size: 12.scale)
        view.xAxis.labelTextColor = Appearance.mono100.withAlphaComponent(0.5)
        view.xAxis.valueFormatter = KPXAxisFormatter()
        
        view.rightAxis.enabled = false
        
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

private class KPLeftAxisFormatter: NSObject, AxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return "\(Int(value))%"
    }
}

private class KPXAxisFormatter: NSObject, AxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let seconds = Int(value)
        let hours = seconds / 3600
        return String(format: "%02dh", hours)
    }
}
