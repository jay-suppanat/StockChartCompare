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
                    dataSet.colors = [.yellow]
                }
            } else {
                dataSet.colors = [.black]
            }

            dataSet.drawCirclesEnabled = false
            dataSet.mode = .cubicBezier
            dataSet.lineWidth = 1

            dataSets.append(dataSet)
        }

        

        let data = LineChartData(dataSets: dataSets)

        self.chartView.data = data
    }

    private func setupLineChart() {
        self.chartView.backgroundColor = .white
        self.chartView.pinchZoomEnabled = false
        self.chartView.dragEnabled = false
        self.chartView.doubleTapToZoomEnabled = false
        self.chartView.legend.enabled = false

        let xAxis = self.chartView.xAxis
        xAxis.drawAxisLineEnabled = true
        xAxis.drawGridLinesEnabled = false
        xAxis.granularity = 1

        let yAxis = self.chartView.leftAxis
        yAxis.drawGridLinesEnabled = false
        yAxis.drawGridLinesBehindDataEnabled = false
    }
}
