//
//  CalendarView.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 7/8/25.
//
import UIKit
import Foundation
import CalendarKit


class CalendarView: UIView {
    
    let calendar: UICalendarView = {
        let calendarV = UICalendarView()
        let gregorianCalendar = Calendar(identifier: .iso8601)
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
        //calendarV.calendar.
      //  calendarV.
        return calendarV
    }()
    let headerLabel: UIButton = {
        let label = UIButton()
        label.setTitle("dream calendar", for: .normal)
 
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        addSubview(headerLabel)

        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: topAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            
            calendar.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 8),
            calendar.leadingAnchor.constraint(equalTo: leadingAnchor),
            calendar.trailingAnchor.constraint(equalTo: trailingAnchor),
            calendar.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
