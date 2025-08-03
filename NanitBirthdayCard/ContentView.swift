//
//  ContentView.swift
//  NanitBirthdayCard
//
//  Created by Nikola Stanchev on 7/31/25.
//

import SwiftUI

struct ContentView: View {
    @State private var showOnboarding: Bool = false
    @AppStorage("isFirstStart") private var isFirstStart: Bool = true
    var body: some View {
        NavigationStack {
            InputFormView()
        }
        .onAppear {
            if (isFirstStart != false) {
                showOnboarding = true
            }
        }
        .sheet(isPresented: $showOnboarding) {
            OnboardingView(onContinue: {
                isFirstStart = false
                showOnboarding = false
            })
            .interactiveDismissDisabled()
        }
    }
}

#Preview {
    ContentView()
}
