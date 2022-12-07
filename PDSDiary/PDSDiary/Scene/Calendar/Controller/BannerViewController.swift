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
        let image = UIImage(systemName: "text.badge.plus", withConfiguration: configuration)?.withRenderingMode(.alwaysOriginal)
        
        let plusButton = UIBarButtonItem(title: nil, image: image, target: self, action: #selector(didTapPlusButton))
        plusButton.tintColor = .systemGreen
        navigationItem.title = "성공이의 하루"
        navigationItem.rightBarButtonItem = plusButton
    }
    
    @objc
    private func didTapPlusButton() {
        let viewController = PlanAddViewController()
        navigationController?.pushViewController(viewController, animated: true)
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
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
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
              let date = diaryDictionary[selectedDate]
                
        else { return UITableViewCell() }
        cell.configureItems(date[indexPath.row].plan, grade: date[indexPath.row].grade)
        
        return cell
    }
}

extension BannerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
