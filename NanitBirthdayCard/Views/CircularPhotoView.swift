//
//  CircularPhotoView.swift
//  NanitBirthdayCard
//
//  Created by Nikola Stanchev on 7/31/25.
//

import SwiftUI

struct CircularPhotoView: View {
    @Binding var image: UIImage?
    @Binding var theme: Theme
    
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                Circle()
                    .stroke(theme.color, lineWidth: 5)
                    .frame(width:305, height: 305)
                    .background(.clear)
                Spacer()
            }
            if let safeimage = image {
                Image(uiImage: safeimage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(.circle)
                    .frame(width:300, height: 300)
                    .transition(.opacity.combined(with: .scale))
            } else {
                // An equivalent to ContentUnavailableView, but since it's only available from iOS 17 and above
                // and the same implementation would have to be done for the case of iOS 16, better to only use one as below
                VStack {
                    Image(systemName: "photo.on.rectangle.angled")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .foregroundStyle(.gray)
                    Text("No photo chosen")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text("Tap here to choose a photo")
                        .foregroundStyle(.gray)
                }
                
            }
            Image(theme.cameraIcon)
                .rotationEffect(.degrees(45))
                .offset(x: 305/2)
                .rotationEffect(.degrees(-45))
        }
        .contentShape(Circle())
    }
}

#Preview {
    @State var image: UIImage? = UIImage(systemName: "photo")
    
    CircularPhotoView(image: $image, theme: .constant(.blue))
}
