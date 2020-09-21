//
//  Card.swift
//  Set
//
//  Created by Константин Стародубцев on 06.08.2020.
//  Copyright © 2020 Constantin Starodubtsev. All rights reserved.
//

import Foundation

struct Card: Equatable {
    enum Numbers: Int, CaseIterable {case one=1, two, three}
    enum Shapes: CaseIterable {case diamond, wave, oval}
    enum Shadings: CaseIterable {case clear, stripped, solid}
    enum Colors: CaseIterable {case one, two, three}
    
    var shape: Shapes
    var shading: Shadings
    var color: Colors
    var number: Numbers
    var isSelected: Bool = false
    var isMatched: Bool?
}
