//
//  UpdateViewController.swift
//  PDSDiary
//
//  Created by Groot on 2022/12/07.
//

import UIKit

final class UpdateViewController: UIViewController {
    private let customNavigation = CustomNavigationView()
    private let updateView = UpdateView()
    weak var delegate: PlanUpdateViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardNotifications()
    }
    
    func configureItem(_ model: DiaryModel) {
        updateView.configureItem(model)
    }
    
    private func addKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    private func keyboardWillShow(_ notification: NSNotification){
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        updateView.setScrollIndicatorInsets(keyboardFrame.size.height)
    }
    
    @objc
    private func keyboardWillHide(_ notification: NSNotification){
        updateView.setScrollIndicatorInsets(.zero)
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
        
        [customNavigation, updateView].forEach { mainStackView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            customNavigation.topAnchor.constraint(equalTo: mainStackView.topAnchor),
            customNavigation.heightAnchor.constraint(equalTo: mainStackView.heightAnchor, multiplier: 0.05),
            customNavigation.widthAnchor.constraint(equalTo: mainStackView.widthAnchor)
        ])
        
        customNavigation.delegate = self
        updateView.configureTextViews(self)
    }
}

extension UpdateViewController: CustomNavigationViewDelegate {
    func didTapCloseButton() {
        dismiss(animated: true)
    }
    
    func didTapAddButton() {
        guard let model = updateView.makeModel() else { return }
        
        delegate?.planUpdateViewController(model)
        dismiss(animated: true)
    }
}

extension UpdateViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "실행내용을 작성하세요." || textView.text == "평가를 작성하세요." {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textView.tag == 0 ? "실행내용을 작성하세요." : "평가를 작성하세요."
            textView.textColor = .lightGray
        }
    }
}
