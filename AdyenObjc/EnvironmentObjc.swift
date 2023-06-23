import Foundation
import Adyen

@objc
public final class EnvironmentObjc: NSObject {
    
    internal let environment: Environment
    
    private init(environment: Environment) {
        self.environment = environment
    }
    
    public static let test = EnvironmentObjc(environment: Environment.test)
    
    // TODO: Add other environments
}
