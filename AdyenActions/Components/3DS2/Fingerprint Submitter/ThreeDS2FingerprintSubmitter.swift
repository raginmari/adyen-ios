//
// Copyright (c) 2023 Adyen N.V.
//
// This file is open source and available under the MIT license. See the LICENSE file for more info.
//

@_spi(AdyenInternal) import Adyen
import AdyenNetworking
import Foundation

internal enum ThreeDS2FingerprintSubmitterError: Error {
    case underlyingError(Error)
}

internal protocol AnyThreeDS2FingerprintSubmitter {
    func submit(fingerprint: String,
                paymentData: String?,
                completionHandler: @escaping (Result<ThreeDSActionHandlerResult, ThreeDS2FingerprintSubmitterError>) -> Void)
}

internal final class ThreeDS2FingerprintSubmitter: AnyThreeDS2FingerprintSubmitter {
    
    private let apiClient: APIClientProtocol
    
    private let apiContext: APIContext

    internal init(apiContext: APIContext, apiClient: APIClientProtocol? = nil) {
        self.apiContext = apiContext
        self.apiClient = apiClient ?? APIClient(apiContext: apiContext)
    }

    internal func submit(fingerprint: String,
                         paymentData: String?,
                         completionHandler: @escaping (Result<ThreeDSActionHandlerResult, ThreeDS2FingerprintSubmitterError>) -> Void) {

        let request = Submit3DS2FingerprintRequest(clientKey: apiContext.clientKey,
                                                   fingerprint: fingerprint,
                                                   paymentData: paymentData)

        apiClient.perform(request, completionHandler: { [weak self] result in
            self?.handle(result, completionHandler: completionHandler)
        })
    }

    private func handle(_ result: Result<Submit3DS2FingerprintResponse, Swift.Error>,
                        completionHandler: (Result<ThreeDSActionHandlerResult, ThreeDS2FingerprintSubmitterError>) -> Void) {
        switch result {
        case let .success(response):
            completionHandler(.success(response.result))
        case let .failure(error):
            completionHandler(.failure(.underlyingError(error)))
        }
    }
}
