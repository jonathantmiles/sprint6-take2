//
//  ViewController.swift
//  sprint6-retake
//
//  Created by Jonathan T. Miles on 10/16/18.
//  Copyright © 2018 Jonathan T. Miles. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        resetButton.customView?.alpha = 0.0
    }

    @IBAction func resetLock(_ sender: Any) {
    
    }
    @IBOutlet weak var resetButton: UIBarButtonItem!
    @IBOutlet weak var lockControl: LockControl!
    
}

