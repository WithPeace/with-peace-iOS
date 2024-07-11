//
//  WebViewAssistantViewController.swift
//  CheongHa
//
//  Created by Dylan_Y on 7/11/24.
//

import UIKit
import WebKit

final class WebViewAssistantViewController: UIViewController, WKNavigationDelegate {
    
    private var webView = WKWebView()
    private var urlString: String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView(frame: self.view.frame)
        webView.navigationDelegate = self
        self.view.addSubview(webView)
        
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
        self.navigationItem.leftBarButtonItem?.title = nil
        view.backgroundColor = .systemBackground
        configureLayout()
        
        // 기본 백 버튼 숨기기
        self.navigationItem.hidesBackButton = true
        
        // 커스텀 백 버튼 추가
        
        let backButton = UIBarButtonItem(image: UIImage(named: Const.CustomIcon.ICBtnPostcreate.icSignBack),
                                         style: .plain, 
                                         target: self,
                                         action: #selector(backButtonTapped))
        
        backButton.tintColor = .black
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc
    func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func configureLayout() {
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    init(urlString: String) {
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // WKNavigationDelegate 메서드 구현 (선택 사항)
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Started to load")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished loading")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("Failed to load with error: \(error.localizedDescription)")
    }
}
