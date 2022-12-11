//
//  PlanUpdateViewController.swift
//  PDSDiary
//
//  Created by Groot on 2022/12/07.
//

import UIKit

final class PlanUpdateViewController: UIViewController {
    private let customNavigation = CustomNavigationView()
    private let planUpdateView = PlanUpdateView()
    var delegate: PlanUpdateViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    func configureItem(_ model: PDSModel) {
        planUpdateView.configureItem(model)
    }
    
    private func configureView() {
        let mainStackView = UIStackView()
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .vertical
        mainStackView.spacing = 16
        
        view.backgroundColor = .systemGray6
        view.addSubview(mainStackView)

        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        [customNavigation, planUpdateView].forEach { mainStackView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            customNavigation.topAnchor.constraint(equalTo: mainStackView.topAnchor),
            customNavigation.heightAnchor.constraint(equalTo: mainStackView.heightAnchor, multiplier: 0.05),
            customNavigation.widthAnchor.constraint(equalTo: mainStackView.widthAnchor)
        ])
        
        customNavigation.delegate = self
    }
}

extension PlanUpdateViewController: CustomNavigationViewDelegate {
    func didTapCloseButton() {
        dismiss(animated: true)
    }
    
    func didTapAddButton() {
        guard let model = planUpdateView.item() else { return }
        
        delegate?.planUpdateViewController(model)
        dismiss(animated: true)
    }
}
