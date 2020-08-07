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
    private func printCard(_ theCard: Card) {
        print("Number: \(theCard.number), shape: \(theCard.thing.shape), shading: \(theCard.thing.shading), color: \(theCard.thing.color)")
    }
    
    var deck = Deck()
    
    let game = SetGame()
    
    @IBAction func touchDraw(_ sender: UIButton) {

        print("testCardsNotSet is set (must be false): \(game.setMade(with: SetGame.testCardsNotSet))")
        print("testCardsSet is set (must be true): \(game.setMade(with: SetGame.testCardsSet))")
    }
}
