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
    
    let headerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "dream calendar"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let chevronButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)
        button.setImage(UIImage(systemName: "chevron.down", withConfiguration: config), for: .normal)
        button.tintColor = .secondaryLabel
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let calendar: UICalendarView = {
        let calendarV = UICalendarView()
        let gregorianCalendar = Calendar(identifier: .gregorian)
        calendarV.calendar = gregorianCalendar
        calendarV.tintColor = .systemPurple // Matches the moon icons in your screenshot
        calendarV.fontDesign = .rounded
        calendarV.backgroundColor = .clear // Remove background for cleaner look
        calendarV.availableDateRange = DateInterval(start: .distantPast, end: Date())
        calendarV.translatesAutoresizingMaskIntoConstraints = false
        calendarV.wantsDateDecorations = true
        return calendarV
    }()
    
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.showsHorizontalScrollIndicator = false
        sv.alwaysBounceHorizontal = true
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        
        // Add header stack
//        headerStack.addArrangedSubview(headerLabel)
//        headerStack.addArrangedSubview(chevronButton)
//        
//        addSubview(headerStack)
        addSubview(scrollView)
        scrollView.addSubview(calendar)
        //addSubview(calendar)
        
        NSLayoutConstraint.activate([
//            headerStack.topAnchor.constraint(equalTo: topAnchor),
//            headerStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
//            headerStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
            
            
            calendar.topAnchor.constraint(equalTo: scrollView.topAnchor),
            calendar.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor),
            calendar.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor),
            calendar.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
            
        ])
    }
    
    func setExpanded(_ expanded: Bool, animated: Bool = true) {
        let rotation: CGFloat = expanded ? 0 : -.pi
        
        if animated {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5) {
               // self.chevronButton.transform = CGAffineTransform(rotationAngle: rotation)
                self.calendar.isHidden = !expanded
                self.layoutIfNeeded()
            }
        } else {
           // chevronButton.transform = CGAffineTransform(rotationAngle: rotation)
            calendar.isHidden = !expanded
        }
    }
}

//class CalendarView: UIView {
//    
//    let calendar: UICalendarView = {
//        let calendarV = UICalendarView()
//        let gregorianCalendar = Calendar(identifier: .iso8601)
//        calendarV.calendar = gregorianCalendar
//        calendarV.tintColor = .systemBlue
//        calendarV.fontDesign = .rounded
//        calendarV.backgroundColor = .systemBackground
//        calendarV.layer.cornerRadius = 16
//        calendarV.layer.shadowColor = UIColor.black.cgColor
//        calendarV.layer.shadowOffset = CGSize(width: 0, height: 2)
//        calendarV.layer.shadowRadius = 8
//        calendarV.layer.shadowOpacity = 0.1
//        calendarV.availableDateRange = DateInterval(start: .distantPast, end: Date())
//        calendarV.translatesAutoresizingMaskIntoConstraints = false
//        //calendarV.calendar.
//      //  calendarV.
//        return calendarV
//    }()
//    let headerLabel: UIButton = {
//        let label = UIButton()
//        label.setTitle("dream calendar", for: .normal)
// 
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupUI()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func setupUI() {
//        backgroundColor = .clear
//        addSubview(calendar)
//        addSubview(headerLabel)
//
//        
//        NSLayoutConstraint.activate([
//            headerLabel.topAnchor.constraint(equalTo: topAnchor),
//            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
//            
//            calendar.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 8),
//            calendar.leadingAnchor.constraint(equalTo: leadingAnchor),
//            calendar.trailingAnchor.constraint(equalTo: trailingAnchor),
//            calendar.bottomAnchor.constraint(equalTo: bottomAnchor)
//        ])
//    }
//}
