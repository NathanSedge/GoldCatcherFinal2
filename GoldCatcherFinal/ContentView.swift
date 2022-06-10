//
//  ContentView.swift
//  GoldCatcherFinal
//
//  Created by Nathan on 04/05/2022.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    var scene: SKScene {
        let scene = MenuScene(size: UIScreen.main.bounds.size)
        scene.scaleMode = .fill
        return scene
    }
    
    var body: some View {
        SpriteView(scene: scene)
            .frame(width: scene.size.width, height: scene.size.height)
    }
}
