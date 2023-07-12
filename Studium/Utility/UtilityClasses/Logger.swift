//
//  Logger.swift
//  Studium
//
//  Created by Vikram Singh on 6/10/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import FirebaseCrashlytics

/// Enum which maps an appropiate symbol which added as prefix for each log message
///
/// - error: Log type error
/// - info: Log type info
/// - debug: Log type debug
/// - verbose: Log type verbose
/// - warning: Log type warning
/// - severe: Log type severe
enum LogEvent: String {
    case e = "$ ERR [‼️]: " // error
    case g = "$ SUCCESS [✅]:" // info
    case d = "$ DEB [💬]: " // debug
    case v = "$ VER [🔬]: " // verbose
    case w = "$ WAR [⚠️]: " // warning
    case s = "$ SEVERE [🔥]: " // severe
}


/// Wrapping Swift.print() within DEBUG flag
///
/// - Note: *print()* might cause [security vulnerabilities](https://codifiedsecurity.com/mobile-app-security-testing-checklist-ios/)
///
/// - Parameter object: The object which is to be logged
///
func print(_ object: Any) {
    // Only allowing in DEBUG mode
    #if DEBUG
        Swift.print(object)
    #endif
}

class Log {
    static var dateFormat = "yyyy-MM-dd hh:mm:ssSSS"
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    private static var isLoggingEnabled: Bool {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }
    
    // MARK: - Logging methods
    
    /// Logs error messages on console with prefix [‼️]. Do not use for unintentional events (use Log.s). This function does not present anything to the user.
    ///
    /// - Parameters:
    ///   - object: Object or message to be logged
    ///   - filename: File name from where loggin to be done
    ///   - line: Line number in file from where the logging is done
    ///   - column: Column number of the log message
    ///   - funcName: Name of the function from where the logging is done
    class func e( _ object: Any, additionalDetails: String = "", logToCrashlytics: Bool = false, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        if isLoggingEnabled {
            print("\(LogEvent.e.rawValue) \(Date().toString()) [\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) -> \(object). Additional Details: \(additionalDetails)")
        }
        
        if logToCrashlytics {
            CrashlyticsService.shared.log("\(object). Additional Details: \(additionalDetails)")
        }
    }
    
    /// Logs success messages on console with prefix [✅]
    ///
    /// - Parameters:
    ///   - object: Object or message to be logged
    ///   - filename: File name from where loggin to be done
    ///   - line: Line number in file from where the logging is done
    ///   - column: Column number of the log message
    ///   - funcName: Name of the function from where the logging is done
    class func g ( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        if isLoggingEnabled {
            print("\(LogEvent.g.rawValue) \(Date().toString()) [\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) -> \(object)")
        }
    }
    
    /// Logs debug messages on console with prefix [💬]
    ///
    /// - Parameters:
    ///   - object: Object or message to be logged
    ///   - filename: File name from where loggin to be done
    ///   - line: Line number in file from where the logging is done
    ///   - column: Column number of the log message
    ///   - funcName: Name of the function from where the logging is done
    class func d( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        if isLoggingEnabled
        {
            print("\(LogEvent.d.rawValue) \(Date().toString()) [\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) -> \(object)")
        }
    }
    
    /// Logs messages verbosely on console with prefix [🔬]
    ///
    /// - Parameters:
    ///   - object: Object or message to be logged
    ///   - filename: File name from where loggin to be done
    ///   - line: Line number in file from where the logging is done
    ///   - column: Column number of the log message
    ///   - funcName: Name of the function from where the logging is done
    class func v( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        if isLoggingEnabled {
            print("\(LogEvent.v.rawValue) \(Date().toString()) [\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) -> \(object)")
        }
    }
    
    /// Logs warnings verbosely on console with prefix [⚠️]
    ///
    /// - Parameters:
    ///   - object: Object or message to be logged
    ///   - filename: File name from where loggin to be done
    ///   - line: Line number in file from where the logging is done
    ///   - column: Column number of the log message
    ///   - funcName: Name of the function from where the logging is done
    class func w( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        if isLoggingEnabled {
            print("\(LogEvent.w.rawValue) \(Date().toString()) [\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) -> \(object)")
        }
    }
    
    /// Logs severe events on console with prefix [🔥]. Severe events are UNINTENTIONAL events. A connection issue would not be severe. This functional also presents a toast to the user to display the error
    ///
    /// - Parameters:
    ///   - object: Object or message to be logged
    ///   - filename: File name from where loggin to be done
    ///   - line: Line number in file from where the logging is done
    ///   - column: Column number of the log message
    ///   - funcName: Name of the function from where the logging is done
    class func s( _ error: Error, additionalDetails: String, displayToUser: Bool = true, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        
        // If logging is enabled, log the error to the console
        if isLoggingEnabled {
            print("\(LogEvent.s.rawValue) \(Date().toString()) [\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) -> \(error). Additional Details: \(additionalDetails)")
        }
        
        // If in developer mode, invoke a fatal error, otherwise, report to Crashlytics
        if DebugFlags.developerMode {
            fatalError(String(describing: error))
        } else {
            // Severe Issues should be reported to crashlytics.
            CrashlyticsService.shared.recordError(error, additionalDetails: additionalDetails)
        }
        
        // Show a toast stating that we ran into an error
        PopUpService.shared.presentToast(title: "Whoops! We ran into an Error.", description: "Please restart the app to try again.", popUpType: .failure)
    }
    
     
    /// Extract the file name from the file path
    ///
    /// - Parameter filePath: Full file path in bundle
    /// - Returns: File Name with extension
    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
}

internal extension Date {
    func toString() -> String {
        return Log.dateFormatter.string(from: self as Date)
    }
}
