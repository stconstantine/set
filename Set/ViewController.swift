//
//  ViewController.swift
//  Set
//
//  Created by Константин Стародубцев on 06.08.2020.
//  Copyright © 2020 Constantin Starodubtsev. All rights reserved.
//

import UIKit
import CoreGraphics

class ViewController: UIViewController {

    let game = SetGame(startWith: 12, totalShow: 81)
    override func viewDidLoad() {
        super.viewDidLoad()
        putCardOnATable()
    }
    func putCardOnATable() {
        guard let card = game.draw() else {return}
        field.add(card.view)
    }
    
    @IBOutlet weak var field: SetFieldView!
    @IBAction func addCardButton(_ sender: Any) {
        putCardOnATable()
    }
    
    @IBAction func removeLast(_ sender: Any) {
        guard field.count>0 else { return }
        field.remove(cardViewAt: field.count-1)
    }
    
    @IBAction func flipCard(_ sender: Any) {
        field.shuffleCards()
    }
}

extension Card {
    var view: SetCardView {
        let cardView = SetCardView()
        
        switch self.color {
        case .one: cardView.itemColor = .one
        case .two: cardView.itemColor = .two
        case .three: cardView.itemColor = .three
        }
                
        switch self.shading {
        case .clear: cardView.itemShading = .clear
        case .solid: cardView.itemShading = .solid
        case .stripped: cardView.itemShading = .stripped
        }
        
        switch self.shape {
        case .diamond: cardView.itemShape = .diamond
        case .oval: cardView.itemShape = .oval
        case .wave: cardView.itemShape = .squiggle
        }
        
        cardView.itemsCount = self.number.rawValue
        
        return cardView
    }
}
