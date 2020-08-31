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
        let thingFrame = CGRect(origin: CGPoint(x: 30,y: 30), size: CGSize(width: 200.0, height: 100.0))
        let card = Card(shape: .diamond,
                        shading: .clear,
                        color: .one,
                        number: .one)
        
        decorate(the: diamond(in: thingFrame), colorizeWith: card.color.drawColor, shadeWith: card.shading)
    }
    
//    func drawThing(for card: Card, in frame: CGRect) {
//        switch card.shape {
//        case .diamond: drawDiamond(colored: card.color, shaded: card.shading, in: frame)
//        case .wave: drawSquiggle(colored: card.color, shaded: card.shading, in: frame)
//        case .oval: drawOval(colored: card.color, shaded: card.shading, in: frame)
//        }
//    }
    
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
    
    func squiggle(in frame: CGRect) {
        
    }
    
    func oval(in frame: CGRect) -> UIBezierPath {
        return UIBezierPath(ovalIn: frame)
    }
    
    func decorate(the thing: UIBezierPath, colorizeWith color: UIColor, shadeWith shading: Card.Shadings) {
        thing.lineWidth = max(thing.bounds.width,thing.bounds.height)/20
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
