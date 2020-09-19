//
//  SetFieldView.swift
//  Set
//
//  Created by Константин Стародубцев on 19.09.2020.
//  Copyright © 2020 Constantin Starodubtsev. All rights reserved.
//

import UIKit

class SetFieldView: UIView {

    private var grid = Grid(layout: .aspectRatio(0.75))
    private(set) var cardViews = [SetCardView]() {
        didSet {
            updateGrid()
        }
    }
        
    var count: Int {
        grid.cellCount = cardViews.count
        return cardViews.count
    }
    
    func add(_ cardView: SetCardView) {
        cardViews.append(cardView)
        self.addSubview(cardView)
        updateGrid()
    }
    
    func remove(cardViewAt indexToRemove: Int) -> SetCardView? {
        cardViews[indexToRemove].removeFromSuperview()
        return cardViews.remove(at: indexToRemove)
    }
    func shuffleCards() {
        cardViews.shuffle()
        updateGrid()
    }
    
    private func updateGrid() {
        for cardIndex in 0..<count {
            let cardView = cardViews[cardIndex] as UIView
            guard let gridCell = grid[cardIndex] else {print("couldn't get cell"); return}
            cardView.frame = gridCell
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        grid.frame = bounds
        updateGrid()
    }
    
}
