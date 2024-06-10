//
//  RNViewManager.swift
//  hyperswitch
//
//  Created by Shivam Shashank on 09/11/22.
//

import Foundation
import React

protocol RNResponseHandler {
    func didReceiveResponse(response: String?, error: Error?) -> Void
}

//extension RCTBridge: RCTReloadListener {
//    
//    func triggerReload (bridge: RCTBridge!) {
//        NotificationCenter.default.post(name: NSNotification.Name.RCTBridgeWillReload, object: bridge, userInfo: nil)
//
//        DispatchQueue.main.async {
//            bridge.invalidate()
//            bridge.setUp()
//        }
//    }
//    
//    public func didReceiveReloadCommand() {
//        
//        let preferences = UserDefaults.standard
//        let pendingUpdate = preferences.object(forKey: "CODE_PUSH_PENDING_UPDATE") as? [String: Any]
//        let updateIsLoading = pendingUpdate?["isLoading"] as? Bool
//                
//        if(!(updateIsLoading ?? true) && RNViewManager.sharedInstance.rootView != nil) {
//            if (self === RNViewManager.sharedInstance.bridge) {
//                triggerReload(bridge: self)
//            }
//        } else {
//            if(RNViewManager.sharedInstance.rootView != nil) {
//                if (self === RNViewManager.sharedInstance.bridge) {
//                    return
//                }
//            }
//            triggerReload(bridge: self)
//        }
//    }
//}
//
//extension CodePush {
//    @objc private class func clearUpdates() {
//        let preferences = UserDefaults.standard
//        preferences.removeObject(forKey: "CODE_PUSH_PENDING_UPDATE")
//        preferences.removeObject(forKey: "CODE_PUSH_FAILED_UPDATES")
//        preferences.synchronize()
//    }
//}


class RNViewManager: NSObject {
    
    var rootView: RCTRootView?
    static var sheetCallback: RCTResponseSenderBlock?

    lazy var bridge: RCTBridge = {
        RCTBridge.init(delegate: self, launchOptions: nil)
    }()
    
    static let sharedInstance = RNViewManager()
    static let sharedInstance2 = RNViewManager()
    
    func viewForModule(_ moduleName: String, initialProperties: [String : Any]?) -> RCTRootView {
        let rootView: RCTRootView = RCTRootView(
            bridge: bridge,
            moduleName: moduleName,
            initialProperties: initialProperties)
        self.rootView = rootView
        return rootView
    }
    
    func reinvalidateBridge(){
        self.bridge.invalidate()
        self.bridge = RCTBridge.init(delegate: self, launchOptions: nil)
    }
}

extension RNViewManager: RCTBridgeDelegate {
    func sourceURL(for bridge: RCTBridge!) -> URL! {
//        let plistPath = Bundle(for: RNViewManager.self).path(forResource: "Codepush", ofType: "plist")!
//        let plistData = try! Data(contentsOf: URL(fileURLWithPath: plistPath))
//        let plistDictionary = try! PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as! [String: String]

//        CodePush.overrideAppVersion(plistDictionary["HyperVersion"])
//        CodePush.setDeploymentKey(plistDictionary["CodePushDeploymentKey"])
        
//        return Bundle.main.url(forResource: "hyperswitch", withExtension: "bundle")
//        return RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: "index")
//        return URL(string: "http://localhost:8082/index.bundle?platform=ios")
        return CodePush.bundleURL(
            forResource: "hyperswitch",
            withExtension: "bundle"
        )
    }
}

