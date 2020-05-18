//
//  ViewController.swift
//  DemoApp
//
//  Created by Soha Ahmed on 18/05/2020.
//  Copyright © 2020 Soha Ahmed. All rights reserved.
//

import UIKit
import DemoFramework
class ViewController: UIViewController {

    @IBOutlet weak var out: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let x = testwrapperheader().addtestobj(12,num2:3);
        out.text = (x as NSNumber).stringValue


}

}
