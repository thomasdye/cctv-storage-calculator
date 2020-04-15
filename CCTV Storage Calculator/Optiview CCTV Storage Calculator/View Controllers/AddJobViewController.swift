//
//  AddJobViewController.swift
//  CCTV Storage Calculator
//
//  Created by Thomas Dye on 4/15/20.
//  Copyright © 2020 Thomas Dye. All rights reserved.
//

import UIKit

class AddJobViewController: UIViewController {
    @IBOutlet weak var jobNotesTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTextView()
    }
    
    func setupTextView() {
        jobNotesTextView.layer.borderColor = UIColor.lightGray.cgColor
        jobNotesTextView.layer.borderWidth = 1
        jobNotesTextView.layer.cornerRadius = 15.0
    }
    


}
