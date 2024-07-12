

@objc(HyperModule)
class HyperModule: RCTEventEmitter {

    let applePayPaymentHandler = ApplePayHandler()
    var paymentSheetViewController:UIViewController?
    public static var shared:HyperModule?
    private var paymentSession: PaymentSession?
    
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
    func initPaymentSession(_ request: NSMutableDictionary, _ callBack: @escaping RCTResponseSenderBlock) {
        self.paymentSession = PaymentSession()
        paymentSession?.initPaymentSession(paymentIntentClientSecret: request["clientSecret"] as! String)
        
        var statusMap: [String: Any] = [:]
        statusMap["type_"] = ""
        statusMap["code"] = ""
        statusMap["message"] = "initPaymentSession successful"
        statusMap["status"] = "success"
        callBack([statusMap])
    }

    @objc
    func presentPaymentSheet(_ request: NSMutableDictionary, _ callBack: @escaping RCTResponseSenderBlock) {
        request["appId"] = Bundle.main.bundleIdentifier ?? ""
        
        RNViewManager.sheetCallback = callBack
        DispatchQueue.main.async {
            let rootView = RNViewManager.sharedInstance.viewForModule("hyperSwitch", initialProperties: ["props": request])
            rootView.backgroundColor = UIColor.clear
            self.paymentSheetViewController = UIViewController()
            self.paymentSheetViewController?.view = rootView
            self.paymentSheetViewController?.modalPresentationStyle = .overCurrentContext

            UIApplication.shared.delegate?.window??.rootViewController?.present(self.paymentSheetViewController!, animated: false, completion: nil)
        }
    }

    @objc
    func exitPaymentsheet(_ reactTag: NSNumber, _ rnMessage: String, _ reset: Bool) {
        DispatchQueue.main.async {
            if let view = RNViewManager.sharedInstance.rootView {
                let reactNativeVC: UIViewController? = view.reactViewController()
                reactNativeVC?.dismiss(animated: false, completion: nil)
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

