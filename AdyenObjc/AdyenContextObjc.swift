import Foundation
import Adyen

@objc
public final class AdyenContextObjc: NSObject {
    
    internal let adyenContext: AdyenContext
    
    public init(apiContext: ApiContextObjc, payment: PaymentObjc) {
        self.adyenContext = AdyenContext(
            apiContext: apiContext.apiContext,
            payment: payment.payment)
    }
}
