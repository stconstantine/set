//
//  SetCardView.swift
//  Set
//
//  Created by Константин Стародубцев on 29.08.2020.
//  Copyright © 2020 Constantin Starodubtsev. All rights reserved.
//

import UIKit

class SetCardView: UIView {

    override func draw(_ rect: CGRect) {

        let card = Card(shape: .wave,
                        shading: .clear,
                        color: .one,
                        number: .one)
        
        decorate(the: thing(for: card, in: bounds),
                 colorizeWith: card.color.drawColor,
                 shadeWith: card.shading)

    }
    
    func thing(for card: Card, in frame: CGRect) -> UIBezierPath {
        let undecoratedThing: UIBezierPath
        switch card.shape {
        case .diamond: undecoratedThing = diamond(in: frame)
        case .wave: undecoratedThing = squiggle(in: frame)
        case .oval: undecoratedThing = oval(in: frame)
        }
        return undecoratedThing
    }
    
    func decorate(the thing: UIBezierPath, colorizeWith color: UIColor, shadeWith shading: Card.Shadings) {
        thing.lineCapStyle = .round
        thing.lineJoinStyle = .round
        thing.lineWidth = max(thing.bounds.width,thing.bounds.height)/30
        thing.addClip()
        color.setStroke()
        thing.stroke()
        var fillColor: UIColor = .white
        switch shading {
        case .solid: fillColor = color
        case .stripped: return // сделать заливку полосками
        case .clear: return
        }
        fillColor.setFill()
        thing.fill()
    }
    func diamond(in frame: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: frame.midX,
                              y: frame.minY))
        path.addLine(to: CGPoint(x: frame.maxX,
                                 y: frame.midY))
        path.addLine(to: CGPoint(x: frame.midX,
                                 y: frame.maxY))
        path.addLine(to: CGPoint(x: frame.minX,
                                 y: frame.midY))
        path.close()
        return path
    }
    func squiggle(in frame: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        let curvness: CGFloat = 0.45
        let lines = [frame.midY-frame.maxY*curvness/2, frame.midY+frame.maxY*curvness/2]
        let xGap: CGFloat = 0.2
        let corr: CGFloat = 0.825
    
        let basePoints = [CGPoint(x: frame.maxX*xGap, y: lines[0]),
                          CGPoint(x: frame.midX, y: lines[0]),
                          CGPoint(x: frame.maxX*(1-xGap), y: lines[0]),
                          CGPoint(x: frame.maxX*xGap, y: lines[1]),
                          CGPoint(x: frame.midX, y: lines[1]),
                          CGPoint(x: frame.maxX*(1-xGap), y: lines[1])
        ]
        
        let controlPoints = [CGPoint(x: (basePoints[0].x+basePoints[1].x)/2, y: lines[0]-frame.maxY*curvness),
                             CGPoint(x: (basePoints[1].x+basePoints[2].x)/2, y: lines[0]+frame.maxY*curvness),
                             CGPoint(x: (basePoints[3].x+basePoints[4].x)/2, y: lines[1]-frame.maxY*curvness),
                             CGPoint(x: (basePoints[4].x+basePoints[5].x)/2, y: lines[1]+frame.maxY*curvness),
                             CGPoint(x: frame.maxX*(corr+xGap), y: frame.minY-frame.maxY*(curvness-0.1)),
                             CGPoint(x: frame.minX-frame.maxX*(xGap-1+corr), y: frame.maxY*(curvness+0.9)),
                             
        ]
        
        path.move(to: basePoints[0])
        path.addQuadCurve(to: basePoints[1], controlPoint: controlPoints[0])
        path.addQuadCurve(to: basePoints[2], controlPoint: controlPoints[1])
        
        path.move(to: basePoints[3])
        path.addQuadCurve(to: basePoints[4], controlPoint: controlPoints[2])
        path.addQuadCurve(to: basePoints[5], controlPoint: controlPoints[3])
        
        path.move(to: basePoints[5])
        path.addQuadCurve(to: basePoints[2], controlPoint: controlPoints[4])
        
        path.move(to: basePoints[0])
        path.addQuadCurve(to: basePoints[3], controlPoint: controlPoints[5])
        
        return path
    }
    func oval(in frame: CGRect) -> UIBezierPath {
        return UIBezierPath(ovalIn: frame)
    }
}

extension Card.Colors {
    var drawColor: UIColor {
        switch self {
        case .one: return .systemRed
        case .two: return .systemYellow
        case .three: return .systemBlue
        }
    }
}
