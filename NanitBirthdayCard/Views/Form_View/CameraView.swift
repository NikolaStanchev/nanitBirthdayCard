//
//  CameraView.swift
//  NanitBirthdayCard
//
//  Created by Nikola Stanchev on 8/1/25.
//

import Foundation
import SwiftUI
import UIKit

/// Camera view struct for implementing UIKit's UIImagePicker with our SwiftUI views
struct CameraView: UIViewControllerRepresentable {
    
    /// Binding to the ViewModel's image property
//    @Binding var image: UIImage?
    @Binding var image: Image?
    /// Boolean value used for dismissal of the sheet the view will be presented in
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraView
        
        init(parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            if let image = info[.originalImage] as? UIImage {
//                parent.image = image
//            }
            if let image = info[.originalImage] as? UIImage {
                parent.image = Image(uiImage: image)
            } else {
                print("Error")
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
}
