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
    @IBOutlet weak var totalCamerasStepper: UIStepper!
    @IBOutlet weak var motionDetectSegmentedControl: UISegmentedControl!
    @IBOutlet weak var totalDaysStepper: UIStepper!
    @IBOutlet weak var totalHoursStepper: UIStepper!
    @IBOutlet weak var compressionSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var framesPerSecondSlider: UISlider!
    @IBOutlet weak var framesPerSecondLabel: UILabel!
    
    // Defining variables and constants
    var totalCameras: Int = 0
    var camBitrate: Int = FrameSize.twoMegapixel.rawValue
    var totalDays: Int = 30
    var totalHours: Int = 24
    var motionDetectOn: Bool = false
    var storageGB: Double = 0
    var storageTB: Double = 0.0
    var compression: Double = 1.0
    var framesPerSecond: Int = 7
    let convertSecondsToHour: Int = 3600
    var accentColor: UIColor = UIColor(hue: 0.5694, saturation: 1, brightness: 0.93, alpha: 1.0)
    
    // CameraBitrate enum to use in calculation
    enum FrameSize: Int {
        case twoMegapixel = 15
        case threeMegapixel = 20
        case fourMegapixel = 25
        case fiveMegapixel = 30
        case eightMegapixel = 50
    }

    // View loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
        calculateStorage()

    }
    
    // Calculate storage
    
    @IBAction func totalCamerasStepperPressed(_ sender: UIStepper) {
        
        totalCamerasTextField.text = Int(sender.value).description
        calculateStorage()
    }
    
    @IBAction func totalDaysStepperPressed(_ sender: UIStepper) {
        
        totalDaysTextField.text = Int(sender.value).description
        calculateStorage()
    }
    
    @IBAction func totalHoursStepperPressed(_ sender: UIStepper) {
        
        totalHoursTextField.text = Int(sender.value).description
        calculateStorage()
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
         calculateStorage()
    }
    
    @IBAction func megapixelSegmentedControlPressed(_ sender: UISegmentedControl) {
        
        switch megapixelSelectedSegementedControl.selectedSegmentIndex
         {
        case 0:
            camBitrate = FrameSize.twoMegapixel.rawValue
        case 1:
            camBitrate = FrameSize.threeMegapixel.rawValue
        case 2:
            camBitrate = FrameSize.fourMegapixel.rawValue
        case 3:
            camBitrate = FrameSize.fiveMegapixel.rawValue
        case 4:
            camBitrate = FrameSize.eightMegapixel.rawValue
        default:
            break
         }
        calculateStorage()
    }
    
    @IBAction func compressionSegmentedControlPressed(_ sender: UISegmentedControl) {

        switch compressionSegmentedControl.selectedSegmentIndex
         {
        case 0:
            compression = 1.0
        case 1:
            compression = 1.56
        default:
            break
         }
        calculateStorage()
    }
    
    @IBAction func framesPerSecondSliderChanged(_ sender: UISlider) {
        calculateStorage()
        framesPerSecond = Int(sender.value)
        framesPerSecondLabel.text = "FPS: \(framesPerSecond)"
        
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
        
        totalHoursStepper.setDecrementImage(
            totalHoursStepper.decrementImage(for: .normal), for: .normal)
        totalHoursStepper.setIncrementImage(
            totalHoursStepper.incrementImage(for: .normal), for: .normal)
        totalDaysStepper.setDecrementImage(
            totalDaysStepper.decrementImage(for: .normal), for: .normal)
        totalDaysStepper.setIncrementImage(
            totalDaysStepper.incrementImage(for: .normal), for: .normal)
        totalCamerasStepper.setDecrementImage(
            totalCamerasStepper.decrementImage(for: .normal), for: .normal)
        totalCamerasStepper.setIncrementImage(
            totalCamerasStepper.incrementImage(for: .normal), for: .normal)
    
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
    
    func calculateStorage() {
        // Retreive values from text fields
         retreiveValues()
         
         // Calculate total frame size per second
         // ex: 7 (FPS) * 50KB (twoMegapixel) = 350KB/s
         let totalFrameSizePerSecond = (framesPerSecond * camBitrate)
         
         // ex 350KB/s * 3600 (seconds/hour) = 1_260_000KB/hr
         let totalSizePerHour = totalFrameSizePerSecond * 3600
         
         // Calculate storage in GB
         // ex (1,260,000 * 30 * 24) = 907,200,000 / 1,000,000
         storageGB = Double((totalSizePerHour * totalDays * totalHours) / 1_000_000)
         
         // Multiplying total storage calculated per camera times the total number of cameras
         storageGB = storageGB * Double(totalCameras)
         
         // Divide storage by compression
         storageGB = storageGB / compression
         
         // If motion detect is on, divide total GB by 1.35
         if motionDetectOn == true {
             storageGB = storageGB / 2.0
         }
         
         // Then, if storage in GB is greater than 1000GB (1TB), calculate storage in TB
         if storageGB >= 1000 {
             storageTB = storageTB / compression
             storageTB = (storageGB / 1000).rounded(.up)
             
           totalStorageLabel.text = "\(storageTB) TB"
         } else {
             totalStorageLabel.text = "\(storageGB) GB"
         }
    }
}

