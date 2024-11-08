//
//  ViewController.swift
//  StockChartDiff
//
//  Created by Suppanat Chinthumrucks on 8/11/2567 BE.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
    }

    override func viewWillAppear(_ animated: Bool) {
        self.requestStockChart()
    }

    private var stockChart: StockChartsList = StockChartsList()

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.backgroundColor = .clear
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.separatorStyle = .none
            self.tableView.register(HeaderChartTableViewCell.nib, forCellReuseIdentifier: HeaderChartTableViewCell.identifier)

        }
    }

    private func requestStockChart() {
        APIClient.getStockChartData { response in
            self.stockChart = response.reversed()
            self.tableView.reloadData()
        }
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: HeaderChartTableViewCell.identifier, for: indexPath) as! HeaderChartTableViewCell
            cell.setupChartData(data: self.stockChart)
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.requestStockChart()
    }
}

