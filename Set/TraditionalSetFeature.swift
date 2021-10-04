//
//  TraditionalSetFeature.swift
//  Set
//
//  Created by Ryan Zubery on 9/19/21.
//

import SwiftUI

struct TraditionalSetFeature: View {
    let cardToDraw: TraditionalSetGame.Card
    
    var body: some View {
        let borderColor = colorOfFeature(cardToDraw.featureColor)
        let fillColor = borderColor.opacity(opacityOfFeature(cardToDraw.featureShading))

        switch cardToDraw.featureShape {
        case .one:
            VStack {
                ForEach(0..<cardToDraw.featureNumber.rawValue) { _ in
                    TraditionalSetDiamond()
                        .stroke(borderColor)
                        .background(
                            TraditionalSetDiamond()
                                .fill(fillColor)
                        )
                        .padding(.horizontal, DrawingConstants.featurePadding)
                }
            }.padding(.vertical, DrawingConstants.featurePadding)
        case .two:
            VStack {
                ForEach(0..<cardToDraw.featureNumber.rawValue) { _ in
                    TraditionalSetSquiggle()
                        .stroke(borderColor)
                        .background(
                            TraditionalSetSquiggle()
                                .fill(fillColor)
                        )
                        .padding(.horizontal, DrawingConstants.featurePadding)
                }
            }.padding(.vertical, DrawingConstants.featurePadding)
        case .three:
            VStack {
                ForEach(0..<cardToDraw.featureNumber.rawValue) { _ in
                    TraditionalSetOval()
                        .stroke(borderColor)
                        .background(
                            TraditionalSetOval()
                                .fill(fillColor)
                        )
                        .padding(.horizontal, DrawingConstants.featurePadding)
                }
            }
            .padding(.vertical, DrawingConstants.featurePadding)
        }
    }
    
    func colorOfFeature(_ feature: TraditionalSetGame.Card.Feature) -> Color {
        switch feature {
        case .one:
            return .red
        case .two:
            return .green
        case .three:
            return .purple
        }
    }
    
    func opacityOfFeature(_ feature: TraditionalSetGame.Card.Feature) -> Double {
        switch feature {
        case .one:
            return 1.0
        case .two:
            return 0.5
        case .three:
            return 0.0
        }
    }
    
    fileprivate struct DrawingConstants {
        static let featureAspectRatio: CGFloat = 39/21
        static let featurePadding: CGFloat = 10
    }
}

struct TraditionalSetDiamond: Shape {
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        // TODO: the below might be redundant given that the aspect ratios are special constants
        let radius = min(rect.width, rect.height) / 2
        let halfHeight = radius / TraditionalSetFeature.DrawingConstants.featureAspectRatio
        let halfWidth = radius
        
        let rightPoint = CGPoint(x: center.x + halfWidth, y: center.y)
        let bottomPoint = CGPoint(x: center.x, y: center.y + halfHeight)
        let leftPoint = CGPoint(x: center.x - halfWidth, y: center.y)
        let topPoint = CGPoint(x: center.x, y: center.y - halfHeight)
        
        var p = Path()
        p.move(to: rightPoint)
        p.addLine(to: bottomPoint)
        p.addLine(to: leftPoint)
        p.addLine(to: topPoint)
        p.addLine(to: rightPoint)
        return p
    }
}

struct TraditionalSetSquiggle: Shape {
    func path(in rect: CGRect) -> Path {
        // TODO: similar code to oval, consolidate?
        let center = CGPoint(x: rect.midX, y: rect.midY)
        // TODO: the below might be redundant given that the aspect ratios are special constants
        let diameter = min(rect.width, rect.height)
        let height = diameter / TraditionalSetFeature.DrawingConstants.featureAspectRatio
        let width = diameter
        
        let boundingTopLeft = CGPoint(x: center.x - width / 2, y: center.y - height / 2)
        
        let squiggleBoundingRect = CGRect(x: boundingTopLeft.x, y: boundingTopLeft.y, width: width, height: height)
        
        let boundingBottomLeft = CGPoint(x: squiggleBoundingRect.minX, y: squiggleBoundingRect.maxY)
        let boundingTopRight = CGPoint(x: squiggleBoundingRect.maxX, y: squiggleBoundingRect.minY)
        let boundingBottomRight = CGPoint(x: squiggleBoundingRect.maxX, y: squiggleBoundingRect.maxY)
        
        let leftSemicircleCenter = CGPoint(x: boundingBottomLeft.x + (width * 0.2), y: boundingBottomLeft.y - (height * 0.2))
        let rightSemicircleCenter = CGPoint(x: boundingBottomLeft.x + (width * 0.8), y: boundingBottomLeft.y - (height * 0.8))
        
        // TODO: would be nice to smooth out squiggle curves
        var p = Path()
        p.move(to: boundingBottomLeft)
        p.addQuadCurve(to: rightSemicircleCenter, control: boundingTopLeft)
        p.addLine(to: boundingTopRight)
        p.addQuadCurve(to: leftSemicircleCenter, control: boundingBottomRight)
        p.addLine(to: boundingBottomLeft)
        
        return p
    }
}


struct TraditionalSetOval: Shape {
    func path(in rect: CGRect) -> Path {
        // TODO: similar code to diamond, consolidate?
        let center = CGPoint(x: rect.midX, y: rect.midY)
        // TODO: the below might be redundant given that the aspect ratios are special constants
        let diameter = min(rect.width, rect.height)
        let height = diameter / TraditionalSetFeature.DrawingConstants.featureAspectRatio
        let width = diameter
        
        let boundingTopLeft = CGPoint(x: center.x - width / 2, y: center.y - height / 2)
        
        let ovalBoundingRect = CGRect(x: boundingTopLeft.x, y: boundingTopLeft.y, width: width, height: height)
        
        let capsuleCornerSize = CGSize(width: 25, height: 25)
        
        
        var p = Path()
        p.addRoundedRect(in: ovalBoundingRect, cornerSize: capsuleCornerSize)
        return p
    }
}
