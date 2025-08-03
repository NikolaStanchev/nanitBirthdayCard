//
//  BirthdayCardView.swift
//  NanitBirthdayCard
//
//  Created by Nikola Stanchev on 8/2/25.
//

import SwiftUI
import PhotosUI

struct BirthdayCardView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    // View properties associated with it's state
    @State var showChooseDialog: Bool = false
    @State var showPhotosPicker: Bool = false
    @State var showCameraView: Bool = false
    @State var selectedItem: PhotosPickerItem?
    @State var vStackSize: CGSize = CGSize()
    
    @State var highResolutionCapturedImage: Image?
    @State var isBeingCaptured: Bool = false
    //    TESTING
    @State var viewSize: CGSize = .zero
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Text("Today \(viewModel.name) is")
                        .textCase(.uppercase)
                        .truncationMode(.middle)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.bottom, 13)
                        .padding(.top, 15)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
                HStack {
                    Spacer()
                    Image("Other/Left_swirls")
                        .padding(.trailing, 22)
                    Image("Numbers/1")
                    Image("Numbers/1")
                    Image("Other/Right_swirls")
                        .padding(.leading, 22)
                    Spacer()
                }
                .padding(.bottom, 14)
                Text("Month old!")
                    .textCase(.uppercase)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                CircularPhotoView(imageTest: $viewModel.imageTest, theme: $viewModel.theme, hideCameraIcon: $isBeingCaptured, isForCapture: false)
                    .onTapGesture {
                        showChooseDialog = true
                    }
                //                }
                Spacer()
                    .padding(.bottom, 15)
                
            }
            Image(viewModel.theme.background)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .frame(maxHeight: UIScreen.main.bounds.height)
                .allowsHitTesting(false)
            VStack(spacing: 0) {
                Spacer()
                    .allowsHitTesting(false)
                Image("Nanit_logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 25)
                    .padding(.bottom, 53)
                    .allowsHitTesting(false)
                if let safeCapturedImage = highResolutionCapturedImage {
                    ShareLink(item: safeCapturedImage, preview: SharePreview("Share")) {
                        HStack {
                            Spacer()
                            Text("Share the news")
                                .foregroundStyle(.white)
                            Image("Icons/ic_share")
                            Spacer()
                        }
                        .frame(height: 50)
                        .background(.nanitPink)
                        .clipShape(Capsule())
                        .padding(.horizontal, 20)
                        .padding(.bottom, 53)
                    }
                    
                }
                
            }
            
        }
        .background(viewModel.theme.colorSecondary)
        .photoCameraSelectionPresenter(showPhotosPicker: $showPhotosPicker, showCameraView: $showCameraView, selectedItem: $viewModel.imageSelection, selectedImage: $viewModel.imageTest, showChooseDialog: $showChooseDialog)
        .onAppear {
            if viewModel.imageTest == nil {
                viewModel.imageTest = Image(viewModel.theme.placeholderImage)
            }
            calculateDate(for: viewModel.birthdayDate)
            captureSnapshot()
        }
        .onChange(of: viewModel.imageTest) { _ in
            captureSnapshot()
        }
        
        
    }
    
    var capturableView: some View {
        return ZStack(alignment: .top) {
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Text("Today \(viewModel.name) is")
                        .textCase(.uppercase)
                        .truncationMode(.middle)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.bottom, 13)
                        .padding(.top, 15)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
                HStack {
                    Spacer()
                    Image("Other/Left_swirls")
                        .padding(.trailing, 22)
                    Image("Numbers/1")
                    Image("Numbers/1")
                    Image("Other/Right_swirls")
                        .padding(.leading, 22)
                    Spacer()
                }
                .padding(.bottom, 14)
                Text("Month old!")
                    .textCase(.uppercase)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                HStack {
                    CircularPhotoView(imageTest: $viewModel.imageTest, theme: $viewModel.theme, hideCameraIcon: .constant(true), isForCapture: true)
                        .onTapGesture {
                            showChooseDialog = true
                        }
                        .padding(.horizontal, 50)
                }
                .padding(.bottom, 15)
                Spacer()
                
            }
            Image(viewModel.theme.background)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .frame(maxHeight: UIScreen.main.bounds.height)
                .allowsHitTesting(false)
            VStack(spacing: 0) {
                Spacer()
                    .allowsHitTesting(false)
                Image("Nanit_logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 25)
                    .padding(.bottom, 106)
                    .allowsHitTesting(false)
            }
            
        }
        .background(viewModel.theme.colorSecondary)
    }
    
    func captureSnapshot() {
        isBeingCaptured = true
        let contentToCapture = capturableView
        let renderer = ImageRenderer(content: contentToCapture)
        print("[BirthdayCardView] <-- CAPTURED!")
        isBeingCaptured = false
        renderer.scale = 3
        if let safeImage = renderer.cgImage {
            highResolutionCapturedImage = Image(decorative:safeImage , scale: 1.0)
        } else {
            print("[BirthdayCardView] <-- NO HIGH RES IMAGE!")
        }
    }
    
    func calculateDate(for date: Date) {
        var numbersToDisplay: [String] = []
        let dateComponents = Calendar.current.dateComponents([.year, .month], from: date, to: .now)
        let months = dateComponents.month ?? 0
        let years = dateComponents.year ?? 0
        
        print("[BirthdayCardView] <-- Date components are: \(dateComponents)")
        if years > 0 {
            print("should calculate years")
            print("user is \(years) years old")
        } else {
            print("should calculate months")
            print("user is \(months) months old")
        }
        
        
        
        
    }
}

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        
    }
}

extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometry in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometry.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}

#Preview {
    //    BirthdayCardView()
}
