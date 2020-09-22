//
//  SetCardView.swift
//  Set
//
//  Created by Константин Стародубцев on 29.08.2020.
//  Copyright © 2020 Constantin Starodubtsev. All rights reserved.
//

import UIKit

@IBDesignable

class SetCardView: UIView {
    //MARK: Public interface to set card
    var itemColor: ItemColor = .one
    var itemShading: ItemShading = .stripped {didSet {setNeedsDisplay()}}
    var itemShape: ItemShape = .squiggle {didSet {setNeedsDisplay()}}
    var itemsCount: Int = 3 {didSet {setNeedsDisplay()}}
    var status: CardStatus = .default {didSet {setNeedsDisplay()}}
    var isFacedUp: Bool = true

    override func draw(_ rect: CGRect) {
        drawCardBulk()
        drawCardElements()
        contentMode = .redraw
    }

    private func drawCardBulk() {
        clipsToBounds = true
        layer.cornerRadius = cardCornerRadius
        let cardShape = UIBezierPath(rect: bounds)
        
        switch status {
        case .hinted: backgroundColorForHinted.setFill()
        case .matched: backgroundColorForMatched.setFill()
        case .selected: backgroundColorForSelected.setFill()
        default: backgroundDefaultColor.setFill()
        }
        
        cardShape.stroke()
        cardShape.fill()
    }
    
    //MARK: draw card and an distinct item ("thing") depending on public properties
    private func drawCardElements() {
        
        
        if !isFacedUp { showReverse(); return }
        var thingPlace = [CGRect]()
        var thingPlaceOrigin = [CGPoint]()
        let thingPlaceSize = CGSize(width: layer.bounds.maxX*0.8,
                                    height: layer.bounds.maxY*0.2)
        switch itemsCount {
        case 2:
            thingPlaceOrigin.append(CGPoint(x: (bounds.width-thingPlaceSize.width)/2,
                                         y: (bounds.height-thingPlaceSize.height)*0.3))
            thingPlaceOrigin.append(CGPoint(x: (bounds.width-thingPlaceSize.width)/2,
                                         y: (bounds.height-thingPlaceSize.height)*0.7))
        case 3:
            thingPlaceOrigin.append(CGPoint(x: (bounds.width-thingPlaceSize.width)/2,
                                         y: (bounds.height-thingPlaceSize.height)*0.5))
            thingPlaceOrigin.append(CGPoint(x: (bounds.width-thingPlaceSize.width)/2,
                                         y: (bounds.height-thingPlaceSize.height)*0.125))
            thingPlaceOrigin.append(CGPoint(x: (bounds.width-thingPlaceSize.width)/2,
                                         y: (bounds.height-thingPlaceSize.height)*0.875))
        default:
            thingPlaceOrigin.append(CGPoint(x: (bounds.width-thingPlaceSize.width)/2,
                                         y: (bounds.height-thingPlaceSize.height)/2))
        }
        thingPlace = thingPlaceOrigin.map {CGRect(origin: $0, size: thingPlaceSize)}
        thingPlace.forEach {drawThing(in: $0)}
    }
    private func drawThing(in frame: CGRect) {
        var thing: UIBezierPath
        switch itemShape {
        case .squiggle: thing = squiggle(in: frame)
        case .oval:  thing = oval(in: frame)
        case .diamond: thing = diamond(in: frame)
        }
        
        if itemShading == .solid {
            drawColor.setFill()
        } else {UIColor.clear.setFill()}
        
        thing.lineWidth = borderWidthForItemAndCard
        drawColor.setStroke()
        
        if itemShading == .stripped {
            stripesShading(for: thing, in: frame)
        }
        
        thing.fill()
        thing.stroke()
    }
    private func showReverse() {
        let reverseImage: UIImage? = UIImage(named: "cardReverseImage")
        reverseImage?.draw(in: bounds)
    }
    
    //MARK: thing pathes
    private func diamond(in frame: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: frame.midX, y: frame.minY))
        path.addLine(to: CGPoint(x: frame.maxX,y: frame.midY))
        path.addLine(to: CGPoint(x: frame.midX,y: frame.maxY))
        path.addLine(to: CGPoint(x: frame.minX,y: frame.midY))
        path.close()
        
        return path
    }
    private func squiggle(in frame: CGRect) -> UIBezierPath {
        let upperSquiggle = UIBezierPath()
        let sqdx = frame.width * 0.1
        let sqdy = frame.height * 0.2
        upperSquiggle.move(to: CGPoint(x: frame.minX, y: frame.midY))
        upperSquiggle.addCurve(to:
            CGPoint(x: frame.minX + frame.width * 1/2,
                    y: frame.minY + frame.height / 8),
                               controlPoint1: CGPoint(x: frame.minX,
                                                      y: frame.minY),
                               controlPoint2: CGPoint(x: frame.minX + frame.width * 1/2 - sqdx,
                                                      y: frame.minY + frame.height / 8 - sqdy))
        upperSquiggle.addCurve(to:
            CGPoint(x: frame.minX + frame.width * 4/5,
                    y: frame.minY + frame.height / 8),
                               controlPoint1: CGPoint(x: frame.minX + frame.width * 1/2 + sqdx,
                                                      y: frame.minY + frame.height / 8 + sqdy),
                               controlPoint2: CGPoint(x: frame.minX + frame.width * 4/5 - sqdx,
                                                      y: frame.minY + frame.height / 8 + sqdy))
        
        upperSquiggle.addCurve(to:
            CGPoint(x: frame.minX + frame.width,
                    y: frame.minY + frame.height / 2),
                               controlPoint1: CGPoint(x: frame.minX + frame.width * 4/5 + sqdx,
                                                      y: frame.minY + frame.height / 8 - sqdy ),
                               controlPoint2: CGPoint(x: frame.minX + frame.width,
                                                      y: frame.minY))
        
        let lowerSquiggle = UIBezierPath(cgPath: upperSquiggle.cgPath)
        lowerSquiggle.apply(CGAffineTransform.identity.rotated(by: CGFloat.pi))
        lowerSquiggle.apply(CGAffineTransform.identity.translatedBy(
            x: bounds.width,
            y: bounds.height))
        upperSquiggle.move(to: CGPoint(x: frame.minX, y: frame.midY))
        upperSquiggle.append(lowerSquiggle)
        return upperSquiggle
    }
    private func oval(in frame: CGRect) -> UIBezierPath {
        return UIBezierPath(ovalIn: frame)
    }
    private func stripesShading(for item: UIBezierPath,in frame: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        item.addClip()
        
        let stripesShading = UIBezierPath()
        stripesShading.lineWidth = borderWidthForItemAndCard * stripesDensity / 5
        stripesShading.move(to: CGPoint(x: frame.minX, y: bounds.minY))
        
        var xpos: CGFloat = frame.minX
        while xpos < frame.maxX {
            let line = UIBezierPath()
            line.move(to: CGPoint(x: xpos, y: bounds.minY))
            line.addLine(to: CGPoint(x: xpos, y: bounds.maxY))
            stripesShading.append(line)
            xpos += borderWidthForItemAndCard*stripesDensity
        }
        stripesShading.stroke()

        context?.restoreGState()
    }
    
    //MARK: General parameters for card view
    private var borderWidthForItemAndCard: CGFloat {
        return max(max(bounds.width,bounds.height)/100,1)
    }
    private var cardCornerRadius: CGFloat {
        return borderWidthForItemAndCard * 5
    }
    private var drawColor: UIColor {
        switch itemColor {
        case .one: return .systemRed
        case .two: return .systemYellow
        case .three: return .systemBlue
        }
    }
    private let backgroundDefaultColor: UIColor = .white
    private let backgroundColorForSelected: UIColor = .darkGray
    private let backgroundColorForMatched: UIColor = .systemGreen
    private let backgroundColorForHinted: UIColor = #colorLiteral(red: 0.7952989892, green: 0.9228176517, blue: 1, alpha: 1)
    private let stripesDensity: CGFloat = 2.5
    
    enum CardStatus: CaseIterable {case matched, selected, hinted, `default`}
    enum ItemShape: CaseIterable {case diamond, squiggle, oval}
    enum ItemShading: CaseIterable {case clear, stripped, solid}
    enum ItemColor: CaseIterable {case one, two, three}
}
