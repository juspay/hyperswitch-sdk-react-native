import Foundation
import WebKit

@objc(HyperHeadless)
internal class HyperHeadless: RCTEventEmitter {
    
    @objc
    private func initialisePaymentSession (_ rnCallback: @escaping RCTResponseSenderBlock) {
        DispatchQueue.main.async {
            if PaymentSession.headlessCompletion != nil, !PaymentSession.isPresented {
                let hyperParams = [
                    "appId": Bundle.main.bundleIdentifier,
                    "sdkVersion" : "0.1.2",
                    "ip": nil,
                    "user-agent": WKWebView().value(forKey: "userAgent"),
                    "launchTime": Int(Date().timeIntervalSince1970 * 1000)
                ]
                
                let props: [String: Any] = [
                    "clientSecret": PaymentSession.paymentIntentClientSecret as Any,
                    "publishableKey": PaymentSession.publishableKey as Any,
                    "customBackendUrl": PaymentSession.customBackendUrl as Any,
                    "hyperParams": hyperParams,
                ]
                rnCallback([props])
            }
        }
    }
    
    @objc
    private func getPaymentSession(_ rnMessage: NSDictionary, _ rnMessage2: NSDictionary, _ rnMessage3: NSArray, _ rnCallback: @escaping RCTResponseSenderBlock) {
        PaymentSession.getPaymentSession(getPaymentMethodData: rnMessage, getPaymentMethodData2: rnMessage2, getPaymentMethodDataArray: rnMessage3, callback: rnCallback)
    }
    
    @objc
    private func exitHeadless(_ rnMessage: String) {
        PaymentSession.exitHeadless(rnMessage: rnMessage)
    }
}
