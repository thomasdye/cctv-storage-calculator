//
//  ViewController.swift
//  Optiview CCTV Storage Calculator
//
//  Created by Casualty on 10/1/19.
//  Copyright © 2019 Thomas Dye. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    

    @IBOutlet weak var storageTotalLabel: UILabel!
    @IBOutlet weak var totalCamerasTextField: UITextField!
    @IBOutlet weak var bitrateTextField: UITextField!
    @IBOutlet weak var numberOfDaysTextField: UITextField!
    @IBOutlet weak var recordingHoursTextField: UITextField!
    @IBOutlet weak var calculateButton: UIButton!
    
    var totalCams: Int = 0
    var resolution: Int = 2
    var camBitrate: Int = 1024
    var totalDays: Int = 0
    var recordingHours: Int = 0
    let convertSecondsToHour: Int = 3600
    var motionDetectOn: Bool = true
    var isGigabyte: Bool = true
    var storageGB: Int = 0
    var storageTB: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func calculateButtonTapped(_ sender: UIButton) {
        
        camBitrate = Int(bitrateTextField.text!)!
        recordingHours = Int(recordingHoursTextField.text!)!
        totalCams = Int(totalCamerasTextField.text!)!
        totalDays = Int(numberOfDaysTextField.text!)!
        
        storageGB = ((camBitrate / 8) * convertSecondsToHour * recordingHours * totalCams * totalDays)
        
        storageGB = storageGB / 1_000_000
        
        if storageGB >= 1000 {
          storageTB = storageGB / 1000
            
          storageTotalLabel.text = "\(storageTB) TB"
        } else {
            storageTotalLabel.text = "\(storageGB) GB"
        }
    }
}

