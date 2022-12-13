//
//  DiaryView.swift
//  PDSDiary
//
//  Created by Groot on 2022/12/06.
//

import UIKit

final class DiaryView: UIView {
    private let diaryTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 10
        tableView.showsVerticalScrollIndicator = false
        tableView.register(DiaryTableViewCell.self, forCellReuseIdentifier: "Diary")
        
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureTableView(_ controller: UIViewController) {
        diaryTableView.dataSource = controller as? UITableViewDataSource
        diaryTableView.delegate = controller as? UITableViewDelegate
    }
    
    func reloadData() {
        diaryTableView.reloadData()
    }
    
    private func configureView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        layer.cornerCurve = .continuous
        layer.cornerRadius = 10.0
        layer.borderWidth = 1
        layer.borderColor = CGColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        
        addSubview(diaryTableView)
        
        NSLayoutConstraint.activate([
            diaryTableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 16),
            diaryTableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            diaryTableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            diaryTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
}
