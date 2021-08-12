//
//  ExchangeRatesTableViewController.swift
//  Exchange Rates
//
//  Created by Vladislav Sitsko on 12.08.21.
//

import UIKit

class ExchangeRatesTableViewController: UITableViewController {

    private lazy var viewModel = ExchangeRatesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerHeaderFooter(ExchangeRateTableHeaderView.self)
        tableView.register(ExchangeRateTableViewCell.self)
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(fetchItems), for: .valueChanged)
        tableView.refreshControl?.beginRefreshing()
        fetchItems()
    }
    
    private func showError(error: Error) {
        let alert = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
        self.present(alert, animated: true)
    }
    
    @objc
    private func fetchItems() {
        viewModel.fetchItems { [weak self] result in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self?.tableView.refreshControl?.endRefreshing()
                switch result {
                case .success():
                    self?.tableView.reloadData()
                case .failure(let error):
                    self?.showError(error: error)
                }
            }
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ExchangeRateTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.item = viewModel.items[safe: indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooter(ExchangeRateTableHeaderView.self)
    }
}
