//  OnboardingView.swift
//  NanitBirthdayCard
//
//  Created by Nikola Stanchev on 8/2/25.
//


import SwiftUI

struct OnboardingFeatureCard: Hashable {
    let title: String
    let description: String
    let imageName: String
}

struct OnboardingView: View {
    @State var didAppear: Bool = false
    let onFinish: () -> ()
    var features: [OnboardingFeatureCard] = [
        OnboardingFeatureCard(title: "Create stunning birthday cards", description: "Easily create birthday card for yourself or your friends.", imageName: "pencil"),
        OnboardingFeatureCard(title: "Don't loose your progress", description: "Don't remember the birth date...We get it, even if you close the app the name will stay saved on the next launch", imageName: "bookmark"),
        OnboardingFeatureCard(title: "Share it!", description: "Share your beutiful card with the world, or just save it for yourself", imageName: "square.and.arrow.up")
    ]
    
    @State var animateIcon: Bool = false
    @State var animateTitle: Bool = false
    @State var animateFeatureCards: [Bool]
    @State var animateButton: Bool = false
    
    init(onContinue: @escaping () -> Void) {
        self.onFinish = onContinue
        self._animateFeatureCards = .init(initialValue: Array(repeating: false, count: features.count))
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Image("Icons/AppIconPreview")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 10)
                .blurSlide(animateIcon)
                .padding(.vertical, 50)
            VStack {
                Text("Welcome to")
                    .font(.title)
                    .fontWeight(.bold)
                Text("The Birthday Card App")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 50)
            }
            .blurSlide(animateIcon)
            
            ForEach(Array(features.enumerated()), id: \.offset) { index, feature in
                FeatureHighlightView(feature: feature)
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .blurSlide(animateFeatureCards[index])
            }
            
            Spacer()
            
            VStack {
                HStack {
                    
                    VStack(alignment: .leading) {
                        Image(systemName: "append.page")
                        
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .padding(.trailing, 20)
                            .foregroundStyle(.nanitPink)
                        Text("By clicking 'Continue' you are agreeing to nothing really, enjoy :)")
                            .fontWeight(.semibold)
                            .font(.caption)
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(3)
                            .foregroundStyle(.gray)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
                Button {
                    print("Clicked button")
                    onFinish()
                } label: {
                    Text("Continue")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                }
                .tint(.nanitPink)
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .padding(.horizontal, 20)
            }
            .blurSlide(animateButton)
        }
        .task {
            guard !animateIcon else { return }
            
            await delayedAnimation(0.35) {
                animateIcon = true
            }
            
            await delayedAnimation(0.2) {
                animateTitle = true
            }
            
            await delayedAnimation(0.5) {
                animateButton = true
            }
            
            for index in animateFeatureCards.indices {
                let delay = Double(index) * 0.1
                await delayedAnimation(delay) {
                    animateFeatureCards[index] = true
                }
            }
            
        }

    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - delay: <#delay description#>
    ///   - action: <#action description#>
    func delayedAnimation(_ delay: Double, action: @escaping () -> ()) async {
        try? await Task.sleep(for: .seconds(delay))
        
        withAnimation(.smooth) {
            action()
        }
    }
}

// An extension of View for blur slide appearing animation
extension View {
    @ViewBuilder
    func blurSlide(_ show: Bool) -> some View {
        self
            .compositingGroup()
            .blur(radius: show ? 0 : 10)
            .opacity(show ? 1 : 0)
            .offset(y: show ? 0 : 100)
    }
}

#Preview {
//    OnboardingView()
}
