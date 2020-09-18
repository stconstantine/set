//
//  SetCardView.swift
//  Set
//
//  Created by Константин Стародубцев on 29.08.2020.
//  Copyright © 2020 Constantin Starodubtsev. All rights reserved.
//

import UIKit
//import CoreGraphics

@IBDesignable
class SetCardView: UIView {
    
    
    //MARK: Public interface to set card
    var itemColor: ItemColor = .one
    var itemShading: ItemShading = .stripped {didSet {setNeedsDisplay()}}
    var itemShape: ItemShape = .squiggle {didSet {setNeedsDisplay()}}
    var itemsCount: Int = 3 {didSet {setNeedsDisplay()}}
    var isSelected: Bool = true {didSet {setNeedsDisplay()}}
    var isMatched: Bool? {didSet {setNeedsDisplay()}}
    var isHinted: Bool = false {didSet {setNeedsDisplay()}}
    var isFacedUp: Bool = true {didSet {setNeedsDisplay()}}
    func flip() {
        isFacedUp = !isFacedUp
    }
    
    override func draw(_ rect: CGRect) {
        updateStateOfCard()
        drawCard()
        contentMode = .redraw
    }

    private func updateStateOfCard() {
        let insetForBorder = UIEdgeInsets(top: borderWidthForItemAndCard*1.5,
                                                       left: borderWidthForItemAndCard*1.5,
                                                       bottom: borderWidthForItemAndCard*1.5,
                                                       right: borderWidthForItemAndCard*1.5) // inset to make a space in view for thick border of cardShape
        let cardShape = UIBezierPath(roundedRect: bounds.inset(by: insetForBorder),
                                                  cornerRadius: cardCornerRadius)
        
        cardShape.lineWidth = borderWidthForItemAndCard*1.5
        cardShape.addClip()
        
        switch isHinted {
        case true: borderColorForHinted.setStroke()
        default: UIColor.clear.setStroke()
        }
        switch isSelected {
        case true: backgroundColorForSelected.setFill()
        default: backgroundDefaultColor.setFill()
        }
        switch isMatched {
        case .some(true): backgroundColorForMatched.setFill()
        case .some(false): backgroundColorForMissmatched.setFill()
        case .none: backgroundDefaultColor.setFill()
        }
        
        cardShape.stroke()
        cardShape.fill()
    }
    
    //MARK: draw card and an distinct item ("thing") depending on public properties
    private func drawCard() {
        //функция рисует нужное количество элементов things на карточке или рубашку
        if !isFacedUp {
            showReverse()
            return
        }
        
        //создаём массив фреймов для элементов и массив начальных точек для расположения этих элементов
        var thingPlace = [CGRect]()
        var thingPlaceOrigin = [CGPoint]()
        
        //Создаём размер фрейма
        let thingPlaceSize = CGSize(width: layer.bounds.maxX*0.8,
                                    height: layer.bounds.maxY*0.2)
        
        //Заполняем массив начальных точек в зависимости от необходимого количества элементов к отрисовке
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
        
        //заполняем массив фреймов — создаём прямоугольник для каждой начальной точки
        thingPlace = thingPlaceOrigin.map {CGRect(origin: $0, size: thingPlaceSize)}
        //рисуем каждый прямоугольник и фигурку в нём
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
        print("Reverse!")
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
    
    //MARK: General properties for view
    private var borderWidthForItemAndCard: CGFloat {
        return max(max(bounds.width,bounds.height)/200,1)
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
    private let backgroundColorForSelected: UIColor = .systemFill
    private let backgroundColorForMatched: UIColor = .systemGreen
    private let backgroundColorForMissmatched: UIColor = .black
    private let borderColorForHinted: UIColor = .systemTeal
    private let stripesDensity: CGFloat = 2.5
    
    enum ItemShape: CaseIterable {case diamond, squiggle, oval}
    enum ItemShading: CaseIterable {case clear, stripped, solid}
    enum ItemColor: CaseIterable {case one, two, three}
}
