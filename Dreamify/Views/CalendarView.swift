//
//  CalendarView.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 7/8/25.
//
import UIKit
import Foundation

class CalendarView:UIView{
    
    let calendar:UICalendarView={
        let calendarV                = UICalendarView()
        let gregorianCalendar        = Calendar(identifier: .gregorian)
        calendarV.calendar           = gregorianCalendar
        calendarV.tintColor          = .systemMint
        calendarV.availableDateRange = DateInterval(start: .now, end: .distantFuture)
        calendarV.translatesAutoresizingMaskIntoConstraints = false;
        return calendarV;
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
}
