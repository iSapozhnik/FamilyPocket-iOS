//
//  WatchSessionManager.swift
//  FamilyPocket
//
//  Created by Ivan Sapozhnik on 5/24/17.
//  Copyright © 2017 Ivan Sapozhnik. All rights reserved.
//

import Foundation

import WatchConnectivity

class WatchSessionManager: NSObject, WCSessionDelegate {
    
    static let sharedManager = WatchSessionManager()
    private override init() {
        super.init()
    }
    
    private let session: WCSession? = WCSession.isSupported() ? WCSession.default() : nil
    
    fileprivate var validSession: WCSession? {
        
        // paired - the user has to have their device paired to the watch
        // watchAppInstalled - the user must have your watch app installed
        
        // Note: if the device is paired, but your watch app is not installed
        // consider prompting the user to install it for a better experience
        
        if let session = session, session.isPaired && session.isWatchAppInstalled {
            return session
        }
        return nil
    }
    
    func startSession() {
        session?.delegate = self
        session?.activate()
    }
    
//    public func updateApplicationContext(applicationContext: [String : Any]) throws {
//        if let session = validSession {
//            do {
//                try session.updateApplicationContext(applicationContext)
//            } catch let error {
//                throw error
//            }
//        }
//    }
    
    //MARK: delegate
    
    @available(iOS 9.3, *)
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidCompleteWith state \(activationState.rawValue)")
    }
    
    public func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    public func sessionDidDeactivate(_ session: WCSession) {
        
    }
}


// MARK: Application Context
// use when your app needs only the latest information
// if the data was not sent, it will be replaced
extension WatchSessionManager {
    
    // This is where the magic happens!
    // Yes, that's it!
    // Just updateApplicationContext on the session!
    func updateApplicationContext(applicationContext: [String : Any]) throws {
        if let session = validSession {
            do {
                try session.updateApplicationContext(applicationContext)
            } catch let error {
                throw error
            }
        }
    }
}
