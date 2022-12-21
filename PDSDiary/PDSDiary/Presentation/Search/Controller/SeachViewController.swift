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
    private var searchWord = ""
    var manager: PDSDiaryManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureSearchBar()
    }
    
    private func fetch() {
        guard let manager = manager else { return }
        models.removeAll()
        
        Task {
            let fetchData = await manager.useCase.read()
            switch fetchData {
            case .success(let fetchModels):
                makeSerchModels(fetchModels)
                DispatchQueue.main.async {
                    self.diaryView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func makeSerchModels(_ fetchModels: [DiaryModel]) {
        fetchModels.filter { $0.plan.lowercased().contains(searchWord) }
            .sorted { $0.date < $1.date }
            .forEach {
                if $0.date.convertOnlyYearMonthDay() != models.last?.last?.date.convertOnlyYearMonthDay() {
                    models.append([$0])
                    
                    return
                } else if models.count > 0 {
                    models[models.count - 1].append($0)
                }
            }
    }
    
    private func configureSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "검색 할 계획을 입력하세요"
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewController = UpdateViewController()
        viewController.delegate = self
        viewController.configureItem(models[indexPath.section][indexPath.row])
        present(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteSwipeAction = UIContextualAction(style: .destructive, title: "삭제", handler: { [weak self] _, _, completionHaldler in
            guard let date = self?.models[indexPath.section][indexPath.row].date else { return }
            
            Task {
                await self?.manager?.useCase.delete(date: date)
                self?.fetch()
            }
            
            completionHaldler(true)
        })
        
        return UISwipeActionsConfiguration(actions: [deleteSwipeAction])
    }
}

extension SeachViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        searchWord = text
        fetch()
    }
}

extension SeachViewController: UpdateViewControllerDelegate {
    func updateViewController(_ updateModel: DiaryModel) {
        Task {
            await manager?.useCase.update(updateModel)
            fetch()
        }
    }
}
