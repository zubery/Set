//
//  SetGame.swift
//  Set
//
//  Created by Ryan Zubery on 9/8/21.
//

import Foundation

struct SetGame {
    private var deck: [Card]
    private(set) var board: [Card]
    private(set) var selectedCards = [Card]()
    private(set) var score = 0
    
    private static let numberOfCards = 81
    private static let numberOfStartingCards = 12
    private static let numberOfCardsToDeal = 3
    
    mutating func select(_ card: Card) {
        if selectedCards.count < 3 {
            if let existingIndex = selectedCards.firstIndex(of: card) {
                selectedCards.remove(at: existingIndex)
            } else {
                selectedCards.append(card)
            }
        } else if selectedCards.count == 3 {
            selectedCards.removeAll()
            
            if selectedCards.first!.isMatched {
                removeMatchedCards()
                dealCards()
                if board.contains(card) {
                    selectedCards.append(card)
                }
            } else {
                selectedCards.append(card)
            }
        }
    }
    
    private mutating func isASet(first: inout Card, second: inout Card, third: inout Card) -> Bool {
        let numbersCheck = doFeaturesMakeSet(first.featureNumber, second.featureNumber, third.featureNumber)
        let shapeCheck = doFeaturesMakeSet(first.featureShape, second.featureShape, third.featureShape)
        let shadingCheck = doFeaturesMakeSet(first.featureShading, first.featureShading, first.featureShading)
        let colorCheck = doFeaturesMakeSet(first.featureColor, second.featureColor, third.featureColor)
        
        
        let result = numbersCheck && shapeCheck && shadingCheck && colorCheck
        
        if result == true {
            first.isMatched = true
            second.isMatched = true
            third.isMatched = true
            score += 1
        }
        
        return result
    }
    
    private mutating func dealCards() {
        if SetGame.numberOfCardsToDeal <= deck.count {
            board.append(contentsOf: deck[0..<SetGame.numberOfCardsToDeal])
            deck.removeFirst(SetGame.numberOfCardsToDeal)
        }
    }
    
    mutating func dealMoreCards() {
        if selectedCards.count == 3, selectedCards.first!.isMatched {
            removeMatchedCards()
        }
        
        dealCards()
    }
    
    private mutating func removeMatchedCards() {
        // TODO: Should I use filter or forEach here?
        board = board.filter { !$0.isMatched }
    }
    
    // For features to make a "set", they all have to be the same or all be distinct
    private func doFeaturesMakeSet(_ first: Card.Feature, _ second: Card.Feature, _ third: Card.Feature) -> Bool {
        let uniqueFeatures: Set = [first, second, third]
        return (uniqueFeatures.count == 1 || uniqueFeatures.count == 3)
    }
    
    init() {
        deck = []
        
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
        board = Array(deck[0..<SetGame.numberOfStartingCards])
        deck.removeFirst(SetGame.numberOfStartingCards)
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
