//
//  TraditionalSetGameView.swift
//  Set
//
//  Created by Ryan Zubery on 9/15/21.
//

import SwiftUI

struct TraditionalSetGameView: View {
    @ObservedObject var game: TraditionalSetGame
    
    var body: some View {
        VStack {
            Text("Set")
                .font(.largeTitle)
                .foregroundColor(.blue)
            AspectVGrid(items: game.board, aspectRatio: 13/21) { card in
                CardView(card: card)
                    .padding(DrawingConstants.betweenCards)
                    .onTapGesture {
                        game.select(card)
                    }
                
            }
            Spacer()
            HStack(alignment: .bottom) {
                newGame
                Spacer()
                score
                Spacer()
                dealMoreCards
            }
            .font(.largeTitle)
            .padding(.horizontal)
        }
        .padding()
    }
    
    var newGame: some View {
        Button {
            game.newGame()
        } label: {
            Image(systemName: "arrow.counterclockwise.circle")
        }
    }
    
    var score: some View {
        var scoreString = String(game.score)
        
        if game.score > 0 {
            scoreString = "+" + scoreString
        }
        
        let scoreColor = game.score >= 0 ? Color.green : Color.red
        
        return Text(scoreString).foregroundColor(scoreColor)
    }
    
    var dealMoreCards: some View {
        Button {
            game.dealMoreCards()
        } label: {
            Image(systemName: "plus.rectangle.portrait")
        }
    }
    
    private struct DrawingConstants {
        static let betweenCards: CGFloat = 5
    }
}

struct CardView: View {
    let card: TraditionalSetGame.Card
    
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                shape.fill(Color.white)
                shape.strokeBorder()
            }
        })
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
    }
}

struct TraditionalSetGameView_Previews: PreviewProvider {
    static var previews: some View {
        let game = TraditionalSetGame()
        TraditionalSetGameView(game: game)
    }
}
