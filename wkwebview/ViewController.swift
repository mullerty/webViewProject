import UIKit
import SpriteKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    //var webView: WKWebView!
    //var upperWebViewController: Ninasys!
    @IBOutlet weak var webV: WKWebView!
    
    override func loadView() {
        webV = WKWebView()
        webV.navigationDelegate = self
        view = webV
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://www.oshi.io/games/plinko-bgaming")!
        webV.load(URLRequest(url: url))
        webV.allowsBackForwardNavigationGestures = true
        //upperWebViewController = Ninasys(view: view as! SKView, url: "https://www.oshi.io/games/plinko-bgaming")
    }


}

