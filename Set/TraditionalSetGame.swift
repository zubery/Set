//
//  TraditionalSetGame.swift
//  Set
//
//  Created by Ryan Zubery on 9/9/21.
//

import SwiftUI

class TraditionalSetGame: ObservableObject {
    typealias Card = SetGame.Card
    
    private static func createSetGame() -> SetGame {
        return SetGame()
    }
    
    @Published private var model: SetGame
    var board: [SetGame.Card] {
        return model.board
    }
    var selectedCards: [SetGame.Card] {
        return model.selectedCards
    }
    var score: Int {
        return model.score
    }
    
    // MARK: - Intent(s)
    
    func select(_ card: SetGame.Card) {
        model.select(card)
    }
    
    func dealMoreCards() {
        model.dealMoreCards()
    }
    
    func newGame() {
        model = TraditionalSetGame.createSetGame()
    }
    
    init() {
        model = TraditionalSetGame.createSetGame()
    }
}
