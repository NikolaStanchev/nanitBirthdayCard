//
//  ViewModel.swift
//  NanitBirthdayCard
//
//  Created by Nikola Stanchev on 7/31/25.
//

import Foundation
import UIKit
import SwiftUI
import PhotosUI

// The @Observable macro would be a better choice here, but it's available for iOS 17 and up,
// my intent of is to keep the deployment target lower(iOS 16). so observation of the class will need to happen with the ObservableObject protocol and @Published combination
final class ViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var birthdayDate: Date = .now
    @Published var theme: Theme
    @Published var image: Image? 

    @Published var imageSelection: PhotosPickerItem? {
        didSet {
            if let imageSelection {
                Task {
                    try await loadTransferable(from: imageSelection)
                }
            }
        }
    }
    
    init() {
        let availableThemes = Theme.allCases
        theme = availableThemes[Int.random(in: 0..<availableThemes.count)]
        name = UserDefaults.standard.string(forKey: "savedName") ?? ""
        birthdayDate = UserDefaults.standard.value(forKey: "savedDate") as? Date ?? .now
        print("Chosen theme is: \(theme)")
    }
    
    func loadTransferable(from imageSelection: PhotosPickerItem) async throws {
        do {
            if let image = try await imageSelection.loadTransferable(type: Image.self) {
                await setImage(to: image)
            }
        } catch {
            print("loadTransferable: Error \(error.localizedDescription)")
            image = nil
        }
    }
    
    @MainActor
    private func setImage(to image: Image) {
        withAnimation(.linear) {
            self.image = image
        }
    }
    
    // this function can be used in case it is manditory to get a random theme on the appear callback of birthday card, I currently get in on init of this class, to create a more consistend theming across the app
    // and to apply color to the input form view as well
    func loadTheme() {
        let availableThemes = Theme.allCases
        theme = availableThemes[Int.random(in: 0..<availableThemes.count)]
    }
    
    // defining a deinit function for keeping an eye over memory management in future uses(if/when app gets more complex) where retention cycles may occur
    deinit {
        print("Deinitializing class ViewModel")
    }
}
