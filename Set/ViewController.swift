//
//  ViewController.swift
//  Set
//
//  Created by Константин Стародубцев on 06.08.2020.
//  Copyright © 2020 Constantin Starodubtsev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    let deck = Deck()
    
    //to fil NSAttributedString.Key.backgroundColor
    let cardShadingAttribute = [Card.Shadings.solid:UIColor.systemYellow,
                                Card.Shadings.stripped:UIColor.systemTeal,
                                Card.Shadings.clear:UIColor.clear
    ]
    
    
    func prepareForStart() {
        if cardButtons.count>=12 {
            for cardIndex in 0...12 {
                cardButtons[cardIndex].isHidden = false
                cardButtons[cardIndex].isEnabled = true
            }
        }
    }
    
    @IBOutlet var cardButtons: [UIButton]!
    @IBAction func touchCards(_ sender: UIButton) {
    }
    @IBAction func deal(_ sender: UIButton) {
    }
    @IBOutlet weak var score: UILabel!
}

extension Card {
    //MARK: Here to add or change exact view attributes for model attributes
    
    var shapeView: String {
        switch self.shape {
        case .diamond: return "▲"
        case .wave: return "■"
        case .oval: return "●"
        }
    }
    var colorAttribute: [NSAttributedString.Key:Any] {
        switch self.color {
        case .one: return [.foregroundColor: UIColor.systemRed]
        case .two: return [.foregroundColor: UIColor.systemBlue]
        case .three: return [.foregroundColor: UIColor.systemGreen]
        }
    }
    var shadingAttribute: [NSAttributedString.Key:Any] {
        switch self.shading {
        case .clear: return [.backgroundColor: UIColor.clear]
        case .solid: return [.backgroundColor: UIColor.systemYellow]
        case .stripped: return [.backgroundColor: UIColor.black]
        }
    }
    var attributesForString: [AnyHashable:Any] {
    return [colorAttribute,shadingAttribute].merged(mergeRule: {_,new in new})
    }
}

extension Array where Element == [AnyHashable:Any] {
    // func to merge array of dictionaries by some merging rule, passed as a closure. Used to merge several dictionaries with NSAttributedString attributes.
    func merged(mergeRule: (Any, Any) -> Any) -> [AnyHashable:Any] {
        return reduce([:],{partiallyMergedDict, dictToMerge in partiallyMergedDict.merging(dictToMerge, uniquingKeysWith: mergeRule)})
    }
}
