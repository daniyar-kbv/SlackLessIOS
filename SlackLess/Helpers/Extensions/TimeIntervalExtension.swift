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
                   allowedUnits: NSCalendar.Unit = [.hour, .minute]) -> String?
    {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = allowedUnits
        formatter.unitsStyle = style
        return formatter.string(from: self)
    }

    static func make(from string: String) -> Self {
        let components = string.components(separatedBy: ":")
        guard let hoursString = components.first,
              let minutesString = components.last
        else { return 0 }
        return ((Double(hoursString) ?? 0) * 3600) + ((Double(minutesString) ?? 0) * 60)
    }

    func toString() -> String {
        let hours = Int(self / 3600)
        let minutes = (Int(self) - (hours * 3600)) / 60
        return "\(hours):\(minutes > 9 ? String(minutes) : "0\(minutes)")"
    }
}

extension TimeInterval {
    enum Component {
        case years
        case months
        case days
        case hours
        case minutes
    }
    
    func get(component: Component) -> Int {
        switch component {
        case .hours:
            return Int(self / 3600)
        case .minutes:
            return (Int(self) - (get(component: .hours) * 3600)) / 60
        default: return 0
        }
    }
    
    func transform(to units: NSCalendar.Unit) -> [Int] {
        let timeString = self.formatted(with: .abbreviated, allowedUnits: units)
        return timeString?
            .split(separator: " ")
            .compactMap({
                Int($0.replacingOccurrences( of:"[^0-9]", with: "", options: .regularExpression))
            }) ?? []
    }
    
    func dateComponents() -> DateComponents {
        DateComponents(hour: get(component: .hours),
                       minute: get(component: .minutes))
    }

    static func makeFrom(_ dateComponents: DateComponents?) -> Self {
        var total: Double = 0
        if let hours = dateComponents?.hour {
            total += Double(hours) * 3600
        }
        if let minutes = dateComponents?.minute {
            total += Double(minutes) * 60
        }
        return total
    }
    
    func getMaxTimeUnit() -> String? {
        if (transform(to: .year).first ?? 0) > 0 {
            return formatted(with: .full, allowedUnits: .year)
        } else if (transform(to: .month).first ?? 0) > 0 {
            return formatted(with: .full, allowedUnits: .month)
        } else if (transform(to: .day).first ?? 0) > 0 {
            return formatted(with: .full, allowedUnits: .day)
        } else if (transform(to: .hour).first ?? 0) > 0 {
            return formatted(with: .full, allowedUnits: .hour)
        } else {
            return formatted(with: .full, allowedUnits: .minute)
        }
    }
}
