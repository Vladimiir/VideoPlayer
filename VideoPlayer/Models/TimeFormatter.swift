//
//  TimeFormatter.swift
//  VideoPlayer
//
//  Created by Стасенко Владимир on 06.03.2022.
//

import Foundation

struct TimeFormatter {
    
    static func formateSecondsToMS(_ seconds: Float) -> String {
        let interval = TimeInterval(seconds)
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "m:ss"
        
        return formatter.string(from: Date(timeIntervalSinceReferenceDate: interval))
    }
}
