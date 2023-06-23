import Foundation
import AdyenSession

@objc
public enum SessionPaymentResultCodeObjc: Int {
    /// Indicates the payment was successfully authorised.
    case authorised
    case refused
    case pending
    case cancelled
    case error
    case received
    case presentToShopper
    
    internal var wrapped: SessionPaymentResultCode {
        switch self {
        case .authorised:
            return .authorised
        default:
            fatalError("Map missing cases")
        }
    }
    
    internal init(resultCode: SessionPaymentResultCode) {
        switch resultCode {
        case .authorised:
            self = .authorised
        default:
            fatalError("Map missing cases")
        }
    }
}
