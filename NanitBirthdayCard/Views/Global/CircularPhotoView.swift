//
//  CircularPhotoView.swift
//  NanitBirthdayCard
//
//  Created by Nikola Stanchev on 7/31/25.
//

import SwiftUI

/// A view to display the selected user photo in circle with border
struct CircularPhotoView: View {
    @Binding var imageTest: Image?
    @Binding var theme: Theme
    @Binding var hideCameraIcon: Bool
    
    @State var circleSize: CGFloat = 0
    var isForCapture: Bool
    var body: some View {
        ZStack {
            HStack {
                Circle()
                    .stroke(theme.color, lineWidth: 5)
                    .frame(maxWidth: .infinity)
                    .background(
                        GeometryReader { proxy in
                            Color.clear
                                .onAppear {
//                                    print("[CircularPhotoView] <-- Size is: \(proxy.size)")
                                    circleSize = proxy.size.height
                                }
                                .onChange(of: proxy.size) { newValue in
//                                    print("[CircularPhotoView] <-- Size change!: \(newValue)")
                                    circleSize = newValue.height
                                }
                        }
                    )
                    .overlay(
                        imageTest?
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                            .padding(2)
                    )
                    
            }
            
            Image(theme.cameraIcon)
                .rotationEffect(.degrees(45))
                .offset(x: circleSize/2)
                .rotationEffect(.degrees(-45))
                .opacity(isForCapture ? 0 : 1)
        }
        .contentShape(Circle())
    }
}

#Preview {
    //    CircularPhotoView(image: $image, theme: .constant(.blue))
}
