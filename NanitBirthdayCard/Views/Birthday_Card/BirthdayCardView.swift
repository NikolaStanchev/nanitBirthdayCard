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
    @State var digitsToDisplay: [String] = []
    @State var timeMeasurementToDisplay: String = "Months"
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                //------ Header
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
                    ForEach(digitsToDisplay, id:\.self) { digit in
                        Image(digit)
                    }
                    Image("Other/Right_swirls")
                        .padding(.leading, 22)
                    Spacer()
                }
                .padding(.bottom, 14)
                Text("\(timeMeasurementToDisplay) old!")
                    .textCase(.uppercase)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                //------
                //------ Selected photo view
                CircularPhotoView(imageTest: $viewModel.image, theme: $viewModel.theme, hideCameraIcon: .constant(false), isForCapture: false)
                    .onTapGesture {
                        showChooseDialog = true
                    }
                    .padding(.horizontal, 50)
                //------
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
        .photoCameraSelectionPresenter(showPhotosPicker: $showPhotosPicker, showCameraView: $showCameraView, selectedItem: $viewModel.imageSelection, selectedImage: $viewModel.image, showChooseDialog: $showChooseDialog)
        .onAppear {
            if viewModel.image == nil {
                viewModel.image = Image(viewModel.theme.placeholderImage)
            }
            calculateDate(for: viewModel.birthdayDate)
            captureSnapshot()
        }
        .onChange(of: viewModel.image) { newImage in
            if newImage == nil {
                viewModel.image = Image(viewModel.theme.placeholderImage)
            }
            captureSnapshot()
        }
        
        
    }
    
    // a variable representing the view we want to capture for sharing/exporting the birthday card. A near identical copy of the body of this current view, just with buttons and functionality removed,
    // it just represents the view the use is seeing but in a way to pass it to the RenderImage object
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
                    ForEach(digitsToDisplay, id:\.self) { digit in
                        Image(digit)
                    }
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
                    CircularPhotoView(imageTest: $viewModel.image, theme: $viewModel.theme, hideCameraIcon: .constant(true), isForCapture: true)
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
        //        print("[BirthdayCardView] <-- CAPTURED!")
        isBeingCaptured = false
        renderer.scale = 3
        if let safeImage = renderer.cgImage {
            highResolutionCapturedImage = Image(decorative:safeImage , scale: 1.0)
        } else {
            //            print("[BirthdayCardView] <-- NO HIGH RES IMAGE!")
        }
    }
    
    /// Function for calculating wether the displayed age should be in years or months and the calling function for getting the respective images from the assets
    /// - Parameter date: the date to check for
    func calculateDate(for date: Date) {
        
        let dateComponents = Calendar.current.dateComponents([.year, .month], from: date, to: .now)
        let months = dateComponents.month ?? 0
        let years = dateComponents.year ?? 0
        var age = 0
        
        if years > 0 {
            age = years
            switch (years > 1) {
            case true:
                timeMeasurementToDisplay = "years"
            case false:
                timeMeasurementToDisplay = "year"
            }
            
        } else {
            age = months
            switch (months) {
            case _ where months > 1 :
                timeMeasurementToDisplay = "months"
            case _ where months == 1 :
                timeMeasurementToDisplay = "month"
            default:
                timeMeasurementToDisplay = "monts"
            }
            
        }
        
        getNumbersToDiplay(for: age)
    }
    
    /// Function used for getting the names of image assets to represent a given Int example: 12 would mean the image assets Numbers/1 & Numbers/2 would be added to the array as strings for referencing them in Image("resourseName")
    /// - Parameter number:
    func getNumbersToDiplay(for number:Int) {
        digitsToDisplay.removeAll()
        // Make an array of the digits of the number as strings, for handling getting of the custom digits assets for displaying the age
        let stringifiedDigits = String(number).compactMap( {Int(String($0))})
        
        for digit in stringifiedDigits {
            digitsToDisplay.append("Numbers/\(digit)")
        }
        
    }
}
