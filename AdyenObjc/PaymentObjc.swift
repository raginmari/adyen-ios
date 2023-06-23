import Foundation
import Adyen

@objc
public final class PaymentObjc: NSObject {
    
    internal let payment: Payment
    
    public init(value: Int, currencyCode: String, countryCode: String) {
        self.payment = Payment(
            amount: Amount(value: value, currencyCode: currencyCode),
            countryCode: countryCode)
    }
}
