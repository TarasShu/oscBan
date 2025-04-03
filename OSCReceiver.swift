//
//  OSCReceiver.swift
//  oscBan
//
//  Created by trs on 4/2/25.
//




import Foundation
import OSCKit

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
            print("handleScreenBrightness: \(normalized)")

            Task { @MainActor in
                self.sample?.dt = normalized
            }
        }

    private func handleAmpl(values: OSCValues, host: String, port: UInt16) {
            guard let value = values.first as? Float else { return }
            print("handleAmpl: \(value)")

            Task { @MainActor in
                self.sample?.diffusion = value
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
        print("Incoming address: \(message)") // 👈
        let methodIDs = addressSpace.dispatch(message: message, host: host, port: port)
        
        if methodIDs.isEmpty {
            print("⚠️ No handler registered for: \(message)")
        }
    }
}
