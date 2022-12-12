//
//  BannerViewController.swift
//  PDSDiary
//
//  Created by Groot on 2022/12/05.
//

import UIKit

final class BannerViewController: UIViewController {
    private var selectedDate = Date()
    private var models = [Model]()
    private var currentModels = [Model]()
    private let wiseSayingView = WiseSayingView()
    private let calendarView = CalendarView()
    private let diaryView = DiaryView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        configureView()
        calendarView.configureCalenderView(self)
        diaryView.configureTableView(self)
    }
    
    private func configureNavigation() {
        let font = UIFont.systemFont(ofSize: 15)
        let configuration = UIImage.SymbolConfiguration(font: font)
        let image = UIImage(systemName: "plus.app", withConfiguration: configuration)?.withRenderingMode(.alwaysOriginal)
        
        let plusButton = UIBarButtonItem(title: nil, image: image?.withTintColor(.systemRed), target: self, action: #selector(didTapPlusButton))
        navigationItem.title = "성공이의 하루"
        navigationItem.rightBarButtonItem = plusButton
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    @objc
    private func didTapPlusButton() {
        let alertController = UIAlertController(title: "계획 추가", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        alertController.textFields?.first?.font = .preferredFont(forTextStyle: .body, compatibleWith: .none)
        
        let closeAction = UIAlertAction(title: "취소", style: .cancel)
        let addAction = UIAlertAction(title: "추가", style: .default) { [weak self] _ in
            guard let input = alertController.textFields?[0].text,
                  let date = self?.selectedDate else { return }
            
            self?.models.append(Model(date: date.convertCurrenDate(),
                                        plan: input,
                                        doing: "실행",
                                        feedback: "평가",
                                        grade: .none))
            
            self?.diaryView.reloadData()
        }
        
        alertController.addAction(closeAction)
        alertController.addAction(addAction)
        
        present(alertController, animated: true)
    }
    
    private func configureView() {
        let mainStackView = UIStackView()
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .vertical
        mainStackView.spacing = 16
        
        view.backgroundColor = .systemGray6
        view.addSubview(mainStackView)
        [wiseSayingView, calendarView, diaryView].forEach { mainStackView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            diaryView.heightAnchor.constraint(equalTo: mainStackView.heightAnchor, multiplier: 0.32)
        ])
    }
}

extension BannerViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let date = dateComponents?.date else { return }
        
        selectedDate = date
        diaryView.reloadData()
    }
}

extension BannerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currentModels = models.filter { $0.date.convert() == selectedDate.convert() }
        
        return currentModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Diary", for: indexPath) as? DiaryTableViewCell else { return UITableViewCell() }

        cell.configureItems(currentModels[indexPath.row].plan,
                            grade: currentModels[indexPath.row].grade)
        
        return cell
    }
}

extension BannerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let viewController = PlanUpdateViewController()
        viewController.delegate = self
        viewController.configureItem(currentModels[indexPath.row])
        
        present(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteSwipeAction = UIContextualAction(style: .destructive, title: "삭제", handler: { [weak self] _, _, completionHaldler in
            guard let date = self?.currentModels[indexPath.row].date,
                  let deletedModels = self?.models.filter ({ $0.date != date }) else { return }
            
            self?.models = deletedModels
            self?.diaryView.reloadData()
            
            completionHaldler(true)
        })
        
        return UISwipeActionsConfiguration(actions: [deleteSwipeAction])
    }
}

extension BannerViewController: PlanUpdateViewControllerDelegate {
    func planUpdateViewController(_ updateModel: Model) {
        models = models.filter { $0.date != updateModel.date }
        models.append(updateModel)
        
        diaryView.reloadData()
    }
}
