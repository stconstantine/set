//
//  ViewController.swift
//  Set
//
//  Created by Константин Стародубцев on 06.08.2020.
//  Copyright © 2020 Constantin Starodubtsev. All rights reserved.
//

import UIKit
//import CoreGraphics

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        addFieldRecognizers()
        deal3MoreCards(self)
    }
    
    let game = SetGame(startWith: 12, totalShow: 81)
    @IBOutlet weak var field: SetFieldView!
    
    @objc private func handleSwipe(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            deal3MoreCards(sender)
        }
    }
    @objc private func handleRotate(_ sender: UIRotationGestureRecognizer) {
        if sender.state == .ended, field.cardViews.count>1 {
            field.shuffleCards()
        }
    }
    @objc private func handleTapOnCard(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let cardView = sender.view as? SetCardView
            if cardView?.status == .selected {
                cardView?.status = .default
            } else {
                cardView?.status = .selected
            }
        }
    }
    
    private func addFieldRecognizers() {
        let swipeRecognizer = UISwipeGestureRecognizer(target: self,
                                                       action: #selector (self.handleSwipe(_:)))
        let rotateRecognizer = UIRotationGestureRecognizer(target: self,
                                                            action: #selector (self.handleRotate(_:)))
        swipeRecognizer.numberOfTouchesRequired = 1
        swipeRecognizer.direction = .up
        
        field.addGestureRecognizer(swipeRecognizer)
        field.addGestureRecognizer(rotateRecognizer)
    }
    private func addTapRecognizer(to cardView: SetCardView) {
        let recognizer = UITapGestureRecognizer(target: self,
                                                action: #selector (self.handleTapOnCard(_:)))
        recognizer.numberOfTapsRequired=1
        recognizer.numberOfTouchesRequired=1
        cardView.addGestureRecognizer(recognizer)
    }
    private func putCardOnATable() {
        guard let card = game.draw() else {return}
        let cardView = card.view
        addTapRecognizer(to: cardView)
        field.add(cardView)
    }
    func deal3MoreCards(_ sender: Any) {
        for _ in 1...3 {
            putCardOnATable()
        }
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
