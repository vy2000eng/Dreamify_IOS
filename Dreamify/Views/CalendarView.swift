//
//  CalendarView.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 7/8/25.
//
import UIKit
import Foundation

class CalendarView: UIView {
    
    let calendar: UICalendarView = {
        let calendarV = UICalendarView()
        let gregorianCalendar = Calendar(identifier: .gregorian)
        calendarV.calendar = gregorianCalendar
        calendarV.tintColor = .systemBlue
        calendarV.fontDesign = .rounded
        calendarV.backgroundColor = .systemBackground
        calendarV.layer.cornerRadius = 16
        calendarV.layer.shadowColor = UIColor.black.cgColor
        calendarV.layer.shadowOffset = CGSize(width: 0, height: 2)
        calendarV.layer.shadowRadius = 8
        calendarV.layer.shadowOpacity = 0.1
        calendarV.availableDateRange = DateInterval(start: .distantPast, end: Date())
        calendarV.translatesAutoresizingMaskIntoConstraints = false
        return calendarV
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        addSubview(calendar)
        
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            calendar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            calendar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            calendar.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
}
