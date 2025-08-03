//
//  StaticCardViewCapture.swift
//  NanitBirthdayCard
//
//  Created by Nikola Stanchev on 8/2/25.
//
import SwiftUI
import PhotosUI

struct ViewForCapture: View {    
    // View properties associated with it's state
    @State var showChooseDialog: Bool = false
    @State var showPhotosPicker: Bool = false
    @State var showCameraView: Bool = false
    @State var selectedItem: PhotosPickerItem?
    @State var vStackSize: CGSize = CGSize()
    
    var vStackOffset: CGFloat
    var name: String
    var chosenImage: UIImage
    var theme: Theme
    var color: Color
    let test: Color = Color(uiColor: UIColor(red: 254/255, green: 231/255, blue: 183/255, alpha: 1))
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Text("Today \(name) is")
                        .textCase(.uppercase)
                        .truncationMode(.middle)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.bottom, 13)
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
                    Spacer(minLength: 50)
                    //--------------------------------------------------------------------------
                    ZStack {
                        HStack {
                            Circle()
                                .stroke(Color.init(hex: theme.colorHex), lineWidth: 5)
                                .frame(maxWidth: .infinity)
                                .background(.clear)
                                .background(
                                    GeometryReader { proxy in
                                        Color.clear

                                    }
                                )
                        }
                            Image(uiImage: chosenImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(.circle)
                                .frame(width: vStackSize.width > 5 ? (vStackSize.width - 5) : vStackSize.width, height: vStackSize.width > 5 ? (vStackSize.width - 5) : vStackSize.width)
                                .transition(.opacity.combined(with: .scale))
//
//                        Image(theme.background)
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .clipShape(.circle)
//                            .frame(width: vStackSize.width > 5 ? (vStackSize.width - 5) : vStackSize.width, height: vStackSize.width > 5 ? (vStackSize.width - 5) : vStackSize.width)
//                            
//                            .transition(.opacity.combined(with: .scale))
                    }
                    .contentShape(Circle())
                    //--------------------------------------------------------------------------
                    Spacer(minLength: 50)
                }
                .padding(.bottom, 15)
                
            }
            .background(
                GeometryReader { proxy in
                    Color.clear
//                                .onAppear {
//                                    print("SIze is: \(proxy.size)")
//                                    circleSize = proxy.size.height
//                                }
                        .onChange(of: proxy.size) { newValue in
                            print("Size change!: \(newValue)")
                            vStackSize = newValue
                        }
                }
            )
            Image(theme.background)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .frame(maxHeight: UIScreen.main.bounds.height)
                .allowsHitTesting(false)
            VStack(spacing: 0) {
                Spacer(minLength: vStackOffset)
                    .allowsHitTesting(false)
                Image("Nanit_logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 25)
                    .padding(.bottom, 53)
                    .allowsHitTesting(false)
                Spacer()
            }

        }
        .background(Color.init(hex: theme.colorSecondaryHex))
        
    }
}
