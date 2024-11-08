//
//  APIClient.swift
//  StockChartDiff
//
//  Created by Suppanat Chinthumrucks on 8/11/2567 BE.
//

import Foundation
import UIKit

enum APIClient {
    static func getStockChartData(completion: @escaping (StockChartsList) -> Void) {
        if let url = Bundle.main.url(forResource: "aapl_chart", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(StockChartsList.self, from: data)
                completion(jsonData)
            } catch {
                print("error:\(error)")
            }
        }
    }

    static func getCurrentDateToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian) as Calendar?
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+7")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: APIClient.getDate()!)
    }

    static func getDate(dateString: String = "2023-08-11") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+7")
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.date(from: dateString)
    }

    static func checkIsTodayDate(dateString: String) -> Bool {
        if dateString.contains(APIClient.getCurrentDateToString()) {
            return true
        } else {
            return false
        }
    }
}
