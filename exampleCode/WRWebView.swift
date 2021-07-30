//
//  WRWebView.swift
//  weridego
//
//  Created by chao huang on 2021/7/1.
//

import SwiftUI
import WebKit

struct WRWebView: UIViewRepresentable {
    let url: URL?
    
    func makeUIView(context: Context) -> WKWebView {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        return WKWebView(frame: .zero, configuration: config)
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard url != nil else {
            return
        }
        
        let request = URLRequest(url: url!)
        uiView.load(request)
    }
}
