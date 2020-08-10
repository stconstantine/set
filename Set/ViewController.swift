//
//  ViewController.swift
//  Set
//
//  Created by Константин Стародубцев on 06.08.2020.
//  Copyright © 2020 Constantin Starodubtsev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBAction func touchCards(_ sender: UIButton) {
    }
    
    @IBAction func deal(_ sender: UIButton) {
    }
    
    @IBOutlet weak var score: UILabel!
}

