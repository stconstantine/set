//
//  Card.swift
//  Set
//
//  Created by Константин Стародубцев on 06.08.2020.
//  Copyright © 2020 Constantin Starodubtsev. All rights reserved.
//

import Foundation

struct Card {
    
    struct Thing {
        enum Shapes {case diamond, wave, oval}
        enum Shadings {case clear, stripped, solid}
        enum Colors {case one, two, three}
        
        var shape: Shapes
        var shading: Shadings
        var color: Colors
    }
    
    var number: Numbers
    var thing: Thing
    var isSelected: Bool = false
    var isMatched: Bool = false
 
    enum Numbers: Int {case one, two, three}
    
//    static func ==(lhs: Card, rhs: Card) -> Bool {
//        return lhs.identifier == rhs.identifier
//    }
    
}

