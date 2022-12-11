//
//  BannerViewController.swift
//  PDSDiary
//
//  Created by Groot on 2022/12/05.
//

import UIKit

final class BannerViewController: UIViewController {
    private var diaryDictionary = DiaryDummy.dictionary
    private var selectedDate = Date().convert()
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
        
        let plusButton = UIBarButtonItem(title: nil, image: image, target: self, action: #selector(didTapPlusButton))
        plusButton.tintColor = .black
        navigationItem.title = "성공이의 하루"
        navigationItem.rightBarButtonItem = plusButton
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    @objc
    private func didTapPlusButton() {
       
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
        guard let date = dateComponents?.date?.convert() else { return }
        
        selectedDate = date
        diaryView.reloadData()
    }
}

extension BannerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let date = diaryDictionary[selectedDate] else  { return 0 }
        
        return date.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Diary", for: indexPath) as? DiaryTableViewCell,
              let diary = diaryDictionary[selectedDate] else { return UITableViewCell() }
        
        cell.configureItems(diary[indexPath.row].plan, grade: diary[indexPath.row].grade)
        
        return cell
    }
}

extension BannerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let diary = diaryDictionary[selectedDate] else { return }
        
        let viewController = PlanUpdateViewController()
        present(viewController, animated: true)
        
        viewController.delegate = self
        viewController.configureItem(diary[indexPath.row])
    }
}

extension BannerViewController: PlanUpdateViewControllerDelegate {
    func planUpdateViewController(_ updateModel: PDSModel) {
        guard let diary = diaryDictionary[selectedDate] else { return }
        
        diaryDictionary[selectedDate] = diary.filter { $0.date != updateModel.date }
        diaryDictionary[selectedDate]?.append(updateModel)
        diaryView.reloadData()
    }
}
