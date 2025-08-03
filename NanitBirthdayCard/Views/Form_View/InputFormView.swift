//
//  InputFormView.swift
//  NanitBirthdayCard
//
//  Created by Nikola Stanchev on 7/31/25.
//

import SwiftUI
import PhotosUI

struct InputFormView: View {
    
    /// The views viewModel object
    @ObservedObject var viewModel: ViewModel = ViewModel()
    
    // View properties associated with it's state
    @State var showChooseDialog: Bool = false
    @State var showPhotosPicker: Bool = false
    @State var showCameraView: Bool = false
    @State var selectedItem: PhotosPickerItem?
    @State var showClearSearchFieldButton: Bool = false
    

    var body: some View {
        VStack(alignment: .leading) {
            //------ Header
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
            //------
            Spacer()
            //------ Input Fields
            Text("Name")
            HStack {
                TextField("e.g. Christiano Ronaldo", text: $viewModel.name)
                    .tint(viewModel.theme.color)
                    .onChange(of: viewModel.name) { text in
                        shouldShowClearTextButton(for: text)
                    }
                    .onSubmit {
                        UserDefaults.standard.set(viewModel.name, forKey: "savedName")
                    }
                //------ Clear Text Button
                if (showClearSearchFieldButton) {
                    Image(systemName:"xmark.circle.fill")
                        .transition(.scale)
                        .onTapGesture {
                            viewModel.name = ""
                            
                        }
                }
            }
            .padding(.bottom, 5)
            DatePicker("Birthday", selection: $viewModel.birthdayDate, in: ...Date.now, displayedComponents: .date)
                .tint(viewModel.theme.color)
            Spacer()
            //------
            //------ Selected photo view
            HStack {
                CircularPhotoView(imageTest: $viewModel.image, theme: $viewModel.theme, hideCameraIcon: .constant(false), isForCapture: false)
                    .onTapGesture {
                        showChooseDialog = true
                    }
            }
            Spacer()
            //------
            //------ Navigation Button
        
            NavigationLink(destination: BirthdayCardView().environmentObject(viewModel)) {
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
                .disabled(viewModel.name != "")
                .padding(.bottom, 53)
            }
            
            
            
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .padding(.horizontal, 20)
        .photoCameraSelectionPresenter(showPhotosPicker: $showPhotosPicker, showCameraView: $showCameraView, selectedItem: $viewModel.imageSelection, selectedImage: $viewModel.image, showChooseDialog: $showChooseDialog)
        .onChange(of: viewModel.birthdayDate) { newValue in
            UserDefaults.standard.set(newValue, forKey: "savedDate")
        }
    }
    
    //------ Function for deciding wether the 'Clear text' button should be visible
    func shouldShowClearTextButton(for text: String) {
        if (text == "") {
            withAnimation {
                showClearSearchFieldButton = false
            }
        } else {
            withAnimation {
                showClearSearchFieldButton = true
            }
        }
    }
    
}

#Preview {
    InputFormView()
}
