//
//  ContentView.swift
//  oscBan
//
//  Created by trs on 4/2/25.
//

import SwiftUI
import SwiftyCreatives


struct ContentView: View {
    
    @EnvironmentObject var oscManager: OSCManager
    let sample: Sample
    
    init(oscManager: OSCManager) {
        sample = Sample()
        sample.oscManager = oscManager
        sample.oscManager?.receiver = OSCReceiver(sample: sample)
    }
    
    
    var body: some View {
        SketchView(sample)
    }
}


final class Sample: Sketch {
    var oscManager: OSCManager?


    static  var ampl: Float = 0.001
    static var dynamicColor: f4 = f4(1, 0.5, 1, 1)
    
    init(oscManager: OSCManager? = nil) {
        self.oscManager = oscManager
       }
    
    
    override func update(camera: MainCamera) {
        let angle = Sample.dynamicColor.y * 0.1 // scale as needed

        camera.rotateAroundY(angle)
    }
    
    
    override func draw(encoder: SCEncoder) {
        color(Sample.dynamicColor)
        box(f3.one * Sample.ampl * 18)
    }
}













