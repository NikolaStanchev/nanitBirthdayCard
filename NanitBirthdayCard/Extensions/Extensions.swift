//
//  Extensions.swift
//  NanitBirthdayCard
//
//  Created by Nikola Stanchev on 8/2/25.
//
import SwiftUI

// A extension for creating colors from HEX string, since because of a bug in the ImageRenderer using asset color they dont get displayed.
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")

        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0

        self.init(red: red, green: green, blue: blue)
    }
}
