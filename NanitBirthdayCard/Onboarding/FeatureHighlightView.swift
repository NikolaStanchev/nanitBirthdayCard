//  FeatureHighlightView.swift
//  NanitBirthdayCard
//
//  Created by Nikola Stanchev on 8/2/25.
//

import SwiftUI

struct FeatureHighlightView: View {
    var feature: OnboardingFeatureCard
    var body: some View {
        HStack {
            Image(systemName: feature.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .padding(.trailing, 20)
                .foregroundStyle(.nanitPink)
            VStack(alignment: .leading) {
                Text(feature.title)
                    .font(.headline)
                    .fontWeight(.bold)
                Text(feature.description)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .transition(.opacity)
    }
}

#Preview {
//    FeatureHighlightView()
}
