//
//  WRMarquee.swift
//  weridego
//
//  Created by chao huang on 2021/5/17.
//

import SwiftUI

struct WRMarquee: View {
    @State var textWidth: CGFloat = 0
    @State private var state: WRMarqueeState = .idle
    var duration: Double

    var body: some View {
        GeometryReader { geo in
            HStack {
                Text("hello worldhello worldhello worldhello worldhello worldhello worldhello worldhello world")
                    .background(GeometryBackground())
                    .fixedSize()
                    .offset(x: offsetX(proxy: geo), y: 0)
                    .onAppear(){
                        withAnimation(.none) {
                            self.state = .ready
                            withAnimation(Animation.linear(duration: duration).repeatForever(autoreverses: false)) {
                                self.state = .animating
                            }
                        }
                    }
                    
            }
            .onPreferenceChange(WidthKey.self) { value in
                self.textWidth = value
            }
            .clipped()
        }
    }
    
    private func offsetX(proxy: GeometryProxy) -> CGFloat {
       switch self.state {
       case .idle:
           return 0
       case .ready:
           return proxy.size.width
       case .animating:
           return -textWidth
       }
   }
}

private enum WRMarqueeState {
    case idle
    case ready
    case animating
}


struct GeometryBackground: View {
    var body: some View {
        GeometryReader { geometry in
            return Color.clear.preference(key: WidthKey.self, value: geometry.size.width)
        }
    }
}

struct WidthKey: PreferenceKey {
    static var defaultValue = CGFloat(0)
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
    typealias Value = CGFloat
}
