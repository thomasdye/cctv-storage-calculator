//
//  SignUpViewController.swift
//  CCTV Storage Calculator
//
//  Created by Thomas Dye on 4/15/20.
//  Copyright © 2020 Thomas Dye. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let accentColor: CGColor = UIColor(hue: 0.5694,
                                                saturation: 1,
                                                brightness: 0.97,
                                                alpha: 0.8).cgColor

    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleTextFields()

    }
    
    func styleTextFields() {
        
        let allTextFields: [UITextField] = [usernameTextField,
                                            passwordTextField]
        
        for textField in allTextFields {
            textField.borderStyle = .none
            let bottomLine = CALayer()
            
            bottomLine.frame = CGRect(x: 0,
                                      y: textField.frame.height - 10,
                                      width: textField.frame.width,
                                      height: 2)
            
            bottomLine.backgroundColor = accentColor
            textField.layer.addSublayer(bottomLine)
        }
    }
}
