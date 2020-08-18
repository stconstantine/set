//
//  SetGame.swift
//  Set
//
//  Created by Константин Стародубцев on 06.08.2020.
//  Copyright © 2020 Constantin Starodubtsev. All rights reserved.
//

import Foundation

struct SetGame {
    var deck = Deck()
    var canDealThree = true
    var score = 10
    var cardsShown: [Card]
    
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

    init(startWith numberOfCards: Int) {
        cardsShown = []
        for index in 0..<numberOfCards {
            guard let card = deck.draw() else {
                print ("Couldn't draw 12 card during game init. Drawed only \(index+1) cards from the deck and deck.draw returned nil")
                return
            }
            cardsShown.append(card)
        }
    }
}
