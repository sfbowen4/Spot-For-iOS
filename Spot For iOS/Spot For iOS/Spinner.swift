//
//  Spinner.swift
//  Spot For iOS
//
//  Created by Stephen Bowen on 6/14/21.
//

import Foundation
import SwiftUI

// Spinner to show when loading tasks
struct Spinner: UIViewRepresentable {
    
    let isAnimating: Bool
    let style: UIActivityIndicatorView.Style
    let color: UIColor

    func makeUIView(context: UIViewRepresentableContext<Spinner>) -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView(style: style)
        spinner.hidesWhenStopped = true
        spinner.color = color
        return spinner
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<Spinner>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
