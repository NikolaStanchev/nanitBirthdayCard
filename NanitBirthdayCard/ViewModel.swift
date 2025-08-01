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
// my intent of is to keep the deployment target lower(iOS 16). so observation of the class will need to happen with the ObservableObject and @Published combination
final class ViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var birthdayDate: Date = .now
    @Published var selectedImage: UIImage?
    @Published var theme: Theme
    
    init() {
        let availableThemes = Theme.allCases
        theme = availableThemes[Int.random(in: 0..<availableThemes.count)]
        print("Chosen theme is: \(theme)")
    }
    
    /// Function for getting a UIImage from single PhotosPicker selection
    /// - Parameter imageSelection: The result from the user selecting a single photo in PhotosPicker
    func getPhoto(for imageSelection: PhotosPickerItem?) {
        
        guard let safeImage = imageSelection else {
            print("Selected image is nil!")
            return
        }

        Task {
            let data = try? await safeImage.loadTransferable(type: Data.self)
            if let safeData = data {
                if let image = UIImage(data: safeData) {
                    await setSelectedImage(to: image)
                } else {
                    print("ERROR: Image in nil!")
                }
            }
        }
    }
    
    /// Private function isolated on the MainActor for updating the selectedImage after a new one has been retreived from 'getPhoto()'
    /// - Parameter image: The resulting non-optional UIImage aquired in 'getPhoto()'
    @MainActor
    private func setSelectedImage(to image: UIImage) {
        withAnimation(.linear) {
            selectedImage = image
        }
    }
    
    // defining a deinit function for keeping an eye over memory management in future uses(if/when app gets more complex) where retention cycles may occur
    deinit {
        print("Deinitializing class ViewModel")
    }
}
