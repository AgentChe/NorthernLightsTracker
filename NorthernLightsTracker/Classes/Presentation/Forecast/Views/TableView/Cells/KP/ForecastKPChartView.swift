//
//  ForecastKPChartView.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 21.07.2025.
//

import UIKit
import DGCharts

final class ForecastKPChartView: UIView {
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
extension ForecastKPChartView {
    func setup(forecast: [ForecastKP.KPTimeValue]) {
        let entries = forecast.map { timeValue -> ChartDataEntry in
            ChartDataEntry(
                x: timeValue.time,
                y: timeValue.value
            )
        }
        
        let set = LineChartDataSet(entries: entries)
        set.mode = .cubicBezier
        set.drawCirclesEnabled = false
        set.lineWidth = 2.scale
        set.setColor(Appearance.main500)
        
        let data = LineChartData(dataSet: set)
        data.setDrawValues(false)

        chartView.data = data
    }
}

// MARK: Private
private extension ForecastKPChartView {
    func initialize() {
        backgroundColor = Appearance.main400
        layer.cornerRadius = 12.scale
        layer.masksToBounds = true
    }
}

// MARK: Make constraints
private extension ForecastKPChartView {
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
private extension ForecastKPChartView {
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
        view.leftAxis.axisMaximum = 9
        view.leftAxis.granularityEnabled = true
        view.leftAxis.granularity = 3
        view.leftAxis.setLabelCount(4, force: true)
        
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
        return "KP \(Int(value))"
    }
}

private class KPXAxisFormatter: NSObject, AxisValueFormatter {
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MMM dd"
        return df
    }()
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let date = Date(timeIntervalSince1970: value)
        return dateFormatter.string(from: date)
    }
}
