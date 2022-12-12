//
//  CalendarView.swift
//  PDSDiary
//
//  Created by Groot on 2022/12/06.
//

import UIKit

final class CalendarView: UIView {
    private let calendarView: UICalendarView = {
        let gregorianCalendar = Calendar(identifier: .gregorian)
        let calendarView = UICalendarView()
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.backgroundColor = .systemBackground
        calendarView.tintColor = .systemRed
        calendarView.layer.cornerCurve = .continuous
        calendarView.layer.cornerRadius = 10.0
        calendarView.layer.borderWidth = 1
        calendarView.layer.borderColor = CGColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        calendarView.calendar = gregorianCalendar
        calendarView.locale = Locale(identifier: "ko-KR")
        calendarView.fontDesign = .monospaced
        
        return calendarView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        self.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            calendarView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            calendarView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func configureCalenderView(_ controller: UICalendarSelectionSingleDateDelegate?) {
        let dateSelection = UICalendarSelectionSingleDate(delegate: controller)
        calendarView.selectionBehavior = dateSelection
    }
}
