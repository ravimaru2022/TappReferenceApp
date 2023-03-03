import Foundation
import WebKit
import Sentry
public protocol alertDelegate: class {
    func myVCDidFinish( text: String)
}
public protocol hidePanelView{
    func hidePanelfromLibrary()
}

public enum ValidationState {
    case valid
    case invalid(String)
}

public class WebkitClass: BaseClass {
    
    public lazy var webView = WKWebView()
    public var delegate: alertDelegate?
    public var delegateHide: hidePanelView?

    private var sportsbook = ""
    private var subscriberArr = [String]()
    var view = UIView()
    var jsonString = String()
    var isPanelAvailable = false

    
    override public init() {}
    
    public func initPanel(gameInfo: [String: Any], currView: UIView) {
        
        //        configureAmplify()
        configureSentry()
        webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        if checkNilInputParam(panelData: gameInfo, currView: currView) {
            switch checkPanelDataParam(panelData: gameInfo, currView: currView){
            case .valid:
                print("valid input")
                print("~~~~objectPanelData=", objectPanelData)
                
                print("frame:", currView.frame.width)
                
                let contentController = self.webView.configuration.userContentController
                contentController.add(self, name: "toggleMessageHandler")
                contentController.add(self, name: "showPanelData")
                view = currView
                //proceed further
            case .invalid(let err):
                self.exceptionHandleHTML(errMsg: err)
                
                let error = NSError(domain: "MethodName: init : \(err) \(gameInfo.description)" , code: 0, userInfo: nil)
                SentrySDK.capture(error: error)
            }
        } else {
            let error = NSError(domain: "Nil Input parameter in init." , code: 0, userInfo: nil)
            SentrySDK.capture(error: error)
        }
    }
    
    
    public func start(){
        
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        
        webView.navigationDelegate = self
        
        webView.backgroundColor = UIColor.clear
        webView.isOpaque = false
        
        let customBundle = Bundle(for: WebkitClass.self)
        guard let resourceURL = customBundle.resourceURL?.appendingPathComponent("dist.bundle") else { return }
        guard let resourceBundle = Bundle(url: resourceURL) else { return }
        guard let jsFileURL = resourceBundle.url(forResource: "index", withExtension: "html" ) else { return }
        
        webView.loadFileURL(jsFileURL, allowingReadAccessTo: jsFileURL.deletingLastPathComponent())
        
        // if let url = Bundle(for: WebkitClass.self).url(forResource: "index", withExtension: ".html") {
        //         webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        //     }
        isPanelAvailable = true
        webView.configuration.preferences.javaScriptEnabled = true
    }
    
    public func loadDataJS (objPanelData : [String: Any]){
        // print("...~~~~objectPanelData at loadDataJS=", objPanelData)
        guard let dict = objPanelData[TapppContext.Request.GAME_INFO] as? [String:Any] else {
            return
        }
        
        guard let widthDict = dict[TapppContext.Request.WIDTH] as? [String:Any] else {
            return
        }
        guard let broadcasterName = dict[TapppContext.Sports.BROADCASTER_NAME] as? String  else {
            return
        }
        let widthVal = widthDict[TapppContext.Request.VALUE] as! String
        let gameId = dict[TapppContext.Sports.GAME_ID] as! String
        let bookId = dict[TapppContext.Request.BOOK_ID] as! String
        let userId = dict[TapppContext.User.USER_ID] as! String
        
        self.webView.evaluateJavaScript("handleMessage('\(gameId)', '\(bookId)', '\(widthVal)', '\(broadcasterName)', '\(userId)', '\(frameUnit)');", completionHandler: { result, error in
            if let val = result as? String {
                print(val)
            }
            else {
                print("result is NIL")
            }
        });
    }
    
    public func subscribe(event: String, completion: (String)->()){
        subscriberArr.append(event)
        print(subscriberArr)
        completion("subscriber configured")
    }
    public func unSubscribe(event: String, completion: (String)->()){
        
        if let index = subscriberArr.firstIndex(of: event)
        {
            subscriberArr.remove(at: index)
        }
        print(subscriberArr)
        completion("unSubscriber configured")
    }
    
    
    public func stop(){
        if #available(iOS 14.0, *) {
            webView.configuration.userContentController.removeAllScriptMessageHandlers()
        } else {
            // Fallback on earlier versions
        }
        webView.removeFromSuperview()
    }
    // conditional code based on API.
    public func showPanel(){
        self.start()
    }
    public func hidePanel(){
        if isPanelAvailable {
            isPanelAvailable = false
            delegateHide?.hidePanelfromLibrary()
        } else {
            let error = NSError(domain: "Error in hide panel. Trying to hide invisible panel." , code: 0, userInfo: nil)
            SentrySDK.capture(error: error)
        }
    }
}

extension WebkitClass: WKScriptMessageHandler {
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let dict = message.body as? [String : AnyObject] else {
            return
        }
        
        print("received detail:", dict["message"])
        if message.name == "toggleMessageHandler", let dict = message.body as? NSDictionary {
            let userName = dict["message"] as! String
            if subscriberArr.contains(where: {$0 == "toastDisplay"}){
                delegate?.myVCDidFinish(text: userName)
            }
        } else if message.name == "showPanelData"{
            
        }
    }
}

extension WebkitClass: WKNavigationDelegate{
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.loadDataJS(objPanelData: self.objectPanelData)
    }
    
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
        let error = NSError(domain: "Webview failed loading \(error.localizedDescription)" , code: 0, userInfo: nil)
        SentrySDK.capture(error: error)
    }
}
