//
//  WebViewVC.swift
//  InstaCover
//
//  Created by Sameer Khan on 08/12/21.
//

import UIKit
import WebKit

class WebViewVC: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    @IBOutlet weak var viewForWeb: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var webViewProgress: UIProgressView!
    
    var webView: WKWebView!
    var isComeFrom: String?
    var loadableUrlStr: String?
    var isPresent = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setStatusBarGradientColor()
        
        if let str = isComeFrom {
            self.titleLbl.text = str
        }
        

        self.LoadWebView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: IBAction
    @IBAction func backBtnClicked(_ sender: UIButton) {
        
        if isPresent {
            self.dismiss(animated: true, completion: nil)
        }else {
            _ = self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    //MARK: Custom Methods
    func LoadWebView() {
        webView = self.addWKWebView(viewForWeb: viewForWeb)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        guard loadableUrlStr != "" else {
            return
        }
        
        if isComeFrom == "" {
            webView.loadHTMLString(loadableUrlStr ?? "", baseURL: nil)
        }else {
            let myURL = URL(string: loadableUrlStr ?? "")
            let myRequest = URLRequest(url: myURL!)
            webView.load(myRequest)
        }
        
        //add observer to get estimated progress value
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    func addWKWebView(viewForWeb:UIView) -> WKWebView {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        
        let webView = WKWebView(frame: viewForWeb.frame, configuration: webConfiguration)
        webView.frame.origin = CGPoint.init(x: 0, y: 0)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.frame.size = viewForWeb.frame.size
        viewForWeb.addSubview(webView)
        return webView
    }
    
    //MARK: WKWebView Delegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }
    
    //MARK: Observe value
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            print(self.webView.estimatedProgress)
            self.webViewProgress.progress = Float(self.webView.estimatedProgress)
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
