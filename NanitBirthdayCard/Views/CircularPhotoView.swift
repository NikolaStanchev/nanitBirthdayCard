//
//  CircularPhotoView.swift
//  NanitBirthdayCard
//
//  Created by Nikola Stanchev on 7/31/25.
//

import SwiftUI

struct CircularPhotoView: View {
    @Binding var image: UIImage?
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                Circle()
                    .stroke(.gray, lineWidth: 5)
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
                if #available(iOS 17.0, *) {
                    ContentUnavailableView("No photo chosen", systemImage: "photo.on.rectangle.angled", description: Text("Tap here to choose a photo"))
                } else {
                    // Fallback on earlier versions
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
                
            }
        }
    }
}

#Preview {
    @State var image: UIImage? = UIImage(systemName: "photo")
    
    CircularPhotoView(image: $image)
}
