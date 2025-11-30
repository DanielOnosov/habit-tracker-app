//
//  ContentView.swift
//  HabitTracker
//
//  Created by Danylo Onosov on 22.11.2025.
//

import SwiftUI

struct ViewWrapper: UIViewRepresentable {
    let view: UIView
    
    func makeUIView(context: Context) -> UIView {
        view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {    }
}
