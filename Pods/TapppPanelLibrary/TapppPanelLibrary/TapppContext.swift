import Foundation
import UIKit

public class TapppContext {
    
    public static let CURRENT_DEVICE                             =      UIDevice.current.name
    public static let CURRENTDEVICE_SIZE                         =      UIScreen.main.bounds.size
    public static let CURRENT_OS_VERSION                         =      UIDevice.current.systemVersion
    public static let USERDEFAULTS                               =      UserDefaults.standard
    public static let GLOBAL_LANG                                =      "en"
    public static let GLOBAL_POSITION                            =      "topRight"
    
    public init() {}
    
    public struct Environment {
        public static let PROD = "prod"
        public static let STAGE = "stage"
        public static let TEST = "test"
        public static let DEV = "dev"
        public static let ENVIRONMENT = "evr"
    }
    
    public struct Sports {
        public static let GAME_ID = "gameId"
        public static let BROADCASTER_NAME = "broadcasterName"
        public static let TRN = "TRN"
        public static let NFL = "NFL"
    }
    
    public struct  User {
        public static let USER_ID = "user_id"
    }
    
    public struct  Request {
        public static let GAME_INFO = "gameInfo"
        public static let WIDTH = "width"
        public static let VALUE = "value"
        public static let BOOK_ID = "bookId"
        public static let LANGUAGE = "lang"

        public static let CONTEST_ID = "contest_id"
        public static let OFFER_ID = "offer_id"
        public static let OUTCOME_ID = "outcome_id"
        

        public static let POSITION = "position"
        public static let UNIT = "unit"
        public static let PANELMULTIPLIER = "panelSizeMultiplier"
        public static let UNIT_VAL = "px"
    }
    
    public struct errorMessage {
        public static let GAMESETTING_OBJECT_NOT_FOUND = "Panel Settings not found"
        public static let PANEL_INFO_OBJECT_NOT_FOUND = "Panel Data not found"
        public static let GAMEINFO_OBJECT_NOT_FOUND = "GameInfo object not found"
        public static let GAMEID_NOT_FOUND = "GameId not found"
        public static let GAMEID_NULL_EMPTY = "GameId null or empty"
        public static let BOOKID_NOT_FOUND = "BookId not found"
        public static let BOOKID_NULL_EMPTY = "BookId null or empty"
        public static let WIDTH_OBJECT_NOT_FOUND = "Width object not found"
        public static let WIDTH_IS_ZERO = "Width value is zero(0)"
    }
    
    
}


