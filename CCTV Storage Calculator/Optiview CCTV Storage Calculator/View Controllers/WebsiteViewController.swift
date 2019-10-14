//
//  WebsiteViewController.swift
//  CCTV Storage Calculator
//
//  Created by Casualty on 10/11/19.
//  Copyright © 2019 Thomas Dye. All rights reserved.
//

import UIKit
import WebKit

class WebsiteViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://optiviewusa.com")!
        webView.load(URLRequest(url: url))
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh,
                                      target: webView,
                                      action: #selector(webView.reload))
        toolbarItems = [refresh]
        navigationController?.isToolbarHidden = false
    }
}
