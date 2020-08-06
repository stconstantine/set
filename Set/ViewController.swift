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
        cards.append(theCard)
        print (type(of: cards))
        
    }
    
    var cards = [Card]()
    
    let theCard = Card (
        number: .one,
        thing: Card.Thing (
            shape: .diamond,
            shading: .solid,
            color: .two
        ))
    
}

