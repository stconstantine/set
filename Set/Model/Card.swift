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
        enum Shapes: CaseIterable {case diamond, wave, oval}
        enum Shadings: CaseIterable {case clear, stripped, solid}
        enum Colors: CaseIterable {case one, two, three}
        var shape: Shapes
        var shading: Shadings
        var color: Colors
    }
    enum Numbers: CaseIterable {case one, two, three}
    var thing: Thing
    var isSelected: Bool = false
    var isMatched: Bool = false
    var number: Numbers
}
