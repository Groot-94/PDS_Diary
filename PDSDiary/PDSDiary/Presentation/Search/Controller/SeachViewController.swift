//
//  SeachViewController.swift
//  PDSDiary
//
//  Created by Groot on 2022/12/20.
//

import UIKit

final class SeachViewController: UIViewController {
    private var models = [[DiaryModel]]()
    private let diaryView = DiaryView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureSearchBar()
    }
    
    private func configureSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "검색 할 계획명을 입력하세요"
        searchController.searchBar.showsCancelButton = false
        searchController.searchResultsUpdater = self
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController?.hidesNavigationBarDuringPresentation = false
        navigationItem.title = "계획 검색"
    }
    
    private func configureView() {
        view.backgroundColor = .systemGray6
        view.addSubview(diaryView)
        diaryView.configureTableView(self)
        
        NSLayoutConstraint.activate([
            diaryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            diaryView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            diaryView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            diaryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
}

extension SeachViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Diary", for: indexPath) as? DiaryTableViewCell else { return UITableViewCell() }
        cell.configureItems(models[indexPath.section][indexPath.row].plan, grade: models[indexPath.section][indexPath.row].grade)
        
        return cell
    }
}

extension SeachViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let date = models[section].first?.date else { return nil }
        let label = UILabel()
        label.text = date.convertHangul()
        label.font = .preferredFont(forTextStyle: .body)
        
        return label
    }
}

extension SeachViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        let filteredModels = Models.shared.data
            .filter { $0.plan.lowercased().contains(text) }
            .sorted { $0.date < $1.date }
        
        filteredModels.enumerated().forEach {
            let index = $0.offset
            if filteredModels[index].date.convertOnlyYearMonthDay() != models.last?.last?.date.convertOnlyYearMonthDay() {
                models.append([filteredModels[index]])
                return
            } else if models.count > 0 {
                models[models.count - 1].append(filteredModels[index])
            }
        }
        
        if filteredModels.count == 0 {
            models.removeAll()
        }
        
        diaryView.reloadData()
    }
}
