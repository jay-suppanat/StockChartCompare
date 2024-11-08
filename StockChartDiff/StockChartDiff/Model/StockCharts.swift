//
//  StockCharts.swift
//  StockChartDiff
//
//  Created by Suppanat Chinthumrucks on 8/11/2567 BE.
//

// MARK: - WelcomeElement
struct StockChartsData: Codable {
    let date: String
    let open, low, high, close: Double
    let volume: Int

    init() {
        self.date = ""
        self.open = 0.00
        self.low = 0.00
        self.high = 0.00
        self.close = 0.00
        self.volume = 0
    }
}

typealias StockChartsList = [StockChartsData]
