//
//  InputFormView.swift
//  NanitBirthdayCard
//
//  Created by Nikola Stanchev on 7/31/25.
//

import SwiftUI
import PhotosUI

struct InputFormView: View {    
    @State var showChooseDialog: Bool = false
    @State var showPhotosPicker: Bool = false
    @State var showCameraView: Bool = false
    @State var selectedItem: PhotosPickerItem?
    
    @ObservedObject var viewModel: ViewModel = ViewModel()
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                CircularPhotoView(image: $viewModel.selectedImage)
                .onTapGesture {
                    showChooseDialog = true
                }
                Text("Name")
                TextField("Name", text: $viewModel.name)
                DatePicker("Birthday", selection: $viewModel.birthdayDate, displayedComponents: .date)
                Button {
                    print("Navigate to card view here")
                } label: {
                    Text("Show birthday screen")
                        .foregroundStyle(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                }
                .background(viewModel.name == "" ? .gray : .pink)
                .clipShape(Capsule())
                .disabled(viewModel.name == "")
                .padding(.bottom, 53)
                
                    
            }
            .padding(.horizontal, 20)
        }
        .navigationTitle("Nanit")
        .photosPicker(isPresented: $showPhotosPicker, selection: $selectedItem, matching: .images)
        .sheet(isPresented: $showCameraView, content: {
            CameraView(image: $viewModel.selectedImage)
        })
        .confirmationDialog("Choose Image Source", isPresented: $showChooseDialog) {
            Button("Choose Photo") {
                showPhotosPicker = true
            }
            Button("Take a Picture") {
                print("Take a Picture action selected")
                showCameraView = true
            }
            if (viewModel.selectedImage != nil) {
                Button("Remove Selection", role: .destructive) {
                    print("Remove Selection action selected")
                    viewModel.selectedImage = nil
                }
            }
        }
        .onChange(of: selectedItem) { imageSelection in
            viewModel.getPhoto(for: imageSelection)
        }
    }
}

#Preview {
    InputFormView()
}
