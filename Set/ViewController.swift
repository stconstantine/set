//
//  ViewController.swift
//  Set
//
//  Created by Константин Стародубцев on 06.08.2020.
//  Copyright © 2020 Constantin Starodubtsev. All rights reserved.
//

import UIKit
import CoreGraphics

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardButtons.forEach {$0.layer.cornerRadius = 5}
        updateViewFromModel()
    }
    func updateViewFromModel() {
        dealThreeButton.isEnabled = game.canDeal
        showActualCards()
        score.text = "Score: \(game.score)"
        cardsInDeck.text = "Cards in deck: \(game.deckCount)"
    }
    
    lazy var game = SetGame(
        startWith: (cardButtons.count / 2),
        totalShow: cardButtons.count
    )
    
    var cardsSelected = [UIButton]()
    
    @IBAction func restartGame(_ sender: Any) {
        game = SetGame(
            startWith: (cardButtons.count / 2),
            totalShow: cardButtons.count
        )
        updateViewFromModel()
    }
    
    @IBOutlet weak var dealThreeButton: UIButton!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var cardsInDeck: UILabel!
    @IBOutlet var cardButtons: [UIButton]!
    @IBAction func touchCard(_ sender: UIButton) {
        if !sender.isOutlined {
            cardsSelected.append(sender)
            switch cardsSelected.count {
            case 3:
                setOutlined(true, for: sender)
                checkForSet(for: cardsSelected)
                cardsSelected.forEach {unselect($0)}
            case ..<3:
                setOutlined(true, for: sender)
            default:
                cardsSelected.forEach {unselect($0)}
            }
        } else {
            unselect(sender)
        }
    }
    @IBAction func dealThreeCards(_ sender: UIButton) {
        for _ in 1...3 {
            if let card = game.draw() {
                game.cardsActive += [card]
            }
        }
        updateViewFromModel()
    }
    
    func blinkView(with backgroundColor: UIColor) {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.backgroundColor = backgroundColor
        })
        UIView.animate(withDuration: 0.2, animations: {
            self.view.backgroundColor = .systemBackground
        })
    }
    
    private func checkForSet(for buttonsWithCards: [UIButton]) {
        var cardsToCheck = [Card]()
        for button in buttonsWithCards {
            if let cardFound = cardOf(current: button) {
                cardsToCheck += [cardFound]
            } else {
                print("func checkForSet: cardOf returned nil — could not match button and card")
            }
        }
        
        if game.setMade(with: cardsToCheck) {
            blinkView(with: .systemGreen)
            cardsToCheck.forEach {
                guard let indexToRemove = game.cardsActive.firstIndex(of: $0) else {return}
                game.cardsActive.remove(at: indexToRemove)
            }
            
        } else {
            blinkView(with: .systemRed)
        }
        updateViewFromModel()
    }
    
    private func cardOf(current buttonWithCard: UIButton) -> Card? {
        guard let index = cardButtons.firstIndex(of: buttonWithCard) else {return nil}
        return game.cardsActive[index]
    }
    
    private func setOutlined(_ needToMakeOutlined: Bool, for button: UIButton) {
        if needToMakeOutlined {
            button.layer.borderWidth = 3
            button.layer.borderColor = UIColor.systemRed.cgColor
        } else {
            button.layer.borderWidth = 0
            button.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    private func showActualCards() {
        //TODO: Make it better
        for cardOutletIndex in cardButtons.indices {
            if cardOutletIndex < game.cardsActive.count {
                showCard(game.cardsActive[cardOutletIndex], on: cardButtons[cardOutletIndex])
            } else {
                hideCard(on: cardButtons[cardOutletIndex])
            }
        }
                
    }
    private func unselect(_ button: UIButton) {
        setOutlined(false, for: button)
        cardsSelected.removeAll(where: {$0 == button})
    }
    
    private func showCard (_ card: Card, on button: UIButton) {
        var cardViewText = ""
        for _ in 1...card.number.rawValue {
            cardViewText += card.shapeView
        }
        let cardViewAttributedText = NSAttributedString(
            string: cardViewText,
            attributes: card.attributesForString as? [NSAttributedString.Key : Any])
        button.setAttributedTitle(cardViewAttributedText, for: .normal)
        button.isEnabled = true
        button.backgroundColor = .systemFill
    }
    private func hideCard(on button: UIButton) {
        button.backgroundColor = .clear
        button.setAttributedTitle(NSAttributedString(string: ""), for: .disabled)
        button.setTitle("", for: .disabled)
        button.isEnabled = false
    }
}

extension Card {
    //MARK: this extension is to add or change exact view attributes for model attributes
    
    var shapeView: String {
        switch self.shape {
        case .diamond: return "▲"
        case .wave: return "■"
        case .oval: return "●"
        }
    }
    var colorAttribute: [NSAttributedString.Key:Any] {
        switch self.color {
        case .one: return [.foregroundColor: UIColor.systemRed]
        case .two: return [.foregroundColor: UIColor.systemBlue]
        case .three: return [.foregroundColor: UIColor.systemGreen]
        }
    }
    var shadingAttribute: [NSAttributedString.Key:Any] {
        switch self.shading {
        case .clear: return [.backgroundColor: UIColor.clear]
        case .solid: return [.backgroundColor: UIColor.systemYellow]
        case .stripped: return [.backgroundColor: UIColor.black]
        }
    }
    var attributesForString: [AnyHashable:Any] {
        let commonAttribute: [NSAttributedString.Key:Any] = [
            .font: UIFont.systemFont(ofSize: 20)
        ]
        return [commonAttribute,colorAttribute,shadingAttribute].merged(mergeRule: {_,new in new})
    }
}
extension Array where Element == [AnyHashable:Any] {
    // func to merge array of dictionaries by some merging rule, passed as a closure. Used to merge several dictionaries with NSAttributedString attributes.
    func merged(mergeRule: (Any, Any) -> Any) -> [AnyHashable:Any] {
        return reduce([:],{partiallyMergedDict, dictToMerge in partiallyMergedDict.merging(dictToMerge, uniquingKeysWith: mergeRule)})
    }
}
extension UIButton {
    var isOutlined:Bool {
        return self.layer.borderWidth > 0
    }
}
