//
//  WebViewController.swift
//  LogoutTest
//
//  Created by 豊住尚弥 on 2018/11/05.
//  Copyright © 2018 tona0516. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class WebViewController: UIViewController {
    
    let LOGIN_URL = "https://login.yahoo.co.jp/config/login?.keep=1"
    @IBOutlet weak var webview: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webview.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1"
        self.webview.load(URLRequest(url: URL(string: LOGIN_URL)!))
    }
    
    @IBAction func clickClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
