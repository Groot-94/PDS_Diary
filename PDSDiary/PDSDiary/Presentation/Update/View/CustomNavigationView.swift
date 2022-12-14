//
//  CustomNavigationView.swift
//  PDSDiary
//
//  Created by Groot on 2022/12/07.
//

import UIKit

final class CustomNavigationView: UIView {
    weak var delegate: CustomNavigationViewDelegate?
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrow.uturn.backward.circle"), for: .normal)
        button.tintColor = .systemRed
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ęłí ěě "
        return label
    }()
    
    private let updateButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "rectangle.and.pencil.and.ellipsis"), for: .normal)
        button.tintColor = .systemRed
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func didTapCloseButton() {
        delegate?.didTapCloseButton()
    }
    
    @objc
    private func didTapSaveButton() {
        delegate?.didTapSaveButton()
    }
    
    private func configureView() {
        self.addSubview(mainStackView)
        [closeButton, titleLabel, updateButton].forEach { mainStackView.addArrangedSubview($0) }
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchDown)
        updateButton.addTarget(self, action: #selector(didTapSaveButton), for: .touchDown)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
