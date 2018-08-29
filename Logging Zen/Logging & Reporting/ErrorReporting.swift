import Foundation

/// Protocol to ease generating logging messages. This is useful if you don't want to continue using your existing `CustomStringConvertible` or `CustomDebugStringConvertible` values for logs.
public protocol ErrorReporting {
    /// A textual representation of an error that can be safely posted to a log.
    var loggingDescription: String { get }
}

extension ErrorReporting where Self: Error {
    public var loggingDescription: String {
        guard let _nserror = self as? CustomNSError else { return localizedDescription }
        
        let desc = _nserror.errorUserInfo[NSDebugDescriptionErrorKey] as? String ?? localizedDescription
        let domain = type(of: _nserror).errorDomain
        let code = _nserror.errorCode
        
        return "{ \(desc). domain: \(domain). code: \(code) }"
    }
}

extension NSError: ErrorReporting {
    public var loggingDescription: String {
        let desc = self.userInfo[NSDebugDescriptionErrorKey] as? String ?? localizedDescription
        
        return "{ \(desc). domain: \(domain). code: \(code) }"
    }
}
