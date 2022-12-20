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
    weak var delegate: UpdateViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardNotifications()
    }
    
    func configureItem(_ model: DiaryModel) {
        updateView.configureItems(model)
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
        view.backgroundColor = .systemGray6
        isModalInPresentation = true
        let mainStackView = UIStackView()
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .vertical
        mainStackView.spacing = 16
        view.addSubview(mainStackView)
        [customNavigation, updateView].forEach { mainStackView.addArrangedSubview($0) }
        customNavigation.delegate = self
        self.presentationController?.delegate = self
        updateView.configureTextViews(self)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            customNavigation.topAnchor.constraint(equalTo: mainStackView.topAnchor),
            customNavigation.heightAnchor.constraint(equalTo: mainStackView.heightAnchor, multiplier: 0.05),
            customNavigation.widthAnchor.constraint(equalTo: mainStackView.widthAnchor)
        ])
    }
}

extension UpdateViewController: CustomNavigationViewDelegate {
    func didTapCloseButton() {
        dismiss(animated: true)
    }
    
    func didTapSaveButton() {
        guard let model = updateView.makeModel() else { return }
        delegate?.updateViewController(model)
        dismiss(animated: true)
    }
}

extension UpdateViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "실행내용을 작성하세요." || textView.text == "평가를 작성하세요." {
            textView.text = nil
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textView.tag == 0 ? "실행내용을 작성하세요." : "평가를 작성하세요."
            textView.textColor = .placeholderText
        }
    }
}

extension UpdateViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        if updateView.hasChangesModel() {
            let alertController = UIAlertController(title: "", message: "변경 사항을 폐기할까요?", preferredStyle: .actionSheet)
            let disposeAction = UIAlertAction(title: "변경 사항 폐기", style: .default) { [weak self] _ in self?.dismiss(animated: true) }
            let cancelAction = UIAlertAction(title: "계속 편집하기",  style: .destructive) { _ in return }
            alertController.addAction(disposeAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true)
            
            return
        }
        
        dismiss(animated: true)
    }
}
