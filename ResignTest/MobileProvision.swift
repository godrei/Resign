//
//  MobileProvision.swift
//  ResignTest
//
//  Created by Krisztián Gödrei on 15/02/2024.
//

import Foundation

/* Decode mobileprovision plist file

 Usage:
 
 1. To get mobileprovision data as embedded in your app:

 MobileProvision.read()

 2. To get mobile provision data from a file on disk:
 
 MobileProvision.read(from: "my.mobileprovision")
 
*/

struct MobileProvision: Decodable {
    var name: String
    var appIDName: String
    var platform: [String]
    var isXcodeManaged: Bool? = false
    var creationDate: Date
    var expirationDate: Date
    var entitlements: Entitlements
    var provisionedDevices: [String]
    var provisionsAllDevices: Bool? = false
    
    private enum CodingKeys : String, CodingKey {
        case name = "Name"
        case appIDName = "AppIDName"
        case platform = "Platform"
        case isXcodeManaged = "IsXcodeManaged"
        case creationDate = "CreationDate"
        case expirationDate = "ExpirationDate"
        case entitlements = "Entitlements"
        case provisionedDevices = "ProvisionedDevices"
        case provisionsAllDevices = "ProvisionsAllDevices"
    }
    
    // Sublevel: decode entitlements informations
    struct Entitlements: Decodable {
        let keychainAccessGroups: [String]
        let getTaskAllow: Bool
        let apsEnvironment: Environment
        let applicationIdentifier: String?
        let comAppleApplicationIdentifier: String?
        
        private enum CodingKeys: String, CodingKey {
            case keychainAccessGroups = "keychain-access-groups"
            case getTaskAllow = "get-task-allow"
            case apsEnvironment = "aps-environment"
            case applicationIdentifier = "application-identifier"
            case comAppleApplicationIdentifier = "com.apple.application-identifier"
        }
        
        enum Environment: String, Decodable {
            case development, production, disabled
        }
        
        init(keychainAccessGroups: Array<String>, getTaskAllow: Bool, apsEnvironment: Environment, applicationIdentifier: String?, comAppleApplicationIdentifier: String?) {
            self.keychainAccessGroups = keychainAccessGroups
            self.getTaskAllow = getTaskAllow
            self.apsEnvironment = apsEnvironment
            self.applicationIdentifier = applicationIdentifier
            self.comAppleApplicationIdentifier = comAppleApplicationIdentifier
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let keychainAccessGroups: [String] = (try? container.decode([String].self, forKey: .keychainAccessGroups)) ?? []
            let getTaskAllow: Bool = (try? container.decode(Bool.self, forKey: .getTaskAllow)) ?? false
            let apsEnvironment: Environment = (try? container.decode(Environment.self, forKey: .apsEnvironment)) ?? .disabled
            let applicationIdentifier: String? = (try? container.decode(String.self, forKey: .applicationIdentifier)) ?? nil
            let comAppleApplicationIdentifier: String? = (try? container.decode(String.self, forKey: .comAppleApplicationIdentifier)) ?? nil
            
            self.init(keychainAccessGroups: keychainAccessGroups, getTaskAllow: getTaskAllow, apsEnvironment: apsEnvironment, applicationIdentifier: applicationIdentifier, comAppleApplicationIdentifier: comAppleApplicationIdentifier)
        }
    }
}

// Factory methods
extension MobileProvision {
    // Read mobileprovision file embedded in app.
    static func read() -> MobileProvision? {
        let profilePath: String? = Bundle.main.path(forResource: "embedded", ofType: "mobileprovision")
        guard let path = profilePath else { return nil }
        return read(from: path)
    }

    // Read a .mobileprovision file on disk
    static func read(from profilePath: String) -> MobileProvision? {
        guard let plistDataString = try? NSString.init(contentsOfFile: profilePath,
                                                       encoding: String.Encoding.isoLatin1.rawValue) else { return nil }
                
        // Skip binary part at the start of the mobile provisionning profile
        let scanner = Scanner(string: plistDataString as String)
        guard scanner.scanUpTo("<plist", into: nil) != false else { return nil }
        
        // ... and extract plist until end of plist payload (skip the end binary part.
        var extractedPlist: NSString?
        guard scanner.scanUpTo("</plist>", into: &extractedPlist) != false else { return nil }
        
        guard let plist = extractedPlist?.appending("</plist>").data(using: .isoLatin1) else { return nil }
        let decoder = PropertyListDecoder()
        do {
            let provision = try decoder.decode(MobileProvision.self, from: plist)
            return provision
        } catch {
            // TODO: log / handle error
            return nil
        }
    }
    
    func distributionType() -> String {
        if !provisionedDevices.isEmpty && !(provisionsAllDevices ?? false) && entitlements.getTaskAllow {
            return "development"
        } else if !provisionedDevices.isEmpty && !(provisionsAllDevices ?? false) && entitlements.getTaskAllow {
            return "ad-hoc"
        } else if provisionedDevices.isEmpty && (provisionsAllDevices ?? false) && !entitlements.getTaskAllow {
            return "enterprise"
        } else if provisionedDevices.isEmpty && !(provisionsAllDevices ?? false) && !entitlements.getTaskAllow {
            return "app-store"
        } else {
            return ""
        }
    }
    
    func appID() -> String {
        if let appID = entitlements.applicationIdentifier {
            return appID
        }
        if let appID = entitlements.comAppleApplicationIdentifier {
            return appID
        }
        return ""
    }
}
