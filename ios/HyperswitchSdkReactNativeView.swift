

@objc(HyperModule)
class HyperModule: RCTEventEmitter {
    let applePayPaymentHandler = ApplePayHandler()
    var paymentSheetViewController: UIViewController?
    public static var shared: HyperModule?
    private var paymentSession: PaymentSession?
    private var paymentSessionHandler: PaymentSessionHandler?
    
    override init() {
        super.init()
        HyperModule.shared = self
    }
    
    //   @objc
    //   override static func requiresMainQueueSetup() -> Bool {
    //       return true
    //   }
    //
    //   @objc override func supportedEvents() -> [String] {
    //       return ["confirm"]
    //   }
    //
    //   @objc func confirm(data: [String: Any]) {
    //       self.sendEvent(withName: "confirm", body: data)
    //   }
    
    @objc
    func sendMessageToNative(_ rnMessage: String) {
        // TODO: depreceate this function if not required
        // NOTE: do we actually need sendMessageToNative?
        print("This log is from swift: \(rnMessage)")
    }
    
    @objc
    func initPaymentSession(_ request: NSMutableDictionary, _ callBack: @escaping RCTResponseSenderBlock) {
        // TODO: resolve doubts and remove comments
        // NOTE: Why do we actually need initPaymentSession? What are we initializing and what for?
        // doubt: we already do have the context of client-secret, pk, cbURL stored in rn-wrapper side
        guard let paymentIntentClientSecret = request["clientSecret"] as? String,
              let publishableKey = request["publishableKey"] as? String
        else {
            var statusMap: [String: Any] = [:]
            statusMap["type_"] = ""
            statusMap["code"] = ""
            statusMap["message"] = "initPaymentSession successful: clientSecret or publishableKey not found."
            statusMap["status"] = "error"
            callBack([statusMap])
            return
        }
        
        self.paymentSession = PaymentSession(publishableKey: publishableKey)
        paymentSession?.initPaymentSession(paymentIntentClientSecret: paymentIntentClientSecret)
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
            PaymentSession.isPresented = true
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
        // TODO: update in params required here!
        // NOTE: find the use-case where we need exitCardForm on RN side
        // NOTE: check for params availability: rootTag: int, reset: bool
        // NOTE: for now hardcoded the values
        exitPaymentsheet(0, rnMessage, false)
    }
    
    @objc
    func getCustomerSavedPaymentMethods(_ request: NSMutableDictionary, _ callBack: @escaping RCTResponseSenderBlock) {
        paymentSession?.getCustomerSavedPaymentMethods { handler in
            self.paymentSessionHandler = handler
            
            var statusMap: [String: Any] = [:]
            statusMap["type_"] = ""
            statusMap["code"] = ""
            statusMap["message"] = "getCustomerSavedPaymentMethods successful"
            statusMap["status"] = "success"
            
            callBack([statusMap])
        }
    }
    
    @objc
    func getCustomerDefaultSavedPaymentMethodData(_ request: NSMutableDictionary, _ callBack: @escaping RCTResponseSenderBlock) {
        let paymentMethod = self.paymentSessionHandler?.getCustomerDefaultSavedPaymentMethodData()
        
        var statusMap: [String: Any] = [:]
        switch paymentMethod {
        case let card as Card:
            statusMap["type"] = "card"
            statusMap["message"] = card.toHashMap()
        case let wallet as Wallet:
            statusMap["type"] = "wallet"
            statusMap["message"] = wallet.toHashMap()
        case let error as PMError:
            statusMap["type"] = "error"
            statusMap["message"] = "\(error.toHashMap())"
        default:
            statusMap["type"] = "error"
            statusMap["message"] = "No Payment Method Available"
        }
        
        callBack([statusMap])
    }
    
    @objc
    func getCustomerLastUsedPaymentMethodData(_ request: NSMutableDictionary, _ callBack: @escaping RCTResponseSenderBlock) {
        let paymentMethod = self.paymentSessionHandler?.getCustomerDefaultSavedPaymentMethodData()
        
        var statusMap: [String: Any] = [:]
        switch paymentMethod {
        case let card as Card:
            statusMap["type"] = "card"
            statusMap["message"] = card.toHashMap()
        case let wallet as Wallet:
            statusMap["type"] = "wallet"
            statusMap["message"] = wallet.toHashMap()
        case let error as PMError:
            statusMap["type"] = "error"
            statusMap["message"] = "\(error.toHashMap())"
        default:
            statusMap["type"] = "error"
            statusMap["message"] = "No Payment Method Available"
        }
        
        callBack([statusMap])
    }
    
    @objc
    func getCustomerSavedPaymentMethodData(_ request: NSMutableDictionary, _ callBack: @escaping RCTResponseSenderBlock) {
        let paymentMethod = self.paymentSessionHandler?.getCustomerSavedPaymentMethodData()
        
        guard let pm = paymentMethod else{
            var statusMap: [String: Any] = [:]
            statusMap["type"] = "error"
            statusMap["message"] = "No Payment Method Available"
            return
        }
        
        var pmList: [[String: Any]] = []
        for paymentMethods in pm{
            var pmMap: [String: Any] = [:]
            
            switch paymentMethods {
            case let card as Card:
                pmMap["type"] = "card"
                pmMap["message"] = card.toHashMap()
                pmList.append(pmMap)
            case let wallet as Wallet:
                pmMap["type"] = "wallet"
                pmMap["message"] = wallet.toHashMap()
                pmList.append(pmMap)
            case let error as PMError:
                pmMap["type"] = "error"
                pmMap["message"] = error.toHashMap()
                pmList.append(pmMap)
            default:
                pmMap["type"] = "error"
                pmMap["message"] = "unknown error"
                pmList.append(pmMap)
            }
        }
        
        var statusMap: [String: Any] = [:]
        statusMap["paymentMethods"] = pmList
        callBack([statusMap])
    }
    
    @objc
    func confirmWithCustomerDefaultPaymentMethod(_ request: NSMutableDictionary, _ cvc: String, _ callBack: @escaping RCTResponseSenderBlock) {
        func resultHandler(_ paymentResult: PaymentResult) {
            var statusMap: [String: Any] = [:]
            switch paymentResult {
            case .completed(let data):
                statusMap["type"] = "completed"
                statusMap["message"] = data
            case .canceled(let data):
                statusMap["type"] = "canceled"
                statusMap["message"] = data
            case .failed(let error as NSError):
                statusMap["type"] = "failed"
                statusMap["message"] = "\(error.userInfo["message"] ?? error)"     
            }
            callBack([statusMap])
        }
        
        paymentSessionHandler?.confirmWithCustomerDefaultPaymentMethod(cvc: cvc, resultHandler: resultHandler)
    }
    
    @objc
    func confirmWithCustomerLastUsedPaymentMethod(_ request: NSMutableDictionary, _ cvc: String, _ callBack: @escaping RCTResponseSenderBlock) {
        func resultHandler(_ paymentResult: PaymentResult) {
            var statusMap: [String: Any] = [:]
            switch paymentResult {
            case .completed(let data):
                statusMap["type"] = "completed"
                statusMap["message"] = data
            case .canceled(let data):
                statusMap["type"] = "canceled"
                statusMap["message"] = data
            case .failed(let error as NSError):
                statusMap["type"] = "failed"
                statusMap["message"] = "\(error.userInfo["message"] ?? error)"
            }
            callBack([statusMap])
        }
        
        paymentSessionHandler?.confirmWithCustomerLastUsedPaymentMethod(cvc: cvc, resultHandler: resultHandler)
    }
    
    @objc
    func confirmWithCustomerPaymentToken(_ request: NSMutableDictionary, _ cvc: String, _ paymentToken: String, _ callBack: @escaping RCTResponseSenderBlock) {
        func resultHandler(_ paymentResult: PaymentResult) {
            var statusMap: [String: Any] = [:]
            switch paymentResult {
            case .completed(let data):
                print(["type": "completed", "message": data])
                statusMap["type"] = "completed"
                statusMap["message"] = data
            case .canceled(let data):
                print(["type": "canceled", "message": data])
                statusMap["type"] = "canceled"
                statusMap["message"] = data
            case .failed(let error as NSError):
                print(["type": "failed", "message": "\(error)"])
                statusMap["type"] = "failed"
                statusMap["message"] = "\(error.userInfo["message"] ?? error)"
            }
            
            callBack([statusMap])
        }
        
        paymentSessionHandler?.confirmWithCustomerPaymentToken(paymentToken: paymentToken, cvc: cvc, resultHandler: resultHandler)
    }
    
    @objc
    func launchApplePay (_ rnMessage: String, _ rnCallback: @escaping RCTResponseSenderBlock) {
        applePayPaymentHandler.startPayment(rnMessage: rnMessage, rnCallback: rnCallback)
    }
}




public struct PaymentSessionHandler {
    public let getCustomerDefaultSavedPaymentMethodData: () -> PaymentMethod
    public let getCustomerLastUsedPaymentMethodData: () -> PaymentMethod
    public let getCustomerSavedPaymentMethodData: () -> [PaymentMethod]
    private let confirmWithCustomerDefaultPaymentMethod: (_ cvc: String?, _ resultHandler: @escaping (PaymentResult) -> Void) -> Void
    private let confirmWithCustomerLastUsedPaymentMethod: (_ cvc: String?, _ resultHandler: @escaping (PaymentResult) -> Void) -> Void
    private let confirmWithCustomerPaymentToken: (_ paymentToken: String, _ cvc: String?, _ resultHandler: @escaping (PaymentResult) -> Void) -> Void
    
    init(
        getCustomerDefaultSavedPaymentMethodData: @escaping () -> PaymentMethod,
        getCustomerLastUsedPaymentMethodData: @escaping () -> PaymentMethod,
        getCustomerSavedPaymentMethodData: @escaping () -> [PaymentMethod],
        confirmWithCustomerDefaultPaymentMethod: @escaping (_ cvc: String?, _ resultHandler: @escaping (PaymentResult) -> Void) -> Void,
        confirmWithCustomerLastUsedPaymentMethod: @escaping (_ cvc: String?, _ resultHandler: @escaping (PaymentResult) -> Void) -> Void,
        confirmWithCustomerPaymentToken: @escaping (_ paymentToken: String, _ cvc: String?, _ resultHandler: @escaping (PaymentResult) -> Void) -> Void
    ) {
        self.getCustomerDefaultSavedPaymentMethodData = getCustomerDefaultSavedPaymentMethodData
        self.getCustomerLastUsedPaymentMethodData = getCustomerLastUsedPaymentMethodData
        self.getCustomerSavedPaymentMethodData = getCustomerSavedPaymentMethodData
        self.confirmWithCustomerDefaultPaymentMethod = confirmWithCustomerDefaultPaymentMethod
        self.confirmWithCustomerLastUsedPaymentMethod = confirmWithCustomerLastUsedPaymentMethod
        self.confirmWithCustomerPaymentToken = confirmWithCustomerPaymentToken
    }
    
    public func confirmWithCustomerDefaultPaymentMethod(cvc: String?, resultHandler: @escaping (PaymentResult) -> Void) {
        confirmWithCustomerDefaultPaymentMethod(cvc, resultHandler)
    }
    
    public func confirmWithCustomerLastUsedPaymentMethod(cvc: String?, resultHandler: @escaping (PaymentResult) -> Void) {
        confirmWithCustomerLastUsedPaymentMethod(cvc, resultHandler)
    }
    
    public func confirmWithCustomerPaymentToken(paymentToken: String, cvc: String?, resultHandler: @escaping (PaymentResult) -> Void) {
        confirmWithCustomerPaymentToken(paymentToken, cvc, resultHandler)
    }
}
