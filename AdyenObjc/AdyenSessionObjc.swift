import Foundation
import Adyen
import AdyenSession

@objc
public final class AdyenSessionObjc: NSObject {
    
    internal let adyenSession: AdyenSession
    
    private init(adyenSession: AdyenSession) {
        self.adyenSession = adyenSession
    }
    
    @objc
    public static func create(
        configuration: AdyenSessionConfigurationObjc,
        delegate: AdyenSessionDelegateObjc,
        //presentationDelegate: NSObject,
        completion: @escaping (AdyenSessionObjc?, Error?) -> Void) {
            
            let delegateAdapter = AdyenSessionDelegateAdapter(adaptedDelegate: delegate)
            let presentationDelegateAdapter = PresentationDelegateAdapter()
            
            AdyenSession.initialize(with: configuration.adyenConfiguration, delegate: delegateAdapter, presentationDelegate: presentationDelegateAdapter) { result in
                switch result {
                case let .success(session):
                    completion(AdyenSessionObjc(adyenSession: session), nil)
                case let .failure(error):
                    completion(nil, error)
                }
            }
        }
}

@objc
public final class AdyenSessionConfigurationObjc: NSObject {
    
    @objc
    public let sessionID: String
    
    internal let adyenConfiguration: AdyenSession.Configuration
    
    @objc
    public init(sessionID: String, sessionData: String, context: AdyenContextObjc) {
        self.sessionID = sessionID
        self.adyenConfiguration = AdyenSession.Configuration(
            sessionIdentifier: sessionID,
            initialSessionData: sessionData,
            context: context.adyenContext)
    }
}

@objc
public protocol AdyenSessionDelegateObjc {

    func didComplete(resultCode: SessionPaymentResultCodeObjc)
    
    func didFail(error: Error)
}

@objc
public protocol PresentationDelegateObj {

    func present(component: AnyObject)
}

internal class AdyenSessionDelegateAdapter: AdyenSessionDelegate {
    
    private let adaptedDelegate: AdyenSessionDelegateObjc
    
    public init(adaptedDelegate: AdyenSessionDelegateObjc) {
        self.adaptedDelegate = adaptedDelegate
    }
    
    func didComplete(with resultCode: SessionPaymentResultCode, component: Adyen.Component, session: AdyenSession) {
        adaptedDelegate.didComplete(resultCode: SessionPaymentResultCodeObjc(resultCode: resultCode))
    }
    
    func didFail(with error: Error, from component: Adyen.Component, session: AdyenSession) {
        adaptedDelegate.didFail(error: error)
    }
}

internal class PresentationDelegateAdapter: PresentationDelegate {
    
    func present(component: PresentableComponent) {
        
    }
}
