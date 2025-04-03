//
//  OSCReceiver.swift
//  oscBan
//
//  Created by trs on 4/2/25.
//




import Foundation
import OSCKit
import SwiftyCreatives

/// OSC receiver.
/// Registers local OSC addresses that our app is capable of recognizing and
/// handles received bundles & messages.
final class OSCReceiver: Sendable {
    private let addressSpace = OSCAddressSpace()
    private var sample: Sample?

    public init(sample: Sample?) {
        
        self.sample = sample
        addressSpace.register(localAddress: "/brightness_poll") { values, host, port in
            self.handleScreenBrightness(values: values, host: host, port: port)
        }
        addressSpace.register(localAddress: "/amp_poll") { values, host, port in
            self.handleAmpl(values: values, host: host, port: port)
        }
    }

    private func handleScreenBrightness(values: OSCValues, host: String, port: UInt16) {
            guard let value = values.first as? Float else { return }
            let normalized = value / 255.0
//            print("handleScreenBrightness: \(normalized)")
        
        
        
        
        
            DispatchQueue.main.async {
                print(" as handleScreenBrightness \(normalized)")
                
                self.sample?.dt = normalized
                Sample.dynamicColor = f4(normalized / 10.0, normalized / 10.5, normalized / 10.0, 0.6)
            }
        
        

            
        }

    private func handleAmpl(values: OSCValues, host: String, port: UInt16) {
            guard let value = values.first as? Float else { return }
            let normalized = value
            print("handleAmpl: \(value)")
            
            DispatchQueue.main.async {
                print(" as handleScreenBrightness \(value)")
                
                self.sample?.dt = normalized
                Sample.ampl = normalized
            }

            

            
        }

    private func handleAnalysis(values: OSCValues, host: String, port: UInt16) {
        if values.count >= 1,
           let brightness = values[0] as? Float,
           let amp = values[1] as? Float {
            print("Received /analysis from \(host):\(port) -> Brightness: \(brightness), Amplitude: \(amp)")
        } else {
            print("⚠️ Invalid /analysis message format")
        }
    }

    public func handle(message: OSCMessage, timeTag: OSCTimeTag, host: String, port: UInt16) throws {
        
        let methodIDs = addressSpace.dispatch(message: message, host: host, port: port)
        
        if methodIDs.isEmpty {
            print("⚠️ No handler registered for: \(message)")
        }
    }
}
