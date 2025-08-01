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
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Birthday Card")
                    .font(.title)
                    .fontWeight(.bold)
                HStack {
                    Text("by")
                        .fontWeight(.ultraLight)
                    Image("Nanit_logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 15)
                }
            }
            Spacer()
            CircularPhotoView(image: $viewModel.selectedImage, theme: $viewModel.theme)
                .onTapGesture {
                    showChooseDialog = true
                }
            Spacer()
            Text("Name")
            TextField("e.g. Christiano Ronaldo", text: $viewModel.name)
                .tint(viewModel.theme.color)
                .textFieldStyle(.roundedBorder)
            DatePicker("Birthday", selection: $viewModel.birthdayDate, displayedComponents: .date)
                .tint(viewModel.theme.color)
            Spacer()
            Button {
                print("Navigate to card view here")
            } label: {
                Text("Show birthday screen")
                    .foregroundStyle(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
            }
            .background(viewModel.name == "" ? .gray : viewModel.theme.color)
            .clipShape(Capsule())
            .disabled(viewModel.name == "")
            .padding(.bottom, 53)
            
            
        }
        .padding(.horizontal, 20)
        .onChange(of: selectedItem) { imageSelection in
            viewModel.getPhoto(for: imageSelection)
        }
        .photosPicker(isPresented: $showPhotosPicker, selection: $selectedItem, matching: .images)
        .fullScreenCover(isPresented: $showCameraView, content: {
            VStack {
                CameraView(image: $viewModel.selectedImage)
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
            if (viewModel.selectedImage != nil) {
                Button("Remove Selection", role: .destructive) {
                    print("Remove Selection action selected")
                    viewModel.selectedImage = nil
                }
            }
        }
        
        
    }
}

#Preview {
    InputFormView()
}
