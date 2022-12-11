//
//  PlanUpdateView.swift
//  PDSDiary
//
//  Created by Groot on 2022/12/07.
//

import UIKit

final class PlanUpdateView: UIView {
    private var pdsModel: Model?
    
    private let mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        
        return stackView
    }()
    
    private let planTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerCurve = .continuous
        textField.layer.cornerRadius = 10.0
        textField.layer.borderWidth = 1
        textField.layer.borderColor = CGColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        textField.backgroundColor = .systemBackground
        textField.addLeftPadding()
        
        return textField
    }()
    
    private let doTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.cornerCurve = .continuous
        textView.layer.cornerRadius = 10.0
        textView.layer.borderWidth = 1
        textView.layer.borderColor = CGColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        
        return textView
    }()
    
    private let feedbackTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.cornerCurve = .continuous
        textView.layer.cornerRadius = 10.0
        textView.layer.borderWidth = 1
        textView.layer.borderColor = CGColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        
        return textView
    }()
    
    private let gradeSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["😄", "😗", "😔"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        return segmentedControl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureItem(_ model: Model?) {
        planTextField.text = model?.plan
        doTextView.text = model?.doing
        feedbackTextView.text = model?.feedback
        gradeSegmentedControl.selectedSegmentIndex = model?.grade.score ?? 0
        pdsModel = model
    }
    
    func item() -> Model? {
        switch gradeSegmentedControl.selectedSegmentIndex {
        case 0:
            pdsModel?.grade = .good
        case 1:
            pdsModel?.grade = .soso
        case 2:
            pdsModel?.grade = .bad
        default:
            pdsModel?.grade = .none
        }
        
        pdsModel?.plan = planTextField.text ?? ""
        pdsModel?.doing = doTextView.text
        pdsModel?.feedback = feedbackTextView.text
        
        return pdsModel
    }
    
    private func configureView() {
        self.addSubview(mainScrollView)
        
        NSLayoutConstraint.activate([
            mainScrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        mainScrollView.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: mainScrollView.frameLayoutGuide.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: mainScrollView.frameLayoutGuide.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.bottomAnchor)
        ])
        
        [planTextField, doTextView, feedbackTextView, gradeSegmentedControl].forEach { mainStackView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            planTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            gradeSegmentedControl.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            doTextView.heightAnchor.constraint(equalTo: mainScrollView.heightAnchor, multiplier: 0.4)
        ])

        NSLayoutConstraint.activate([
            feedbackTextView.heightAnchor.constraint(equalTo: mainScrollView.heightAnchor, multiplier: 0.4)
        ])
    }
}
