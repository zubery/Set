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
    var deck: [SetGame.Card] {
        return model.deck
    }
    var discard: [SetGame.Card] {
        return model.discard
    }
    var board: [SetGame.Card] {
        return model.board
    }
    var selectedCards: [SetGame.Card] {
        return model.selectedCards
    }
    var score: Int {
        return model.score
    }
    
    func cardStatus(_ card: SetGame.Card) -> CardStatus {
        if !model.selectedCards.contains(card) {
            return CardStatus.unselected
        } else {
            if model.selectedCards.count != 3 {
                return CardStatus.selected
            } else {
                if model.selectedCards.first!.isMatched {
                    return CardStatus.match
                } else {
                    return CardStatus.nonmatch
                }
            }
        }
    }
    
    enum CardStatus {
        case unselected, selected, nonmatch, match
    }
    
    // MARK: - Intent(s)
    
    func select(_ card: SetGame.Card) {
        model.select(card)
    }
    
    func dealCards() {
        model.dealCards()
    }
    
    func discardMatchedCards() {
        model.discardMatchedCards()
    }
    
    func newGame() {
        model = TraditionalSetGame.createSetGame()
    }
    
    init() {
        model = TraditionalSetGame.createSetGame()
    }
}
