

@objc(HyperModule)
class HyperModule: RCTEventEmitter {

    let applePayPaymentHandler = ApplePayHandler()
    var paymentSheetViewController:UIViewController?
    public static var shared:HyperModule?
    
    override init() {
        super.init()
        HyperModule.shared = self
    }
        
   @objc
   override static func requiresMainQueueSetup() -> Bool {
       return true
   }

   @objc override func supportedEvents() -> [String] {
       return ["confirm"]
   }

   @objc func confirm(data: [String: Any]) {
       self.sendEvent(withName: "confirm", body: data)
   }
        
    @objc
    func sendMessageToNative(_ rnMessage: String) {
        print("This log is from swift: \(rnMessage)")
    }

    @objc
    func presentPaymentSheet(_ request: NSMutableDictionary, _ callBack: @escaping RCTResponseSenderBlock) -> Void {
        RNViewManager.sheetCallback = callBack
        request["type"] = "payment"
        request["appId"] = Bundle.main.bundleIdentifier ?? ""
        
        DispatchQueue.main.async {
            let rootView = RNViewManager.sharedInstance.viewForModule("hyperSwitch", initialProperties: ["props": request])
            rootView.backgroundColor = UIColor.clear
            self.paymentSheetViewController = UIViewController()
            self.paymentSheetViewController?.view = rootView
            self.paymentSheetViewController?.modalPresentationStyle = .overCurrentContext

            UIApplication.shared.delegate?.window??.rootViewController?.present(self.paymentSheetViewController!, animated: true, completion: nil)
        }
    }

    @objc
    func exitPaymentsheet(_ reactTag: NSNumber, _ rnMessage: String, _ reset: Bool) {
        DispatchQueue.main.async {
            if let view = RNViewManager.sharedInstance.rootView {
                let reactNativeVC: UIViewController? = view.reactViewController()
                reactNativeVC?.dismiss(animated: true, completion: nil)
                RNViewManager.sharedInstance.rootView = nil
            }
        }
        RNViewManager.sheetCallback?([rnMessage])
    }

    @objc
    func exitCardForm(_ rnMessage: String) {
//        exitPaymentsheet(rnMessage)
    }
        
    @objc
    func launchApplePay (_ rnMessage: String, _ rnCallback: @escaping RCTResponseSenderBlock) {
        applePayPaymentHandler.startPayment(rnMessage: rnMessage, rnCallback: rnCallback)
    }
}

