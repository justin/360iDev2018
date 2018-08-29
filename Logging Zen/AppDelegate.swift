import Cocoa
import os.log

struct Log {
    static let `default` = Logging.makeLog(category: .default)
    static let networking = Logging.makeLog(category: .networking)
}

struct Account {
    let email: String
    let password: String
}

enum TestError: Error, ErrorReporting {
    case failure(code: Int)
    
    var loggingDescription: String {
        switch self {
        case .failure(let code):
            return "{ code: \(code) }"
        }
        
    }
}

@NSApplicationMain
final class AppDelegate: NSObject, NSApplicationDelegate {
    private let launchDate = Date()
    
    @IBOutlet weak var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        os_log("This is a default message with no subsystem.")
        
        os_log("Debug Level", log: Log.default, type: .debug)
        os_log("Info Level", log: Log.default, type: .info)
        os_log("Default Level", log: Log.default, type: .default)
        os_log("Fault Level", log: Log.default, type: .fault)
        os_log("Error Level", log: Log.default, type: .error)
        
        let log = OSLog(subsystem: "JWWSubsystem", category: "Cats")
        os_log("Cats, cats, cat!", log: log)
        
        // Private vs Public
        let account = Account(email: "justinw@me.com", password: "1ns3cure")
        let accountID = Int.random(in: 1..<5000)
        os_log("Account ID = %{private}i", accountID)
        os_log("User signed in. Email: %{public}@. Password: %@", log: Log.default, account.email, account.password)
        
        // Custom Formatters
        
        os_log("Launched at %{time_t}d", log: Log.default, time_t(launchDate.timeIntervalSince1970))
        let isASuperGenius = Bool.random()
        os_log("Are you a super genius? %@", log: Log.default, isASuperGenius ? "YES" : "NO")
        os_log("Are you a super genius? %{BOOL}d", log: Log.default, isASuperGenius)
        os_log("Are you a super genius? %{bool}d", log: Log.default, isASuperGenius)
        
        os_log("Downloading at %{bitrate}d", log: Log.default, 1500)
        
        let userInfo: [String: Any] = [
            NSLocalizedDescriptionKey: "Error Description",
            NSLocalizedFailureReasonErrorKey: "Error Failure Reason",
            NSURLErrorFailingURLErrorKey: URL(string: "https://justinw.me")!,
            NSDebugDescriptionErrorKey: "Error Debug Description"
        ]
        let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorTimedOut, userInfo: userInfo)
        os_log("Request couldn't be completed. %{public}@", log: Log.default, error.loggingDescription)
        
        let failure = TestError.failure(code: 300)
        os_log("Test error failed. %{public}@", log: Log.default, failure.loggingDescription)
        
        // If only these worked for my Error types!
        os_log("Error %{errno}d", log: Log.default, POSIXError.Code.EADDRNOTAVAIL.rawValue)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        os_log("Terminating...I'll be back.", log: Log.default)
    }
}
