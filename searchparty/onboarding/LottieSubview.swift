//
//  LottieSubview.swift
//  SearchPartyIos
//
//  Created by Hannah Krolewski on 3/10/21.
//

import SwiftUI
import Lottie

struct LottieSubview: UIViewRepresentable {
    var filename: String
    typealias UIViewType = UIView

    func makeUIView(context: UIViewRepresentableContext<LottieSubview>) -> UIView {
        let view = UIView(frame: .zero)
        let animationView = AnimationView()
        let animation = Animation.named(filename)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        animationView.backgroundBehavior = .pauseAndRestore
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([animationView.widthAnchor.constraint(equalTo: view.widthAnchor), animationView.heightAnchor.constraint(equalTo: view.heightAnchor)])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieSubview>) {
        
            
        
    }
    
    
}

struct LottieSubview_Previews: PreviewProvider {
    static var previews: some View {
        LottieSubview(filename: "gift")
    }
}
