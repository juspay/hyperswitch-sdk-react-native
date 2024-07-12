public class PaymentSession {
    internal static var paymentIntentClientSecret: String?
    
    public func initPaymentSession(paymentIntentClientSecret: String) {
        PaymentSession.paymentIntentClientSecret = paymentIntentClientSecret
    }
}
