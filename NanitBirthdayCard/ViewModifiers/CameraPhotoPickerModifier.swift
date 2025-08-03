//
//  CameraPhotoPickerModifier.swift
//  NanitBirthdayCard
//
//  Created by Nikola Stanchev on 8/2/25.
//

import SwiftUI
import PhotosUI

//Detatching the logic for photo selection from the photos app and the camera in it's own view modifier to keep it reusable

/// a view modifier used for presenting the dialog to choose a photo from 'Photos' or to take a photo, also used for showing the appropriate camera and photosPicker views
struct CameraPhotoPickerModifier: ViewModifier {
    @Binding var showPhotosPicker: Bool
    @Binding var showCameraView: Bool
    @Binding var selectedItem: PhotosPickerItem?
    @Binding var selectedImage: Image?
    @Binding var showChooseDialog: Bool
    
    func body(content: Content) -> some View {
        content
            .photosPicker(isPresented: $showPhotosPicker, selection: $selectedItem, matching: .images)
            .fullScreenCover(isPresented: $showCameraView, content: {
                VStack {
                    CameraView(image: $selectedImage)
                }
                .background(.black)
            })
            .confirmationDialog("Choose Image Source", isPresented: $showChooseDialog) {
                Button("Choose Photo") {
                    showPhotosPicker = true
                }
                Button("Take a Picture") {
                    print("Take a Picture action selected")
                    showCameraView = true
                }
                if (selectedImage != nil) {
                    Button("Remove Selection", role: .destructive) {
                        print("Remove Selection action selected")
                        selectedImage = nil
                        selectedItem = nil
                    }
                }
            }
    }
}

extension View {
    func photoCameraSelectionPresenter(
        showPhotosPicker: Binding<Bool>,
        showCameraView: Binding<Bool>,
        selectedItem: Binding<PhotosPickerItem?>,
        selectedImage: Binding<Image?>,
        showChooseDialog: Binding<Bool>
    ) -> some View {
        modifier(CameraPhotoPickerModifier(showPhotosPicker: showPhotosPicker, showCameraView: showCameraView, selectedItem: selectedItem, selectedImage: selectedImage, showChooseDialog: showChooseDialog))
    }
}
