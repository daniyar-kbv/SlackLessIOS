//
//  TimeInterval.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-13.
//

import Foundation

extension TimeInterval {
//    positional
//    X:XX
//    abbreviated
//    Xh Xm
//    short
//    X hr, X min
//    full
//    X hours, X minutes
//    spellOut
//    xxx hours, xxx minutes
//    brief
//    Xhr Xmin
    func formatted(with style: DateComponentsFormatter.UnitsStyle,
                   allowedUnits: NSCalendar.Unit = [.hour, .minute]) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = allowedUnits
        formatter.unitsStyle = style
        return formatter.string(from: self)
    }
}
