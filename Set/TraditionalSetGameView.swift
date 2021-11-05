//
//  TraditionalSetGameView.swift
//  Set
//
//  Created by Ryan Zubery on 9/15/21.
//

import SwiftUI

struct TraditionalSetGameView: View {
    @ObservedObject var game: TraditionalSetGame
    @Namespace private var dealingNamespaceAspect
    @Namespace private var dealingNamespaceScroll
    @Namespace private var discardingNamespaceAspect
    @Namespace private var discardingNamespaceScroll
    @Namespace private var boardNamespace
    
    var body: some View {
        VStack {
            Text("Set")
                .font(.largeTitle)
                .foregroundColor(.blue)
            if game.board.count <= 30 {
                AspectVGrid(items: game.board, aspectRatio: 13/21) { card in
                    // TODO: this and use in scrollview is not very readable
                    CardView(card, cardStatus: game.cardStatus(card), game: game)
                        .matchedGeometryEffect(id: card.id, in: dealingNamespaceAspect)
                        .matchedGeometryEffect(id: card.id, in: discardingNamespaceAspect)
                        .matchedGeometryEffect(id: card.id, in: boardNamespace)
                        .padding(DrawingConstants.betweenCards)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                game.select(card)
                            }
                        }
                    
                }
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))]) {
                        ForEach(game.board) { card in
                            CardView(card, cardStatus: game.cardStatus(card), game: game)
                                .matchedGeometryEffect(id: card.id, in: dealingNamespaceScroll)
                                .matchedGeometryEffect(id: card.id, in: discardingNamespaceScroll)
                                .matchedGeometryEffect(id: card.id, in: boardNamespace)
                                .padding(DrawingConstants.betweenCards)
                                .aspectRatio(13/21, contentMode: .fit)
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        game.select(card)
                                    }
                                }
                        }
                    }
                }
            }
            Spacer()
            HStack(alignment: .bottom) {
                newGame
                Spacer()
                deck
                Spacer()
                discardPile
                Spacer()
                score
            }
            .font(.largeTitle)
            .padding(.horizontal)
        }
        .padding()
    }
    
    private func zIndex(of card: TraditionalSetGame.Card, in stack: [TraditionalSetGame.Card]) -> Double {
        -Double(stack.firstIndex(where: { $0.id == card.id }) ?? 0)
    }
    
    var deck: some View {
        ZStack {
            ForEach(game.deck) { card in
                CardView(card, cardStatus: game.cardStatus(card), game: game)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespaceAspect)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespaceScroll)
                    .zIndex(zIndex(of: card, in: game.deck))
                    .opacity(0.5)
            }
        }
        .frame(width: DrawingConstants.deckWidth, height: DrawingConstants.deckHeight)
        .onTapGesture {
            withAnimation {
                game.discardMatchedCards()
                game.dealCards()
            }
        }
    }
    
    var discardPile: some View {
        ZStack {
            ForEach(game.discard) { card in
                CardView(card, cardStatus: game.cardStatus(card), game: game)
                    .matchedGeometryEffect(id: card.id, in: discardingNamespaceAspect)
                    .matchedGeometryEffect(id: card.id, in: discardingNamespaceScroll)
                    .zIndex(-zIndex(of: card, in: game.discard))
            }
        }
        .frame(width: DrawingConstants.discardWidth, height: DrawingConstants.discardHeight)
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
    
    private struct DrawingConstants {
        static let cardAspectRatio: CGFloat = 13/21
        static let betweenCards: CGFloat = 5
        static let deckHeight: CGFloat = 90
        static let deckWidth: CGFloat = deckHeight * cardAspectRatio
        static let discardHeight = deckHeight
        static let discardWidth = deckWidth
    }
}

struct CardView: View {
    @ObservedObject var game: TraditionalSetGame
    let card: TraditionalSetGame.Card
    let cardBorderColor: Color
    let cardBorderThickness: CGFloat
    var isFaceUp: Bool {
        return game.board.contains(card) || game.discard.contains(card)
    }
    
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                shape.fill(Color.white)
                shape.strokeBorder(cardBorderColor, lineWidth: cardBorderThickness)
                TraditionalSetFeature(cardToDraw: card)
                    .opacity(isFaceUp ? 1.0 : 0.0)
            }
            .rotation3DEffect(Angle(degrees: game.cardStatus(card) == .match ? -30: 0), axis: (x: 1.0, y: 0.0, z: 0.0))
            .rotation3DEffect(Angle(degrees: game.cardStatus(card) == .nonmatch ? -30: 0), axis: (x: 0.0, y: 1.0, z: 0.0))
        })
    }
    
    init(_ card: TraditionalSetGame.Card, cardStatus: TraditionalSetGame.CardStatus, game: TraditionalSetGame) {
        self.card = card
        self.game = game
        
        switch cardStatus {
        case .unselected:
            cardBorderColor = .black
            cardBorderThickness = 1
        case .selected:
            cardBorderColor = .blue
            cardBorderThickness = 3
        case .nonmatch:
            cardBorderColor = .red
            cardBorderThickness = 3
        case .match:
            cardBorderColor = .green
            cardBorderThickness = 3
        }
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
