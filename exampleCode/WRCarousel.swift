//
//  WRPageView.swift
//  weridego
//
//  Created by chao huang on 2021/5/14.
//

import SwiftUI

struct WRCarousel<Content: View>: View {
    @State var selectedIndex: Int = 0
    var contents: [Content]
    var onDismiss: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 12) {
                TabView(selection: $selectedIndex) {
                    ForEach(0..<contents.count) { index in
                        contents[index]
                            .frame(height: self.selectedIndex == index ? geometry.size.height * 0.9 : geometry.size.height * 0.8)
                            
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .animation(.easeOut)
                
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(Color.gray)
                    .font(.title)
                    .onTapGesture {
                        onDismiss()
                    }
            }
            
            
        }
    }
}
