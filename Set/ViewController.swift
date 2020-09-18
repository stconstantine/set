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
    var cardViews: [UIView] = [SetCardView]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let grid = Grid(layout: .aspectRatio(0.75), frame: view.bounds)
        
        for cardIndex in 0..<grid.cellCount {
            cardViews.append(SetCardView(frame: grid[cardIndex]!))
            view.addSubview(cardViews[cardIndex])
        }
        
    }
}
