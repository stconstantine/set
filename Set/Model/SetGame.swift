//
//  SetGame.swift
//  Set
//
//  Created by Константин Стародубцев on 06.08.2020.
//  Copyright © 2020 Constantin Starodubtsev. All rights reserved.
//

import Foundation

class SetGame {
    private var deck = Deck()
    var canDeal: Bool {
        if deck.count<3 || cardsActive.count > showCardLimit-3 {
            return false
        }
        return true
    }
    var score: Int
    var showCardLimit: Int
    var cardsActive: [Card]
    var deckCount: Int {
        return deck.count
    }
    
    func draw() -> Card? {
        score += scoreValues[.drawCard] ?? 0
        return deck.draw()
    }
    func setMade(with cards:[Card]) -> Bool {
        
        var distinctNumbers = Set<Card.Numbers>()
        for theCard in cards {distinctNumbers.insert(theCard.number)}
        
        var distinctShapes = Set<Card.Shapes>()
        for theCard in cards {distinctShapes.insert(theCard.shape)}
        
        var distinctShadings = Set<Card.Shadings>()
        for theCard in cards {distinctShadings.insert(theCard.shading)}
        
        var distinctColors = Set<Card.Colors>()
        for theCard in cards {distinctColors.insert(theCard.color)}
        
        if ![distinctNumbers.count,
             distinctShapes.count,
             distinctShadings.count,
             distinctColors.count].contains(2) {
            score += scoreValues[.setMade] ?? 0
            return true
        } else {
            score += scoreValues[.setWrong] ?? 0
            return false
        }
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
    let scoreValues: [ScorableActions: Int] = [
        .gameStart: 10,
        .drawCard: -1,
        .setMade: 20,
        .setWrong: -5
    ]
    enum ScorableActions {
        case drawCard,setMade,selectCard,unselectCard,gameStart,setWrong
    }
    init(startWith numberOfCards: Int, totalShow limit: Int) {
        cardsActive = []
        showCardLimit = limit
        score = scoreValues[.gameStart] ?? 10
        for index in 0..<numberOfCards {
            guard let card = deck.draw() else {
                print ("Couldn't draw 12 card during game init. Drawed only \(index+1) cards from the deck and deck.draw returned nil")
                return
            }
            cardsActive.append(card)
        }
    }
}

