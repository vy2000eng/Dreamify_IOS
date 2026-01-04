//
//  Cal.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 9/15/25.
//


import UIKit
import Foundation
extension CalendarViewController:UICalendarViewDelegate,UICalendarSelectionSingleDateDelegate {

    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
         guard let date = Calendar.current.date(from: dateComponents) else { return nil }
    
        if dreamRecordingViewModel.hasDreamsForDate(date: date) {
             return UICalendarView.Decoration.image(
                 UIImage(systemName: "moon.stars.fill"),
                 color: .systemPurple,
                 size: .large
             )
         }
         
         return nil
     }
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let dateComponents = dateComponents,
                  let selectedDate = Calendar.current.date(from: dateComponents) else {
                return
            }
        
        self.current_date = selectedDate
        filterDreamsForDate(selectedDate)
    }
    
}
