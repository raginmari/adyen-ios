//
// Copyright (c) 2021 Adyen N.V.
//
// This file is open source and available under the MIT license. See the LICENSE file for more info.
//

import Foundation

/// :nodoc:
/// An API Client that fetches an asset only once.
public final class UniqueAssetAPIClient<ResponseType: Response> {

    /// :nodoc:
    public typealias CompletionHandler<T> = (Result<T, Error>) -> Void

    /// :nodoc:
    private let apiClient: APIClientProtocol

    /// :nodoc:
    private var waitingList: [(Result<ResponseType, Error>) -> Void] = []

    /// :nodoc:
    private var cachedResponse: ResponseType?

    /// :nodoc:
    /// Initializes the API client.
    ///
    /// - Parameters:
    ///   - apiClient: The wrapped API client.
    public init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    /// :nodoc:
    public func perform<R>(_ request: R, completionHandler: @escaping CompletionHandler<R.ResponseType>) where R: Request, R.ResponseType == ResponseType {
        waitingList.append(completionHandler)
        if let cachedResponse = cachedResponse {
            deliver(.success(cachedResponse))
            return
        }

        guard waitingList.count == 1 else { return }
        apiClient.perform(request) { [weak self] result in
            self?.handle(result)
        }
    }

    private func handle(_ result: Result<ResponseType, Swift.Error>) {
        switch result {
        case let .success(response):
            cachedResponse = response
            deliver(.success(response))
        case let .failure(error):
            deliver(.failure(error))
        }
    }

    private func deliver(_ result: Result<ResponseType, Swift.Error>) {
        waitingList.forEach {
            $0(result)
        }
        waitingList = []
    }
}
