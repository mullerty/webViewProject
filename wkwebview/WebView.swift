import Foundation
import WebKit
import SpriteKit
import UIKit

public class Ninasys: NSObject, WKNavigationDelegate, WKUIDelegate{
    
    private var webView: WKWebView!
    private var view: UIView
    private var url: String
    
    var URLCounter:Set<URL> = Set<URL>()
    
    public init(view:SKView, url:String){
        self.view = view
        self.url = url
        self.webView = WKWebView()//frame: .zero, configuration: webConfiguration)
        self.webView.frame = self.view.frame
        self.webView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1"
        self.webView.scrollView.isScrollEnabled = true
        
        self.webView.backgroundColor = UIColor.clear
        if #available(iOS 15.0, *) {
            self.webView.underPageBackgroundColor = self.webView.themeColor
        }
        self.webView.isOpaque = false
        self.webView.configuration.allowsInlineMediaPlayback = true
        self.webView.configuration.allowsAirPlayForMediaPlayback = true
        self.webView.configuration.allowsPictureInPictureMediaPlayback = true
        self.webView.configuration.mediaTypesRequiringUserActionForPlayback = []
        
        super.init()
        
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleLeftSwipe))
        leftSwipeGesture.direction = .left
        view.addGestureRecognizer(leftSwipeGesture)

        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleRightSwipe))
        rightSwipeGesture.direction = .right
        view.addGestureRecognizer(rightSwipeGesture)
        
        self.setView()
    }

    required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleLeftSwipe() {
        print("Left swipe detected")
        if webView.canGoForward {
            webView.goForward()
            URLCounter.insert(webView.url!)
        }
        print(URLCounter)
    }

    @objc func handleRightSwipe() {
        print("Right swipe detected")
        print(URLCounter.count)
        if webView.canGoBack && URLCounter.count > 2{
            URLCounter.remove(webView.url!)
            webView.goBack()
            URLCounter.insert(webView.url!)
        }
        print(URLCounter)
    }

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        URLCounter.insert(webView.url!)
        if URLCounter.count > 1{
            self.webView.backgroundColor = .white
        }
    }

    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {        if (navigationAction.targetFrame == nil) {
            let popup = WKWebView(frame: self.view.frame, configuration: configuration)
            popup.uiDelegate = self
            self.view.addSubview(popup)
            return popup
        }
        return nil;
    }
    
    public func webViewDidClose(_ webView: WKWebView) {
        webView.removeFromSuperview()
    }
    
    private func setView() {
        print("setView")
        if let urlObj = URL(string: self.url) {
            let request = URLRequest(url: urlObj)
            self.webView.load(request)
        }
        self.view.addSubview(self.webView)
    }
}
