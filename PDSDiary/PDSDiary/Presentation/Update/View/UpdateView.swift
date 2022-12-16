//
//  UpdateView.swift
//  PDSDiary
//
//  Created by Groot on 2022/12/07.
//

import UIKit

final class UpdateView: UIView {
    private var model: DiaryModel?
    
    private let mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.keyboardDismissMode = .interactive
        
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
        textField.font = .preferredFont(forTextStyle: .body, compatibleWith: .none)
        textField.placeholder = "계획을 작성하세요"
        textField.addLeftPadding()
        
        return textField
    }()
    
    private let doingTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.cornerCurve = .continuous
        textView.layer.cornerRadius = 10.0
        textView.layer.borderWidth = 1
        textView.font = .preferredFont(forTextStyle: .body, compatibleWith: .none)
        textView.layer.borderColor = CGColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        textView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        textView.tag = 0
        textView.showsVerticalScrollIndicator = false
        
        return textView
    }()
    
    private let feedbackTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.cornerCurve = .continuous
        textView.layer.cornerRadius = 10.0
        textView.layer.borderWidth = 1
        textView.font = .preferredFont(forTextStyle: .body, compatibleWith: .none)
        textView.layer.borderColor = CGColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        textView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        textView.tag = 1
        textView.showsVerticalScrollIndicator = false
        
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
    
    func configureItem(_ model: DiaryModel?) {
        planTextField.text = model?.plan
        configureTextViewsText(model)
        gradeSegmentedControl.selectedSegmentIndex = model?.grade.score ?? 0
        self.model = model
    }
    
    private func configureTextViewsText(_ model: DiaryModel?) {
        doingTextView.text = model?.doing
        feedbackTextView.text = model?.feedback
        
        if model?.doing == "실행내용을 작성하세요." {
            doingTextView.textColor = .lightGray
        }
        
        if model?.feedback == "평가를 작성하세요." {
            feedbackTextView.textColor = .lightGray
        }
    }
    
    func makeModel() -> DiaryModel? {
        switch gradeSegmentedControl.selectedSegmentIndex {
        case 0:
            model?.grade = .good
        case 1:
            model?.grade = .soso
        case 2:
            model?.grade = .bad
        default:
            model?.grade = .none
        }
    
        model?.plan = planTextField.text ?? ""
        model?.doing = doingTextView.text
        model?.feedback = feedbackTextView.text
        
        return model
    }
    
    func configureTextViews(_ viewController: UIViewController) {
        doingTextView.delegate = viewController as? UITextViewDelegate
        feedbackTextView.delegate = viewController as? UITextViewDelegate
    }
    
    func setScrollIndicatorInsets(_ height: CGFloat) {
        let firstResponder = UIResponder.currentResponder
        guard let textView = firstResponder as? UITextView,
              textView == feedbackTextView else { return }
        mainScrollView.setContentOffset(CGPointMake(0, height), animated: true)
    }
    
    private func configureView() {
        self.addSubview(mainScrollView)
        mainScrollView.addSubview(mainStackView)
        [planTextField, doingTextView, feedbackTextView, gradeSegmentedControl].forEach { mainStackView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            mainScrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: mainScrollView.frameLayoutGuide.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: mainScrollView.frameLayoutGuide.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            planTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            gradeSegmentedControl.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            doingTextView.heightAnchor.constraint(equalTo: mainScrollView.heightAnchor, multiplier: 0.4)
        ])
        
        NSLayoutConstraint.activate([
            feedbackTextView.heightAnchor.constraint(equalTo: mainScrollView.heightAnchor, multiplier: 0.4)
        ])
    }
}
