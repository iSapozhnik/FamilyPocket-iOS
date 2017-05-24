//
//  WatchSessionMAnager.swift
//  FamilyPocket
//
//  Created by Ivan Sapozhnik on 5/24/17.
//  Copyright © 2017 Ivan Sapozhnik. All rights reserved.
//

import Foundation
import WatchConnectivity

protocol DataSourceChangedDelegate {
    func dataSourceDidUpdate(dataSource: Dictionary<String,Any>)
}

class WatchSessionManager: NSObject, WCSessionDelegate {
    
    static let sharedManager = WatchSessionManager()
    private override init() {
        super.init()
    }
    
    private let session: WCSession = WCSession.default()
    // keeps track of all the dataSourceChangedDelegates
    fileprivate var dataSourceChangedDelegates = [DataSourceChangedDelegate]()
    
    func startSession() {
        session.delegate = self
        session.activate()
    }
    
    //MARK: delegate
    
    @available(iOS 9.3, *)
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
//    public func sessionDidBecomeInactive(_ session: WCSession) {
//        
//    }
//    
//    public func sessionDidDeactivate(_ session: WCSession) {
//        
//    }
    
    // adds / removes dataSourceChangedDelegates from the array
    func addDataSourceChangedDelegate<T>(delegate: T) where T: DataSourceChangedDelegate, T: Equatable {
        dataSourceChangedDelegates.append(delegate)
    }
    
    func removeDataSourceChangedDelegate<T>(delegate: T) where T: DataSourceChangedDelegate, T: Equatable {
        for (index, dataSourceDelegate) in dataSourceChangedDelegates.enumerated() {
            if let dataSourceDelegate = dataSourceDelegate as? T, dataSourceDelegate == delegate {
                dataSourceChangedDelegates.remove(at: index)
                break
            }
        }
    }
}

// MARK: Application Context
// use when your app needs only the latest information
// if the data was not sent, it will be replaced
extension WatchSessionManager {
    
    // Receiver
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        
        DispatchQueue.main.async() { [weak self] in
            self?.dataSourceChangedDelegates.forEach { $0.dataSourceDidUpdate(dataSource: applicationContext)}
        }
        
    }
}
