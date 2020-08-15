//
//  SetGame.swift
//  Set
//
//  Created by Константин Стародубцев on 06.08.2020.
//  Copyright © 2020 Constantin Starodubtsev. All rights reserved.
//

import Foundation

struct SetGame {
    private(set) var deck = Deck()
    var cardsDrawn: [Card]?
    
    func setMade(with cards:[Card]) -> Bool {
        
        var distinctNumbers = Set<Card.Numbers>()
        for theCard in cards {distinctNumbers.insert(theCard.number)}
        
        var distinctShapes = Set<Card.Shapes>()
        for theCard in cards {distinctShapes.insert(theCard.shape)}
        
        var distinctShadings = Set<Card.Shadings>()
        for theCard in cards {distinctShadings.insert(theCard.shading)}
        
        var distinctColors = Set<Card.Colors>()
        for theCard in cards {distinctColors.insert(theCard.color)}

        return ![distinctNumbers.count,
                distinctShapes.count,
                distinctShadings.count,
                distinctColors.count].contains(2)
    }
    
    static var testCardsSet: [Card] {
        return [
            Card(
                shape: .diamond,
                shading: .clear,
                color: .one,
                number: .one),
            Card(
                shape: .oval,
                shading: .clear,
                color: .one,
                number: .one),
            Card(
                shape: .wave,
                shading: .clear,
                color: .one,
                number: .one)]
    }
    static var testCardsNotSet: [Card] {
        return [
            Card(
                shape: .diamond,
                shading: .clear,
                color: .one,
                number: .one),
            Card(
                shape: .diamond,
                shading: .solid,
                color: .one,
                number: .one),
            Card(
                shape: .wave,
                shading: .clear,
                color: .one,
                number: .one)]
    }
}
