//
//  InputFormView.swift
//  NanitBirthdayCard
//
//  Created by Nikola Stanchev on 7/31/25.
//

import SwiftUI
import PhotosUI

struct InputFormView: View {
    @State var nameText: String = ""
    @State var birthdayDate: Date = .now
    @State var selectedImage: UIImage?
    @State var showChooseDialog: Bool = false
    @State var showPhotosPicker: Bool = false
    @State var selectedItem: PhotosPickerItem?
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                ZStack {
                    HStack {
                        Spacer()
                        Circle()
                            .stroke(.gray, lineWidth: 5)
                            .frame(width:305, height: 305)
                            .background(.clear)
                        Spacer()
                    }
                    if let safeSelectedImage = selectedImage {
                        Image(uiImage: safeSelectedImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(.circle)
                            .frame(width:300, height: 300)
                            
                    } else {
//                        if #available(iOS 17.0, *) {
//                            ContentUnavailableView("No photo chosen", systemImage: "photo.on.rectangle.angled", description: Text("Tap here to choose a photo"))
//                        } else {
//                            // Fallback on earlier versions
//                            VStack {
//                                Image(systemName: "photo.on.rectangle.angled")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                                    .frame(width: 50, height: 50)
//                                    .foregroundStyle(.gray)
//                                Text("No photo chosen")
//                                    .font(.title3)
//                                    .fontWeight(.bold)
//                                Text("Tap here to choose a photo")
//                                    .foregroundStyle(.gray)
//                            }
//                        
//                        }
                        
                    }
                }
                .onTapGesture {
                    showChooseDialog = true
                }

                Spacer()
                
                Text("Name")
                
                TextField("Name", text: $nameText)
                
                DatePicker("Birthday", selection: $birthdayDate, displayedComponents: .date)
                
                Button {
                    print("Navigate to card view here")
                } label: {
                    Text("Show birthday screen")
                        .foregroundStyle(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                }
                .background(nameText == "" ? .gray : .pink)
                .clipShape(Capsule())
                .disabled(nameText == "")
                
                    
            }
            .padding(.horizontal, 20)
        }
        .navigationTitle("Nanit")
        .photosPicker(isPresented: $showPhotosPicker, selection: $selectedItem, matching: .images)
        .confirmationDialog("Choose Image Source", isPresented: $showChooseDialog) {
            Button("Choose Photo") {
                showPhotosPicker = true
            }
            Button("Take a Picture") {
                print("Take a Picture action selected")
            }
        }
        .onChange(of: selectedItem) { imageSelection in
            guard let safeImage = imageSelection else {
                print("Selected image is nil!")
                return
            }
            
            Task {
                let data = try? await safeImage.loadTransferable(type: Data.self)
                if let safeData = data {
                    if let image = UIImage(data: safeData) {
                        selectedImage = image
                    }
                }
                selectedItem = nil
            }
            
        }
    }
}

#Preview {
    InputFormView()
}
