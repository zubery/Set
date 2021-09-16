//
//  SetApp.swift
//  Set
//
//  Created by Ryan Zubery on 8/19/21.
//

import SwiftUI

@main
struct SetApp: App {
    private let game = TraditionalSetGame()
    
    var body: some Scene {
        WindowGroup {
            TraditionalSetGameView(game: game)
        }
    }
}
