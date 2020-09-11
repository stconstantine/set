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
    //MARK: Constants
    private var itemBorderWidth: CGFloat {
        return max(max(bounds.width,bounds.height)/150,1)
    }
    private var cardCornerRadius: CGFloat {
        return itemBorderWidth * 1.5
    }
    @IBInspectable private var cardBackgroundColor: UIColor = .systemBackground
    
    var itemColor: ItemColor = .three
    @IBInspectable private var drawColor: UIColor {
        switch itemColor {
        case .one: return .systemRed
        case .two: return .systemYellow
        case .three: return .systemBlue
        }
    }
    
    var itemShading: ItemShading = .clear
    var thingShape: ItemShape = .squiggle
    var thingCount: Int = 3
    var isSelected: Bool = false
    var isMatched: Bool = false
    
    override func draw(_ rect: CGRect) {
        
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cardCornerRadius)
        cardBackgroundColor.setFill()
        roundedRect.fill()
        drawCard()
    }
    
    private func drawCard() {
        //функция рисует нужное количество элементов things на карточке
        
        //создаём массив фреймов для элементов и массив начальных точек для расположения этих элементов
        var thingPlace = [CGRect]()
        var thingPlaceOrigin = [CGPoint]()
        
        //Создаём размер фрейма
        let thingPlaceSize = CGSize(width: layer.bounds.maxX*0.8,
                                    height: layer.bounds.maxY*0.2)
        
        //Заполняем массив начальных точек в зависимости от необходимого количества элементов к отрисовке
        switch thingCount {
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
        switch thingShape {
        case .squiggle: thing = squiggle(in: frame)
        case .oval:  thing = oval(in: frame)
        case .diamond: thing = diamond(in: frame)
        }
        if itemShading == .solid {
            drawColor.setFill()
        } else {cardBackgroundColor.setFill()}
        
        if itemShading == .stripped {
            drawStripes(in: frame)
        }
        
        thing.fill()
        thing.lineWidth = itemBorderWidth
        drawColor.setStroke()
        thing.stroke()
    }
    
    func drawStripes(in frame: CGRect) {
        
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
    
    enum ItemShape: CaseIterable {case diamond, squiggle, oval}
    enum ItemShading: CaseIterable {case clear, stripped, solid}
    enum ItemColor: CaseIterable {case one, two, three}
}
