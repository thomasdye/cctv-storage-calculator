//
//  JobDetailViewCellViewController.swift
//  CCTV Storage Calculator
//
//  Created by Thomas Dye on 4/29/20.
//  Copyright © 2020 Thomas Dye. All rights reserved.
//

import UIKit

class JobDetailViewCellViewController: UIViewController {
    @IBOutlet weak var jobNameTextField: UITextField!
    @IBOutlet weak var customerNameTextField: UITextField!
    @IBOutlet weak var customerPhoneNumberTextField: UITextField!
    @IBOutlet weak var systemTypeSegmentedController: UISegmentedControl!
    @IBOutlet weak var numberOfCamerasTextField: UITextField!
    @IBOutlet weak var totalStorageLabel: UILabel!
    @IBOutlet weak var jobNotesTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
