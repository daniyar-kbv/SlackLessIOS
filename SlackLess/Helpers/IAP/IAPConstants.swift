//
//  IAPConstants.swift
//  IAPManager
//
//  Created by Sergey Zhuravel on 11/8/22.
//

import UIKit

public struct IAPConstants {
    
    /// Returns true if built for release.
    /// - Returns: true if built for release.
    public static var isRelease: Bool {
        return !Constants.IAP.isStoreKitConfigurationFileUsed
    }
    
    public static var isLocalValidateReceipt = true
    
    /// Returns the appropriate .storekit or plist configuration file to use for DEBUG and RELEASE builds.
    /// - Returns: Returns the name of the configuration file.
    public static func ConfigFile() -> String {
        if !Constants.IAP.isStoreKitConfigurationFileUsed {
            return "Configuration"
        } else {
            return "ProductsRelease"
        }
    }
    
    /// The file extension for the appropriate .storekit or plist configuration file to use for DEBUG and RELEASE builds.
    /// - Returns: Returns the name of the configuration file extension.
    public static func ConfigFileExt() -> String {
        if !Constants.IAP.isStoreKitConfigurationFileUsed {
            return "storekit"
        } else {
            return "plist"
        }
    }
    
    /// The appropriate certificate to use for DEBUG and RELEASE builds. Used in receipt validation.
    /// - Returns: Returns the appropriate certificate to use for DEBUG and RELEASE builds. Used in receipt validation.
    public static func Certificate() -> String {
        if !Constants.IAP.isStoreKitConfigurationFileUsed {
            return "StoreKitTestCertificate"  // This is issued by StoreKit for local testing
        } else {
            return "AppleIncRootCertificate"  // This is a Apple root certificate used when working in release with the real App Store
        }
    }
    
    /// The file extension for the Apple certificate.
    /// - Returns: Returns the file extension for the Apple certificate.
    public static func CertificateExt() -> String { "cer" }
}
