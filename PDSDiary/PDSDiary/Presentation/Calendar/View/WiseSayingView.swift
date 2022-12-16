//
//  WiseSayingView.swift
//  PDSDiary
//
//  Created by Groot on 2022/12/06.
//

import UIKit

final class WiseSayingView: UIView {
    private let wiseSayingScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    private let wiseSayingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "그대의 하루 하루를 그대의 마지막 날이라고 생각하라 \n\n 호라티우스"
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .footnote)
        label.numberOfLines = 0
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureWiseSayingLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureWiseSayingLabel() {
        Task.init {
            let wiseSayingRequest = WiseSayingRequest()
            let data = await wiseSayingRequest.excute()
            switch data {
            case .success(let data):
                DispatchQueue.main.async { [weak self] in
                    guard let wiseSaying = data[1]["respond"] as? String else { return }
                    self?.wiseSayingLabel.text = wiseSaying
                        .replacingOccurrences(of: "-", with: "–")
                        .split(separator: "–")
                        .map { String($0) }
                        .joined(separator: "\n\n")
                }
            case .failure(_):
                break
            }
        }
    }
    
    private func configureView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .systemBackground
        self.layer.cornerCurve = .continuous
        self.layer.cornerRadius = 10.0
        self.layer.borderWidth = 1
        self.layer.borderColor = CGColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        self.addSubview(wiseSayingScrollView)
        wiseSayingScrollView.addSubview(wiseSayingLabel)
        
        NSLayoutConstraint.activate([
            wiseSayingScrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            wiseSayingScrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            wiseSayingScrollView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            wiseSayingScrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            wiseSayingLabel.topAnchor.constraint(equalTo: wiseSayingScrollView.contentLayoutGuide.topAnchor, constant: 16),
            wiseSayingLabel.leadingAnchor.constraint(equalTo: wiseSayingScrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            wiseSayingLabel.trailingAnchor.constraint(equalTo: wiseSayingScrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            wiseSayingLabel.bottomAnchor.constraint(equalTo: wiseSayingScrollView.contentLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
}
