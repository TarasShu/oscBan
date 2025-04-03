//
//  OSCManager.swift
//  oscBan
//
//  Created by trs on 4/2/25.
//


import Foundation
import OSCKit

/// OSC lifecycle and send/receive manager.
final class OSCManager: ObservableObject {
    private var socket: OSCSocket?
    
   
    @Published var isIPv4BroadcastEnabled: Bool = true
    @Published private(set) var isStarted: Bool = false
    var receiver: OSCReceiver? 
    private let client = OSCClient()

    private let server = OSCServer(port: 8000)

    @Published var localPort: UInt16 = 8000
    @Published var remoteHost: String = "10.100.102.9"
    @Published var remotePort: UInt16 = 10111
    
    init() {
        start()
    }
}

// MARK: - Lifecycle

extension OSCManager {
    /// Call this once on app launch.
    func start() {
        do {
            guard socket == nil else { return }
            
            let newSocket = OSCSocket(
                localPort: localPort,
                remoteHost: remoteHost,
                remotePort: remotePort,
                isIPv4BroadcastEnabled: isIPv4BroadcastEnabled
            )
            socket = newSocket
            

            
            socket?.setHandler { [weak self] message, timeTag, host, port in
                do {
                    try self?.receiver?.handle(message: message, timeTag: timeTag, host: host, port: port)
                    
                } catch {
                    print(error)
                    
                }
            }
            
            try newSocket.start()
            
            isStarted = true
            
            let lp = newSocket.localPort
            let rp = newSocket.remotePort
            print("Using local port \(lp) and remote port \(rp) with remote host \(remoteHost).")
        } catch {
            print("Error while starting OSC socket: \(error)")
        }
    }

    
    func stop() {
        defer {
            isStarted = false
        }
        socket?.stop()
        socket = nil
    }
}

// MARK: - Send

extension OSCManager {
    func send(_ message: OSCMessage) {
        do {
            try socket?.send(message)
        } catch {
            print(error)
        }
    }
}
