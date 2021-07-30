//
//  WRLottieView.swift
//  weridego
//
//  Created by chao huang on 2021/6/30.
//

import SwiftUI
import Lottie
import UIKit

struct WRLottieView: UIViewRepresentable {
    var name: String
    
    typealias UIViewType = UIView
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        
        // add animation
        let animationView = AnimationView()
        animationView.animation = Animation.named(name)
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.play()
        view.addSubview(animationView)
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}
