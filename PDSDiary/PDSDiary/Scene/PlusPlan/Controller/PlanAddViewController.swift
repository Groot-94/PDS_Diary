//
//  PlanAddViewController.swift
//  PDSDiary
//
//  Created by Groot on 2022/12/07.
//

import UIKit

final class PlanAddViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigation()
        configureView()
    }
    
    private func configureNavigation() {
        let font = UIFont.systemFont(ofSize: 15)
        let configuration = UIImage.SymbolConfiguration(font: font)
        let leftImage = UIImage(systemName: "arrow.uturn.backward.circle.fill", withConfiguration: configuration)?.withRenderingMode(.alwaysOriginal)
        
        let leftButton = UIBarButtonItem(title: nil, image: leftImage, target: self, action: #selector(didTapLeftButton))
        leftButton.tintColor = .systemGreen
        navigationItem.title = "새로운 계획을 추가해보세요"
        navigationItem.leftBarButtonItem = leftButton
    }
    
    @objc
    private func didTapLeftButton() {
        navigationController?.popViewController(animated: true)
    }
    
    private func configureView() {
        let mainStackView = UIStackView()
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .vertical
        mainStackView.spacing = 16
        
        view.backgroundColor = .systemGray6
        view.addSubview(mainStackView)
        [].forEach { mainStackView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
}
