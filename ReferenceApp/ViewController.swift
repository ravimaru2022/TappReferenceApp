import UIKit
import AVKit
import TapppPanelLibrary

class ViewController: UIViewController, updateOverlayViewFrame {
    func updateOverlayFrame(value: String) {
        print("updateOverlayFrame called")
        if let doubleValue = Double(value) {
            constWidthConstrain.constant = CGFloat(doubleValue)
        }
    }
    
    
    var avPlayer: AVPlayer!
    var playerViewController: AVPlayerViewController!
    private lazy var playerView: UIView = {
        let view = playerViewController.view!
        view.translatesAutoresizingMaskIntoConstraints  = false
        return view
    }()
    @IBOutlet weak var overlayView: UIView!
    var obj = WebkitClass()
    
    let BROADCASTER_NAME = "TRN"//NFL //TRN
    
    var GAME_ID = ""
    var USER_ID = ""

    let BOOK_ID = "1000009"
    
    @IBOutlet var constWidthConstrain: NSLayoutConstraint!
    var frameWidth = 0.3
    var VIDEO_URL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doGetVideoUrl()
        
        var objPanelData = [String: Any]()
        var gameInfo = [String : Any]()
        
        objPanelData[TapppContext.Sports.GAME_ID] = GAME_ID
        objPanelData[TapppContext.Sports.BROADCASTER_NAME] = BROADCASTER_NAME
        objPanelData[TapppContext.User.USER_ID] = USER_ID//const val USER_ID = "user_id"
        
//        Set width dynamically
        constWidthConstrain.constant = self.view.frame.size.width * frameWidth
        var frameWidth = [String : String]()
        frameWidth["unit"] = "px"
        frameWidth["value"] = "200"
        objPanelData["width"] = frameWidth
        
        gameInfo[TapppContext.Request.GAME_INFO] = objPanelData
        
        obj.delegateFrame = self
        obj.initPanel(gameInfo: gameInfo, currView:overlayView)
        overlayView.backgroundColor = UIColor.clear
        self.obj.start()
    }
    
    func playVideo() {
        DispatchQueue.main.async {

            let videoURL = URL(string: self.VIDEO_URL)
            self.avPlayer = AVPlayer(url: videoURL!)
            self.playerViewController = AVPlayerViewController()
            self.playerViewController.player = self.avPlayer
            self.playerViewController.showsPlaybackControls = false
            self.avPlayer.isMuted = true
            self.avPlayer.play()

            self.view.addSubview(self.playerView)
            //self.view.sendSubviewToBack(self.playerView)
            self.view.bringSubviewToFront(self.overlayView)
       }
    }
}

extension ViewController {
    
    func doGetVideoUrl() {
        var apiInputURL = ""
        if (BROADCASTER_NAME == "NFL"){
            GAME_ID = "712ee5f8-eea4-4db6-9a08-01e6137c62c0"
            USER_ID = "USR1234"
            apiInputURL = "https://dev-betapi.tappp.com/gameplay-engine/game/\(GAME_ID)/stream/url"
        } else {
            GAME_ID = "cb0403c8-0f3c-4778-8d26-c4a63329678b"
            USER_ID = "cf9bb061-a040-4f43-9165-dac3adfb4258"
            apiInputURL = "https://sandbox-mlr-betapi.tappp.com/gameplay-engine/game/\(GAME_ID)/stream/url"
        }
        self.getVideoUrlAPI(inputURL: apiInputURL)
    }
    
    func getVideoUrlAPI(inputURL: String){
        let url = URL(string:inputURL)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    if let status = json?["code"] as? Int, status == 200 {
                        if let urlDict = json?["data"] as? [[String: Any]], let urlAddr = urlDict.first{
                            print(urlAddr["strean_url"])
                            self.VIDEO_URL = urlAddr["strean_url"] as! String
                            self.playVideo()
                        }
                    }
                } catch {
                    print(error)
                }
                //let image = UIImage(data: data)
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }
        task.resume()
    }
}
//extension ViewController:updateOverlayViewFrame{
//    func updateOverlayFrame(value: String) {
//        print(value)
//        if let doubleValue = Double(value) {
//            constWidthConstrain.constant = CGFloat(doubleValue)
//        }
//    }
//}

