import Foundation

public protocol PaymentMethod {
    var isDefaultPaymentMethod: Bool { get }
    var paymentToken: String { get }
    var created: String { get }
    var lastUsedAt: String { get }
    func toHashMap() -> [String: Any]
}

public struct Card: PaymentMethod{
    public let isDefaultPaymentMethod: Bool
    public let paymentToken: String
    public let cardScheme: String
    public let name: String
    public let expiryDate: String
    public let cardNumber: String
    public let nickName: String
    public let cardHolderName: String
    public let requiresCVV: Bool
    public let created: String
    public let lastUsedAt: String
    
    public func toHashMap() -> [String: Any] {
        return [
            "isDefaultPaymentMethod": isDefaultPaymentMethod,
            "paymentToken": paymentToken,
            "cardScheme": cardScheme,
            "name": name,
            "expiryDate": expiryDate,
            "cardNumber": cardNumber,
            "nickName": nickName,
            "cardHolderName": cardHolderName,
            "requiresCVV": requiresCVV,
            "created": created,
            "lastUsedAt": lastUsedAt
        ]
    }
}

public struct Wallet: PaymentMethod {
    public let isDefaultPaymentMethod: Bool
    public let paymentToken: String
    public let walletType: String
    public let created: String
    public let lastUsedAt: String
    
    public func toHashMap() -> [String: Any] {
        return [
            "isDefaultPaymentMethod": isDefaultPaymentMethod,
            "paymentToken": paymentToken,
            "walletType": walletType,
            "created": created,
            "lastUsedAt": lastUsedAt
        ]
    }
}

public struct PMError: PaymentMethod {
    public let isDefaultPaymentMethod: Bool = false
    public let paymentToken: String = ""
    public let created: String = ""
    public let lastUsedAt: String = ""
    public let code: String
    public let message: String
    
    public func toHashMap() -> [String: Any] {
        return [
            "code": code,
            "message": message,
            "isDefaultPaymentMethod": isDefaultPaymentMethod,
            "paymentToken": paymentToken,
            "created": created,
            "lastUsedAt": lastUsedAt
        ]
    }
}
