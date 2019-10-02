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
    
    // Adding outlets
    @IBOutlet weak var totalStorageLabel: UILabel!
    @IBOutlet weak var totalCamerasTextField: UITextField!
    @IBOutlet weak var megapixelSelectedSegementedControl: UISegmentedControl!
    @IBOutlet weak var totalDaysTextField: UITextField!
    @IBOutlet weak var totalHoursTextField: UITextField!
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var totalCamerasStepper: UIStepper!
    @IBOutlet weak var motionDetectSegmentedControl: UISegmentedControl!
    @IBOutlet weak var totalDaysStepper: UIStepper!
    @IBOutlet weak var totalHoursStepper: UIStepper!
    
    // Defining variables and constants
    var totalCameras: Int = 0
    var resolution: Int = 0
    var camBitrate: Int = 2048
    var totalDays: Int = 0
    var totalHours: Int = 0
    var motionDetectOn: Bool = false
    var isGigabyte: Bool = true
    var storageGB: Double = 0
    var storageTB: Double = 0.0
    let convertSecondsToHour: Int = 3600
    var accentColor: UIColor = UIColor(hue: 0.5694, saturation: 1, brightness: 0.93, alpha: 1.0)
    
    // CameraBitrate enum to use in calculation
    enum CameraBitrate: Int {
        case twoMegapixel = 2048
        case threeMegapixel = 3020
        case fourMegapixel = 4096
        case fiveMegapixel = 7500
        case eightMegapixel = 12_000
    }

    // View loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()

    }
    
    // Calculate button tapped
    @IBAction func calculateButtonTapped(_ sender: UIButton) {
        
        retreiveValues()
        
        storageGB = Double(((camBitrate / 8) * convertSecondsToHour * totalHours * totalCameras * totalDays) / 1_000_000).rounded(.up)
        
        if motionDetectOn == true {
            storageGB = storageGB / 2
        }
        
        if storageGB >= 1000 {
            storageTB = (storageGB / 1000).rounded(.up)
            
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
    
    @IBAction func megapixelSegmentedControlPressed(_ sender: UISegmentedControl) {
        
        switch megapixelSelectedSegementedControl.selectedSegmentIndex
         {
        case 0:
            camBitrate = CameraBitrate.twoMegapixel.rawValue
        case 1:
            camBitrate = CameraBitrate.threeMegapixel.rawValue
        case 2:
            camBitrate = CameraBitrate.fourMegapixel.rawValue
        case 3:
            camBitrate = CameraBitrate.fiveMegapixel.rawValue
        case 4:
            camBitrate = CameraBitrate.eightMegapixel.rawValue
        default:
            break
         }
    }
    
    func setup() {
        
        setupText()
        setupSteppers()
        setupAccentColors()

    }
    
    func disableTextFields(named: UITextField) {
        named.isEnabled = false
    }
    
    // Set variables equal to text fields
    func retreiveValues() {
        totalHours = Int(totalHoursTextField.text!)!
        totalCameras = Int(totalCamerasTextField.text!)!
        totalDays = Int(totalDaysTextField.text!)!
    }
    
    func setupAccentColors() {
        
        totalHoursStepper.setDecrementImage(totalHoursStepper.decrementImage(for: .normal), for: .normal)
        totalHoursStepper.setIncrementImage(totalHoursStepper.incrementImage(for: .normal), for: .normal)
        totalDaysStepper.setDecrementImage(totalDaysStepper.decrementImage(for: .normal), for: .normal)
        totalDaysStepper.setIncrementImage(totalDaysStepper.incrementImage(for: .normal), for: .normal)
        totalCamerasStepper.setDecrementImage(totalCamerasStepper.decrementImage(for: .normal), for: .normal)
        totalCamerasStepper.setIncrementImage(totalCamerasStepper.incrementImage(for: .normal), for: .normal)
    
        
        
        totalCamerasStepper.tintColor = accentColor
        totalDaysStepper.tintColor = accentColor
        totalHoursStepper.tintColor = accentColor
    }
    
    func setupText() {
        // text field and label setup
        totalCamerasTextField.text = "8"
        totalDaysTextField.text = "30"
        totalHoursTextField.text = "24"
        totalStorageLabel.text = "0 TB"
        
        // disable text fields so you can't select them
        disableTextFields(named: totalCamerasTextField)
        disableTextFields(named: totalDaysTextField)
        disableTextFields(named: totalHoursTextField)

    }
    
    func setupSteppers() {
        // totalCamerasStepper setup
        totalCamerasStepper.value = 8
        totalCamerasStepper.minimumValue = 1
        
        // totalDaysStepper setup
        totalDaysStepper.value = 30
        totalDaysStepper.minimumValue = 1
        
        // totalHoursStepper setup
        totalHoursStepper.value = 24
        totalHoursStepper.maximumValue = 24
        totalHoursStepper.wraps = true
        totalHoursStepper.minimumValue = 1
    }
}

