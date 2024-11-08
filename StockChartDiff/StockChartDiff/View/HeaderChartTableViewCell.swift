//
//  HeaderChartTableViewCell.swift
//  StockChartDiff
//
//  Created by Suppanat Chinthumrucks on 8/11/2567 BE.
//

import Charts
import DGCharts
import UIKit

class HeaderChartTableViewCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupLineChart()
        self.applyThemes()
    }

    static var nib: UINib {
        UINib(nibName: identifier, bundle: nil)
    }

    static var identifier: String {
        String(describing: self)
    }

    private var priceMax: Double = 0.00
    private var priceMin: Double = 0.00

    private var chartDataEntry: [ChartDataEntry] = []

    @IBOutlet var chartView: LineChartView!

    public func setupChartData(data: StockChartsList) {
        var dataSets: [LineChartDataSet] = []

        self.priceMin = data.map({ $0.open }).min() ?? 0.00
        self.priceMax = data.map({ $0.open }).max() ?? 0.00

        let todayOpenPrice = data.filter { data in
            data.date.contains(APIClient.getCurrentDateToString())
        }.first?.open ?? 0.00

        for (index, item) in data.enumerated() {
            var dataSet: LineChartDataSet = LineChartDataSet()

            if index == data.endIndex - 1 {
                dataSet = LineChartDataSet(entries: [ChartDataEntry(x: Double(index), y: item.open)])
            } else {
                dataSet = LineChartDataSet(entries: [ChartDataEntry(x: Double(index), y: item.open), ChartDataEntry(x: Double(index + 1), y: data[index + 1].open)])
            }
            if APIClient.checkIsTodayDate(dateString: item.date) {
                if item.open > todayOpenPrice {
                    dataSet.colors = [.green]
                } else if item.open < todayOpenPrice {
                    dataSet.colors = [.red]
                } else {
                    dataSet.colors = [.green]
                }
            } else {
                dataSet.colors = [.white]
            }

            dataSet.drawCirclesEnabled = false
            dataSet.mode = .cubicBezier
            dataSet.lineWidth = 2
            dataSets.append(dataSet)
        }

        let yAxis = self.chartView.leftAxis
        yAxis.axisMaximum = self.priceMax
        yAxis.axisMinimum = self.priceMin

        let data = LineChartData(dataSets: dataSets)
        self.chartView.data = data
    }

    private func applyThemes() {
        self.contentView.backgroundColor = .black
        self.backgroundColor = .black
    }

    private func setupLineChart() {
        self.chartView.pinchZoomEnabled = false
        self.chartView.dragEnabled = false
        self.chartView.doubleTapToZoomEnabled = false
        self.chartView.legend.enabled = false
        self.chartView.backgroundColor = .black
        self.chartView.rightAxis.enabled = false

        let xAxis = self.chartView.xAxis
        xAxis.drawAxisLineEnabled = true
        xAxis.drawGridLinesEnabled = false
        xAxis.drawLabelsEnabled = false
        xAxis.granularity = 1
        xAxis.setLabelCount(0, force: false)

        let yAxis = self.chartView.leftAxis
        yAxis.drawGridLinesEnabled = false
        yAxis.drawGridLinesBehindDataEnabled = false
        yAxis.drawAxisLineEnabled = false
        yAxis.labelTextColor = .white
        xAxis.setLabelCount(4, force: false)
    }
}
