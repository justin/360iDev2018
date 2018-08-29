import Foundation
import os.log

/// Logging configuration and categories that are unique to the current application.
public struct Logging {
    /// Typealias to String for defining the subsystem.
    public typealias Subsystem = String
    
    /// The logging categories supported by the different app subsystems.
    ///
    /// - default: This is the catch-all for anything that doesn't match another category.
    /// - database: Logging related to working with database and models.
    /// - networking: Logging related to API calls and other various network requests.
    /// - operations: Logging related to `Operation` tasks and similar work.
    /// - playback: Logging related to media playback.
    /// - reporting: Logging related to error reporting or analytics.
    /// - ui: Logging related to the the user interface.
    public enum Category: String {
        case `default`
        case database
        case networking
        case operations
        case playback
        case reporting
        case ui
    }
    
    /// Factory to generate a new OSLog instance using our predefined set of categories.
    ///
    /// - Parameters:
    ///   - subsystem: The subsystem you want to log to.
    ///   - category: The `Category` you want to log to.
    /// - Returns: The log object itself.
    public static func makeLog(subsystem: Subsystem = .default, category: Category) -> OSLog {
        return OSLog(subsystem: subsystem, category: category)
    }
}

extension Logging.Subsystem {
    /// Convenience accessor for the setting the subystem to the main app's bundle identifier.
    public static var `default` = Bundle.main.bundleIdentifier ?? ""
}


public extension OSLog {
    /// Initialize a new OSLog instance using the parent application bundle identifier and a custom category.
    ///
    /// - Parameter subsystem: The subsystem for your logging instance.
    /// - Parameter category: The category for your logging instance.
    public convenience init(subsystem: Logging.Subsystem = .default, category: Logging.Category = .default) {
        self.init(subsystem: subsystem, category: category.rawValue)
    }
}
