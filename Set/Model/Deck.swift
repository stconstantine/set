//
//  Deck.swift
//  Set
//
//  Created by Константин Стародубцев on 06.08.2020.
//  Copyright © 2020 Constantin Starodubtsev. All rights reserved.
//

import Foundation

struct Deck {
    private var cards = [Card]()
    var count: Int {
        return cards.count
    }
    mutating func draw() -> Card? {
        if cards.count > 0 {
            return cards.remove(at: cards.count.random)
        } else {
            return nil
        }
    }
    
    init() {
        for number in Card.Numbers.allCases {
            for shape in Card.Shapes.allCases {
                for shading in Card.Shadings.allCases {
                    for color in Card.Colors.allCases {
                        cards += [
                            Card(shape: shape,
                                 shading: shading,
                                 color: color,
                                 number: number
                            )]
                    }
                }
            }
        }
    }
}

extension Int {
    var random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(self)))
        } else {
            return 0
        }
    }
}

