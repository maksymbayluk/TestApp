//
//  Reachability.swift
//  TestApp
//
//  Created by Максим Байлюк on 06.05.2024.
//

import Foundation
import SystemConfiguration


public class Reachability {
    
    static let shared = Reachability()
    
    private var networkReachability: SCNetworkReachability?
    
    private init() {
        networkReachability = createNetworkReachability()
    }
    
    private func createNetworkReachability() -> SCNetworkReachability? {
        var zeroAddress = sockaddr()
        zeroAddress.sa_len = UInt8(MemoryLayout<sockaddr>.size)
        zeroAddress.sa_family = sa_family_t(AF_INET)
        
        guard let reachability = SCNetworkReachabilityCreateWithAddress(nil, &zeroAddress) else {
            return nil
        }
        return reachability
    }
    
    func checkInternetConnection(completion: @escaping (Bool) -> Void) {
        guard let reachability = networkReachability else {
            completion(false)
            return
        }
        
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(reachability, &flags)
        
        let isConnected = flags.contains(.reachable)
        completion(isConnected)
    }
    
    func IsNetworkAvailable() {
        checkInternetConnection { isConnected in
            if isConnected {
                
            } else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "internetcheck"),
                                                object: nil)
            }
        }
    }
    
}
