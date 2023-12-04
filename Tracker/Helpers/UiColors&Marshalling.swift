//
//  UiColors.swift
//  Tracker
//
//  Created by Dolnik Nikolay on 03.10.2023.
//

import UIKit

final class UIColorMarshalling {
    func hexString(from color: UIColor) -> String {
        let components = color.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0
        return String.init(
            format: "%02lX%02lX%02lX",
            lroundf(Float(r * 255)),
            lroundf(Float(g * 255)),
            lroundf(Float(b * 255))
        )
    }

    func color(from hex: String) -> UIColor {
        var rgbValue:UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension UIColor {
    static var blueTracker: UIColor { UIColor(named: "Blue") ?? .green }
    static var redTracker: UIColor { UIColor(named: "Red") ?? .red }
    static var backgroundDayTracker: UIColor { UIColor(named: "Background[day]") ?? .white }
    static var backgroundNightTracker: UIColor { UIColor(named: "Background[night]") ?? .gray }
    static var blackDayTracker: UIColor { UIColor(named: "Black[day]") ?? .black }
    static var blackNightTracker: UIColor { UIColor(named: "Black[night]") ?? .white }
    static var grayTracker: UIColor { UIColor(named: "Gray") ?? .gray }
    static var lightGrayTracker: UIColor { UIColor(named: "LightGray") ?? .gray }
    static var whiteDayTracker: UIColor { UIColor(named: "White[day]") ?? .white }
    static var whiteNightTracker: UIColor { UIColor(named: "Whte[night]") ?? .black }
    
    static var selection1: UIColor { UIColor(named: "selection1") ?? .green }
    static var selection2: UIColor { UIColor(named: "selection2") ?? .green }
    static var selection3: UIColor { UIColor(named: "selection3") ?? .green }
    static var selection4: UIColor { UIColor(named: "selection4") ?? .green }
    static var selection5: UIColor { UIColor(named: "selection5") ?? .green }
    static var selection6: UIColor { UIColor(named: "selection6") ?? .green }
    static var selection7: UIColor { UIColor(named: "selection7") ?? .green }
    static var selection8: UIColor { UIColor(named: "selection8") ?? .green }
    static var selection9: UIColor { UIColor(named: "selection9") ?? .green }
    static var selection10: UIColor { UIColor(named: "selection10") ?? .green }
    static var selection11: UIColor { UIColor(named: "selection11") ?? .green }
    static var selection12: UIColor { UIColor(named: "selection12") ?? .green }
    static var selection13: UIColor { UIColor(named: "selection13") ?? .green }
    static var selection14: UIColor { UIColor(named: "selection14") ?? .green }
    static var selection15: UIColor { UIColor(named: "selection15") ?? .green }
    static var selection16: UIColor { UIColor(named: "selection16") ?? .green }
    static var selection17: UIColor { UIColor(named: "selection17") ?? .green }
    static var selection18: UIColor { UIColor(named: "selection18") ?? .green }
    
}
