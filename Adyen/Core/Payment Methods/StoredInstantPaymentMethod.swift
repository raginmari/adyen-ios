//
// Copyright (c) 2021 Adyen N.V.
//
// This file is open source and available under the MIT license. See the LICENSE file for more info.
//

import Foundation


public struct StoredInstantPaymentMethod: StoredPaymentMethod {

    public let type: String

    public let name: String

    public let identifier: String

    /// :nodoc:
    public let supportedShopperInteractions: [ShopperInteraction]
    
    /// :nodoc:
    public func buildComponent(using builder: PaymentComponentBuilder) -> PaymentComponent? {
        builder.build(paymentMethod: self)
    }
    
    // MARK: - Decoding
    
    private enum CodingKeys: String, CodingKey {
        case type
        case name
        case identifier = "id"
        case supportedShopperInteractions
    }
    
}
