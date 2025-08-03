//
//  Theme.swift
//  NanitBirthdayCard
//
//  Created by Nikola Stanchev on 8/1/25.
//
import SwiftUI

enum Theme: Identifiable, CaseIterable {
    var id: Self { self }
    
    case blue
    case yellow
    case green
    
    var color: Color {
        switch self {
        case .blue: .nanitBlue
        case .yellow: .nanitYellow
        case .green: .nanitGreen
        }
    }
    
    var colorHex: String {
        switch self {
        case .blue: "#8BD3E4"
        case .yellow: "#FEBE21"
        case .green: "#6FC5AF"
        }
    }
    
    var colorSecondary: Color {
        switch self {
        case .blue: .nanitBlueSecondary
        case .yellow: .nanitYellowSecondary
        case .green: .nanitGreenSecondary
        }
    }
    
    var colorSecondaryHex: String {
        switch self {
        case .blue: "#B9E5EF"
        case .yellow: "#FEE7B7"
        case .green: "#A9DCCF"
        }
    }
    
    var background: String {
        switch self {
        case .blue : "BG_Pelican"
        case .yellow : "BG_Elephant"
        case .green : "BG_Fox"
        }
    }
    
    var cameraIcon: String {
        switch self {
        case .blue: "Icons/Camera_icon_blue"
        case .yellow: "Icons/Camera_icon_yellow"
        case .green: "Icons/Camera_icon_green"
        }
    }
    
    var placeholderImage: String {
        switch self {
        case .blue: "Other/Default_place_holder_blue"
        case .yellow: "Other/Default_place_holder_yellow"
        case .green: "Other/Default_place_holder_green"
        }
    }
    
}
