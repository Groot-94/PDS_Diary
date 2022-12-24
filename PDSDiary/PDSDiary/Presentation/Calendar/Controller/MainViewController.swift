//
//  BannerViewController.swift
//  PDSDiary
//
//  Created by Groot on 2022/12/05.
//

import UIKit

final class MainViewController: UIViewController {
    private var selectedDate = Date()
    private var manager = Manager()
    private var models = [DiaryModel]()
    private let wiseSayingView = WiseSayingView()
    private let calendarView = CalendarView()
    private let diaryView = DiaryView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetch()
    }
    
    private func fetch() {
        Task {
            let fetchData = await manager.useCase.read()
            switch fetchData {
            case .success(let fetchModels):
                self.models = fetchModels.filter { $0.date.convertOnlyYearMonthDay() == selectedDate.convertOnlyYearMonthDay() }
                DispatchQueue.main.async {
                    self.diaryView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc
    private func didTapPlusButton() {
        present(makeAlertController(), animated: true)
    }
    
    private func makeAlertController() -> UIAlertController {
        let alertController = UIAlertController(title: "계획 추가", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        alertController.textFields?.first?.font = .preferredFont(forTextStyle: .body, compatibleWith: .none)
        let closeAction = UIAlertAction(title: "취소", style: .cancel)
        let addAction = UIAlertAction(title: "추가", style: .default) { [weak self] _ in
            guard let input = alertController.textFields?[0].text,
                  let date = self?.selectedDate else { return }
            Task {
                await self?.createNewModel(plan: input, date: date)
            }
        }
        alertController.addAction(closeAction)
        alertController.addAction(addAction)
        return alertController
    }
    
    private func createNewModel(plan: String, date: Date) async {
        await self.manager.useCase.create(model: DiaryModel(date: date.convertToCurrenTime(),
                                                            plan: plan,
                                                            doing: "실행내용을 작성하세요.",
                                                            feedback: "평가를 작성하세요.",
                                                            grade: .none))
        self.fetch()
    }
    
    @objc
    private func didTapSearchButton() {
        navigationController?.pushViewController(makeSeachViewController() , animated: true)
    }
    
    private func makeSeachViewController() -> SeachViewController {
        let viewController = SeachViewController()
        viewController.manager = manager
        return viewController
    }
    
    private func configureNavigation() {
        let searchButton = UIBarButtonItem(title: nil,
                                           image: makeImage(systemName: "magnifyingglass.circle"),
                                           target: self,
                                           action: #selector(didTapSearchButton))
        let plusButton = UIBarButtonItem(title: nil, image: makeImage(systemName: "plus.app"),
                                         target: self,
                                         action: #selector(didTapPlusButton))
        let backButton = UIBarButtonItem(title: nil, image: makeImage(systemName: "arrow.uturn.backward.circle"),
                                         target: self,
                                         action: nil)
        
        navigationItem.title = "PDS Diary"
        navigationItem.leftBarButtonItem = searchButton
        navigationItem.rightBarButtonItem = plusButton
        navigationItem.backBarButtonItem = backButton
        navigationController?.navigationBar.backIndicatorImage = UIImage()
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage()
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    private func makeImage(systemName: String) -> UIImage? {
        let font = UIFont.systemFont(ofSize: 15)
        let configuration = UIImage.SymbolConfiguration(font: font)
        return UIImage(systemName: systemName, withConfiguration: configuration)?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(.systemRed)
    }
    
    private func configureView() {
        let mainStackView = UIStackView()
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .vertical
        mainStackView.spacing = 16
        view.backgroundColor = .systemGray6
        view.addSubview(mainStackView)
        [wiseSayingView, calendarView, diaryView].forEach { mainStackView.addArrangedSubview($0) }
        calendarView.configureCalenderView(self)
        diaryView.configureTableView(self)
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

extension MainViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let date = dateComponents?.date else { return }
        selectedDate = date
        fetch()
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Diary", for: indexPath) as? DiaryTableViewCell else { return UITableViewCell() }
        cell.configureItems(models[indexPath.row].plan, grade: models[indexPath.row].grade)
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        present(makeUpdateViewController(with: models[indexPath.row]), animated: true)
    }
    
    private func makeUpdateViewController(with model: DiaryModel) -> UpdateViewController {
        let viewController = UpdateViewController()
        viewController.delegate = self
        viewController.configureItem(model)
        return viewController
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteSwipeAction = UIContextualAction(style: .destructive, title: "삭제", handler: { [weak self] _, _, completionHaldler in
            guard let date = self?.models[indexPath.row].date else { return }
            Task {
                await self?.manager.useCase.delete(date: date)
                self?.fetch()
            }
            completionHaldler(true)
        })
        return UISwipeActionsConfiguration(actions: [deleteSwipeAction])
    }
}

extension MainViewController: UpdateViewControllerDelegate {
    func updateViewController(_ updateModel: DiaryModel) {
        Task {
            await manager.useCase.update(updateModel)
            fetch()
        }
    }
}
