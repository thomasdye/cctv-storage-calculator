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
    
    @IBOutlet weak var totalStorageLabel: UILabel!
    @IBOutlet weak var totalCamerasTextField: UITextField!
    @IBOutlet weak var bitrateTextField: UITextField!
    @IBOutlet weak var totalDaysTextField: UITextField!
    @IBOutlet weak var totalHoursTextField: UITextField!
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var totalCamerasStepper: UIStepper!
    @IBOutlet weak var motionDetectSegmentedControl: UISegmentedControl!
    @IBOutlet weak var totalDaysStepper: UIStepper!
    @IBOutlet weak var totalHoursStepper: UIStepper!
    
    var totalCameras: Int = 0
    var resolution: Int = 2
    var camBitrate: Int = 1024
    var totalDays: Int = 0
    var totalHours: Int = 0
    let convertSecondsToHour: Int = 3600
    var motionDetectOn: Bool = true
    var isGigabyte: Bool = true
    var storageGB: Int = 0
    var storageTB: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()

    }

    @IBAction func calculateButtonTapped(_ sender: UIButton) {
        
        camBitrate = Int(bitrateTextField.text!)!
        totalHours = Int(totalHoursTextField.text!)!
        totalCameras = Int(totalCamerasTextField.text!)!
        totalDays = Int(totalDaysTextField.text!)!
        
        storageGB = ((camBitrate / 8) * convertSecondsToHour * totalHours * totalCameras * totalDays)
        
        storageGB = storageGB / 1_000_000
        
        if motionDetectOn == true {
            storageGB = storageGB / 2
        }
        
        if storageGB >= 1000 {
          storageTB = storageGB / 1000
            
          totalStorageLabel.text = "\(storageTB) TB"
        } else {
            totalStorageLabel.text = "\(storageGB) GB"
        }
    }
    
    @IBAction func totalCamerasStepperPressed(_ sender: UIStepper) {
        
        totalCamerasTextField.text = Int(sender.value).description
    }
    
    @IBAction func totalDaysStepperPressed(_ sender: UIStepper) {
        
        totalDaysTextField.text = Int(sender.value).description
    }
    
    @IBAction func totalHoursStepperPressed(_ sender: UIStepper) {
        
        totalHoursTextField.text = Int(sender.value).description
    }
    
    @IBAction func motionDetectSegementedControlPressed(_ sender: UISegmentedControl) {
        
        switch motionDetectSegmentedControl.selectedSegmentIndex
         {
         case 0:
             motionDetectOn = false
         case 1:
             motionDetectOn = true
         default:
             break
         }
    }
    
    func setup() {
        totalCamerasTextField.text = "1"
        totalDaysTextField.text = "30"
        totalHoursTextField.text = "24"
        totalCamerasStepper.value = 1
        totalDaysStepper.value = 30
        totalHoursStepper.value = 24
        totalHoursStepper.maximumValue = 24
        totalHoursStepper.minimumValue = 1
        totalStorageLabel.text = ""
    }
}

