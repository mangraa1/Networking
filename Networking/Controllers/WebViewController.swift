//
//  WebViewController.swift
//  Networking
//
//  Created by mac on 03.09.2023.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    //MARK: @IBOutlets & Variables

    var selectedCourse: String?
    var courseURL = ""

    @IBOutlet private weak var progressView: UIProgressView!
    @IBOutlet private weak var webView: WKWebView!

    //MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = selectedCourse

        guard let url = URL(string: courseURL) else { return }
        let request = URLRequest(url: url)

        webView.load(request)
        webView.allowsBackForwardNavigationGestures = true
        webView.navigationDelegate = self
        webView.addObserver(self,
                            forKeyPath: #keyPath(WKWebView.estimatedProgress),
                            options: .new,
                            context: nil)
    }

    //MARK: - ObserveValue

    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {

        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }

    //MARK: - Private

    private func showProgressView() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.progressView.alpha = 1
        }
    }

    private func hideProgressView() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.progressView.alpha = 0
        }
    }
}

//MARK: - WKNavigationDelegate

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showProgressView()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideProgressView()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideProgressView()
    }
}
