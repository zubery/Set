//
//  SetGame.swift
//  Set
//
//  Created by Ryan Zubery on 9/8/21.
//

import Foundation

struct SetGame {
    private(set) var deck: [Card]
    private(set) var discard: [Card]
    private(set) var board: [Card]
    private(set) var selectedCards = [Card]() {
        didSet {
            if selectedCards.count == 3,
               isASet(
                first: selectedCards[0],
                second: selectedCards[1],
                third: selectedCards[2]
               ) {
                // TODO: Have to set original cards in board due to deep copy to selectedCards; any better way to do this?
                board = board.map { card in
                    if selectedCards.contains(card) {
                        var matchedCard = card
                        matchedCard.isMatched = true
                        return matchedCard
                    } else {
                        return card
                    }
                }
                
                selectedCards[0].isMatched = true
                selectedCards[1].isMatched = true
                selectedCards[2].isMatched = true
                
                score += 1
            }
        }
    }
    private(set) var score = 0
    
    private static let numberOfCards = 81
    private static let startingDealSize = 12
    private static let dealSize = 3
    
    mutating func select(_ card: Card) {
        if selectedCards.count < 3 {
            if let existingIndex = selectedCards.firstIndex(of: card) {
                selectedCards.remove(at: existingIndex)
            } else {
                selectedCards.append(card)
            }
        } else if selectedCards.count == 3 {
            if selectedCards.first!.isMatched {
                discardMatchedCards()
                if board.contains(card) {
                    selectedCards.append(card)
                }
            } else {
                selectedCards.removeAll()
                selectedCards.append(card)
            }
        }
    }
    
    private func isASet(first: Card, second: Card, third: Card) -> Bool {
        let numbersCheck = doFeaturesMakeSet(first.featureNumber, second.featureNumber, third.featureNumber)
        let shapeCheck = doFeaturesMakeSet(first.featureShape, second.featureShape, third.featureShape)
        let shadingCheck = doFeaturesMakeSet(first.featureShading, second.featureShading, third.featureShading)
        let colorCheck = doFeaturesMakeSet(first.featureColor, second.featureColor, third.featureColor)
        
        
        let result = numbersCheck && shapeCheck && shadingCheck && colorCheck
        
        return result
    }
    
    mutating func dealCards() {
        let numberOfCardsToDeal: Int
        
        if board.count == 0 {
            numberOfCardsToDeal = min(SetGame.startingDealSize, deck.count)
        } else {
            numberOfCardsToDeal = min(SetGame.dealSize, deck.count)
        }
        
        board.append(contentsOf: deck[0..<numberOfCardsToDeal])
        deck.removeFirst(numberOfCardsToDeal)
    }
    
    mutating func discardMatchedCards() {
        if selectedCards.count == 3, selectedCards.first!.isMatched {
            discard.append(contentsOf: selectedCards)
            selectedCards.removeAll()
            // TODO: Should I use filter or forEach here?
            board = board.filter { !$0.isMatched }
        }
    }
    
    // For features to make a "set", they all have to be the same or all be distinct
    private func doFeaturesMakeSet(_ first: Card.Feature, _ second: Card.Feature, _ third: Card.Feature) -> Bool {
        let uniqueFeatures: Set = [first, second, third]
        return (uniqueFeatures.count == 1 || uniqueFeatures.count == 3)
    }
    
    init() {
        deck = []
        board = []
        discard = []
        
        // TODO: Is there a better way to do this 4-fold Cartesian Product?
        for number in Card.Feature.allCases {
            for shape in Card.Feature.allCases {
                for shading in Card.Feature.allCases {
                    for color in Card.Feature.allCases {
                        deck.append(Card(
                                        featureNumber: number,
                                        featureShape: shape,
                                        featureShading: shading,
                                        featureColor: color
                        ))
                    }
                }
            }
        }
        
        deck.shuffle()
    }
    
    struct Card: Identifiable, Equatable {
        var id: Int {
            // TODO: Uses "magic" numbers, should I refactor to be generic here?
            let onePlace = 1 * featureNumber.rawValue
            let threePlace = 3 * (featureShape.rawValue - 1)
            let ninePlace = 9 * (featureShading.rawValue - 1)
            let twentySevenPlace = 27 * (featureColor.rawValue - 1)
            
            return onePlace + threePlace + ninePlace + twentySevenPlace
        }
        var isMatched = false
        let featureNumber: Feature
        let featureShape: Feature
        let featureShading: Feature
        let featureColor: Feature
        
        enum Feature: Int, CaseIterable {
            case one = 1, two, three
        }
    }
}
