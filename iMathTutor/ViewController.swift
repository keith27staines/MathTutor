//
//  ViewController.swift
//  iMathTutor
//
//  Created by Keith on 12/08/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var unitCircleView: UnitCircleView!
    
    @IBOutlet weak var angleSlider: UISlider!
    
    @IBAction func changeAngle(_ sender: UISlider) {
        unitCircleView.thetaDegrees = Double(Int(angleSlider.value))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        unitCircleView.thetaDegrees = 0.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

