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
        button.tintColor = .black
        
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "계획 수정"
        
        return label
    }()
    
    private let updateButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "rectangle.and.pencil.and.ellipsis"), for: .normal)
        button.tintColor = .black
        
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
    private func didTapAddButton() {
        delegate?.didTapAddButton()
    }
    
    private func configureView() {
        self.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        [closeButton, titleLabel, updateButton].forEach { mainStackView.addArrangedSubview($0) }
        
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchDown)
        updateButton.addTarget(self, action: #selector(didTapAddButton), for: .touchDown)
    }
}
