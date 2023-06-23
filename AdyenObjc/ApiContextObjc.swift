import Foundation
import Adyen

@objc
public final class ApiContextObjc: NSObject {
    
    internal let apiContext: APIContext
    
    init(environment: EnvironmentObjc, clientKey: String) {
        // Throws only if the given client key has an invalid format
        // TODO: Handle nil
        self.apiContext = try! APIContext(
            environment: environment.environment,
            clientKey: clientKey)
    }
}
