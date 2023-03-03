//
//  BaseClass.swift
//  TapppPanelLibrary
//
//  Created by MA-15 on 01/03/23.
//
import Foundation
import UIKit

import Sentry
//import Amplify
//import AWSPluginsCore
//import AmplifyPlugins


public protocol updateOverlayViewFrame{
    func updateOverlayFrame(value : String)
}

public class BaseClass: NSObject {
    
    var frameUnit = ""
    var objectPanelData = [String: Any]()
    public var delegateFrame: updateOverlayViewFrame?

    public func testFunction(){
        
    }
    
    /*func configureAmplify() {
        do {
            try Amplify.add(plugin: AWSAPIPlugin())
            try Amplify.configure()
            print("Amplify configured 🥳")
        } catch {
            print("Failed to configure Amplify", error)
        }
    }*/

     public func configureSentry(){
         SentrySDK.start { options in
             options.dsn = "https://a638edd3fe44489a86353e40ed587b66@o4504648544026624.ingest.sentry.io/4504653998981120"
             options.debug = true // Enabled debug when first installing is always helpful

             // Enable all experimental features
             options.enablePreWarmedAppStartTracing = true
             options.attachScreenshot = true
             options.attachViewHierarchy = true
             if #available(iOS 15.0, *) {
                 options.enableMetricKit = true
             } else {
                 // Fallback on earlier versions
             }
             options.enableAutoBreadcrumbTracking = false
             options.enableNetworkTracking = false
             options.enableNetworkBreadcrumbs = false
         }
     }
    
    // Data validation.
    public func checkNilInputParam(panelData: [String: Any]?, currView: UIView?) -> Bool {
        if currView == nil {
            return false
        }
        if panelData == nil {
            return false
        }
        return true
    }
    
    public func checkPanelDataParam(panelData: [String: Any]?, currView: UIView?)-> ValidationState {
        var internalPaneldata = [String : Any]()
        
        if let pData = panelData?[TapppContext.Request.GAME_INFO] as? [String: Any] {
            internalPaneldata = pData
        } else {
            return .invalid(TapppContext.errorMessage.GAMEINFO_OBJECT_NOT_FOUND)
        }
        
        if let gId = internalPaneldata[TapppContext.Sports.GAME_ID] as? String{
            if gId.count > 0 {
            } else {
                return .invalid(TapppContext.errorMessage.GAMEID_NULL_EMPTY)
            }
        } else {
            return .invalid(TapppContext.errorMessage.GAMEID_NOT_FOUND)
        }
        if let bId = internalPaneldata[TapppContext.Request.BOOK_ID] as? String{
            if bId.count > 0 {
            } else {
                self.exceptionHandleHTML(errMsg: TapppContext.errorMessage.BOOKID_NULL_EMPTY)
                internalPaneldata[TapppContext.Request.BOOK_ID] = "1000009"
            }
        } else {
            self.exceptionHandleHTML(errMsg: TapppContext.errorMessage.BOOKID_NOT_FOUND)
            internalPaneldata[TapppContext.Request.BOOK_ID] = "1000009"
        }
        
        //let val = "200"
        if let widthInfo = internalPaneldata[TapppContext.Request.WIDTH] as? [String: Any]{
            if let unit = widthInfo[TapppContext.Request.UNIT] as? String, unit.count > 0{
                frameUnit = unit
            } else {
                frameUnit = TapppContext.Request.UNIT_VAL
            }
            if let val = widthInfo[TapppContext.Request.VALUE] as? String, val.count > 0 {
                if "\(currView?.frame.width ?? 0)" != val {
                    delegateFrame?.updateOverlayFrame(value: val)
                }
                print("From reference app val", val)
            } else {
                var widthInfoUD = [String : Any]()
                widthInfoUD[TapppContext.Request.UNIT] = "px"
                widthInfoUD[TapppContext.Request.VALUE] = "\(currView?.frame.width ?? 0)"
                internalPaneldata[TapppContext.Request.WIDTH] = widthInfoUD
            }
        } else {
            var widthInfoUD = [String : Any]()
            widthInfoUD[TapppContext.Request.UNIT] = "px"
            widthInfoUD[TapppContext.Request.VALUE] = "\(currView?.frame.width ?? 0)"
            internalPaneldata[TapppContext.Request.WIDTH] = widthInfoUD
        }
        
        //        if "\(currView?.frame.width ?? 0)" != val {
        //            delegateFrame?.updateOverlayFrame(value: val)
        //        }


        objectPanelData[TapppContext.Request.GAME_INFO] = internalPaneldata
        return .valid
    }
    
    public func exceptionHandleHTML(errMsg: String){
        //FIXME: need to setup for duplicate width key.
    }

}

// MARK - GraphQL APIs.
extension BaseClass {
    
    /*public func getGameInfoAPI () {
        do {
            if #available(iOS 13.0, *) {
                Task {
                    let data = try await Amplify.API.query(request: .getGameInfo(bookId: "1000009", broadcastName: "NFL", gameId: "067d2ebf-5dbe-4281-bca7-7a2820784fc9"))
                    print("getGameInfoAPI \(data) .")
                }
            } else {
                // Fallback on earlier versions
            }
        } catch {
            print("Fetching images failed with error \(error)")
        }
    }
    /*
    public func callcommandSubscriptionAPI () {
        do {
            Task {//gameId : 067d2ebf-5dbe-4281-bca7-7a2820784fc9
                  /*commandSubscribe: {bookId: "1000009", command: "OPEN", gameId: "1444309", type: "panelCommand"}*/
                let data = try await Amplify.API.subscribe(request: .commandSubscribe(bookId: "1000009", gameId: "1444309"))
                print("callcommandSubscriptionAPI \(data) .")
                Task {
                    do {
                        for try await obj in data{
                            switch obj {
                            case .connection(let subscriptionConnectionState):
                                print("Subscription connect state is \(subscriptionConnectionState)")
                            case .data(let result):
                                switch result {
                                case .success(let createdTodo):
                                    print("Successfully got todo from subscription: \(createdTodo)")
                                case .failure(let error):
                                    print("Got failed result with \(error.errorDescription)")
                                }
                            }
                        }
                    }
                }
            }
        } catch {
            print("Fetching images failed with error \(error)")
        }
    }
    
    public func callMutationSendPanelCommandAPI (){
        do {
            Task {
                let data = try await Amplify.API.mutate(request: .mutationSendPanelCommand(bookId: "100009", gameId: "213123"))
                switch data {
                case .success(let todo):
                    print("Successfully created todo: \(todo)")
                case .failure(let error):
                    print("Got failed result with \(error.errorDescription)")
                }
                print("callMutationPlaceBetAPI \(data) .")
            }
        } catch {
            print("Fetching images failed with error \(error)")
        }
    }*/

}
extension GraphQLRequest {
    
    static func getGameInfo(bookId: String, broadcastName: String, gameId: String) -> GraphQLRequest<String> {
        
        let operationName = "getGameInfo"
        let query =
            """
            {
                getGameInfo(bookId: "\(bookId)", broadcasterName: "\(broadcastName)", gameId: "\(gameId)", lang: "english"){
                            code
                            message
                            requestURI
                            status
                            data {
                              broadcasterGameId
                              isGameLive
                              providerGameId
                              startDate
                            }
                }
            }
            """
        return GraphQLRequest<String>(
            document: query,
            variables: ["bookId": bookId],
            responseType: String.self,
            decodePath: operationName
        )
    }
    
    static func commandSubscribe(bookId: String, gameId: String) -> GraphQLRequest<String> {
        
        let operationName = "commandSubscribe"
        
        /*commandSubscribe: {bookId: "1000009", command: "OPEN", gameId: "1444309", type: "panelCommand"}*/
        
        let query =
            """
            subscription commandSubscription {
                commandSubscribe(bookId: "\(bookId)", gameId: "\(gameId)") {
                    bookId
                    command
                    gameId
                    type
                }
            }
            """
        return GraphQLRequest<String>(
            document: query,
            variables: [:],
            responseType: String.self,
            decodePath: operationName
        )
    }
    
    static func mutationSendPanelCommand(bookId: String, gameId: String)-> GraphQLRequest<String> {
        let operationName = "sendPanelCommand"
        let query =
            """
            mutation sendPanelCommand {
                sendPanelCommand(bookId: "\(bookId)", gameId: "\(gameId)", input: {command: "CLOSE_PANEL", type: "panelCommand"}) {
                    bookId
                    command
                    gameId
                    type
                }
            }
            """
        return GraphQLRequest<String>(
            document: query,
            variables: [:],
            responseType: String.self,
            decodePath: operationName
        )
    }*/
}


