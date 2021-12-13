//
//  AppointmentController.swift
//  HospitalOne
//
//  Created by Daniil Belikov on 18.10.2019.
//  Copyright © 2019 Tolyatti City Hospital No.1. All rights reserved.
//

import UIKit
import WebKit

final class AppointmentController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var containerView: UIView? = nil
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Life Cycles Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureActivityIndicator()
        configureWebView()
        loadWebView()
    }
    
}

// MARK: - WKNavigationDelegate Methods

extension AppointmentController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView,
                 didFinish navigation: WKNavigation!) {
        
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView,
                 didFail navigation: WKNavigation!,
                 withError error: Error) {
        
        activityIndicator.stopAnimating()
    }
    
}

// MARK: - Private Configure Methods

extension AppointmentController {
    
    func configureActivityIndicator() {
        // Configure display of Activity Indicator.
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
    }
    
    func configureWebView() {
        // Configure display of WebView.
        webView.isUserInteractionEnabled = true
        webView.addSubview(activityIndicator)
        webView.navigationDelegate = self
    }
    
    func loadWebView() {
        // Load WebView.
        guard let url = URL(string: GlobalConstants.API.appointment) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
}
