//
//  Date+Ext.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 12/26/24.
//

import UIKit

extension Date {
        
    var timeAgoToDisplay: String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        let year = 12 * month
        
        let quotient: Int
        let unit: String
        
        if secondsAgo < minute {
            quotient = secondsAgo
            unit = "초"
        } else if secondsAgo < hour {
            quotient = secondsAgo / minute
            unit = "분"
        } else if secondsAgo < day {
            quotient = secondsAgo / hour
            unit = "시간"
        } else if secondsAgo < week {
            quotient = secondsAgo / day
            unit = "일"
        } else if secondsAgo < month {
            quotient = secondsAgo / week
            unit = "주일"
        } else if secondsAgo < year {
            quotient = secondsAgo / month
            unit = "달"
        } else {
            quotient = secondsAgo / year
            unit = "년"
        }
        
        return "\(quotient) \(unit) 전"
    }
}
