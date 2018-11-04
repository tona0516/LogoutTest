//
//  ViewController.swift
//  LogoutTest
//
//  Created by 豊住尚弥 on 2018/11/03.
//  Copyright © 2018 tona0516. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    var request: URLRequest!
    var webview: WKWebView!
    let LOGOUT_URL = "https://login.yahoo.co.jp/config/login?logout=1"
    let YTOP_URL = "https://www.yahoo.co.jp/"
    var startTime: Date!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.prepareRequest()
    }


    @IBAction func clickLogout(_ sender: Any) {
        // 都度WKWebViewを精製すると+1秒かかる
//        self.prepareRequest()
        self.webview.load(self.request)
        self.startTime = Date()
    }
    
    func prepareRequest() {
        let preferences = WKPreferences()
        // JavaScriptを有効にすると+1秒かかる
        preferences.javaScriptEnabled = false
        
        let config = WKWebViewConfiguration()
        config.preferences = preferences
        
        self.webview = WKWebView(frame: CGRect.zero, configuration: config)
        self.webview.navigationDelegate = self
        
        guard let url = URL(string: LOGOUT_URL) else {
            print("logout url is invalid")
            return
        }
        self.request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 5)
        
//        self.loadEmptyRequest()
    }
    
    func loadEmptyRequest() {
        guard self.webview != nil else {
            print("webview is nil")
            return
        }
        
        // YTOPでは高速化する
        // レスポンス速度が最後にしたリクエストに影響される？
        self.webview.load(URLRequest(url: URL(string: YTOP_URL)!))
        
        // GoogleのURLでは初回リクエストは高速化しない
//        self.webview.load(URLRequest(url: URL(string: "https://www.google.co.jp/")!))
    }
    
}

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            print("url is nil")
            decisionHandler(.cancel)
            return
        }
        
        if startTime != nil {
            print("decidePolicyForNavigationAction: \(url.host ?? "ホストなし") \(Date().timeIntervalSince(startTime))")
        }
        
        guard url.absoluteString.hasPrefix(LOGOUT_URL) else {
            decisionHandler(.cancel)
            return
        }
        
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        guard startTime != nil else {
            print("startTime is nil")
            return
        }
        
        guard let url = self.webview.url else {
            print("url is nil")
            return
        }
        
        // ログアウト完了=m.yahoo.co.jpとすれば0.4秒削減できる（yjtagへの）
        print("didCommit: \(url.host ?? "ホストなし") \(Date().timeIntervalSince(startTime))")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard startTime != nil else {
            return
        }
        
        guard let url = self.webview.url else {
            print("url is nil")
            return
        }
        
        // m.yahoo.co.jpへの遷移完了をログアウト完了とすると-0.4秒の削減
        print("didFinish: \(url.host ?? "ホストなし") \(Date().timeIntervalSince(startTime))")
        print("----------")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("didFail: \(error.localizedDescription)")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("didFailProvisionalNavigation: \(error.localizedDescription)")
    }
    
}

