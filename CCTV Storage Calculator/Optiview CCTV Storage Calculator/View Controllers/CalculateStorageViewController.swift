//
//  ViewController.swift
//  Optiview CCTV Storage Calculator
//
//  Created by Casualty on 10/1/19.
//  Copyright © 2019 Thomas Dye. All rights reserved.
//

import UIKit
import Foundation

class CalculateStorageViewController: UIViewController {
    
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
    @IBOutlet weak var audioSegmentedControl: UISegmentedControl!
    
    // Defining variables and constants
    var totalCameras: Int = 0
    var camBitrate: Int = FrameSize.twoMegapixel.rawValue
    var totalDays: Int = 30
    var totalHours: Int = 24
    var motionDetectOn: Bool = false
    var audioOn: Bool = false
    var storageGB: Double = 0
    var storageTB: Double = 0.0
    var compression: Double = 1.0
    var framesPerSecond: Int = 7
    let convertSecondsToHour: Int = 3600
    let optiviewAccentColor: UIColor = UIColor(hue: 0.5889,
                                               saturation: 1,
                                               brightness: 0.91,
                                               alpha: 1.0)
    let lightOptiviewAccentColor: UIColor = UIColor(hue: 0.5694,
                                                    saturation: 1,
                                                    brightness: 0.97,
                                                    alpha: 1.0)
    
    // CameraBitrate enum to use in calculation
    enum FrameSize: Int {
        case twoMegapixel = 15
        case threeMegapixel = 20
        case fourMegapixel = 25
        case fiveMegapixel = 30
        case eightMegapixel = 50
    }

    // View loaded. Call setup and calculateStorage functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
        calculateStorage()
    }
    
    // Total cameras stepper changed
    @IBAction func totalCamerasStepperPressed(_ sender: UIStepper) {
        
        totalCamerasTextField.text = Int(sender.value).description
        calculateStorage()
    }
    
    // Audio selected segment changed
    @IBAction func audioSegmentedControlPressed(_ sender: UISegmentedControl) {
        
        switch audioSegmentedControl.selectedSegmentIndex
         {
         case 0:
             audioOn = false
             audioSegmentedControl.selectedSegmentTintColor = .none
         case 1:
             audioOn = true
             audioSegmentedControl.selectedSegmentTintColor = lightOptiviewAccentColor
         default:
             break
         }
         calculateStorage()
    }
    
    // Total days stepper changed
    @IBAction func totalDaysStepperPressed(_ sender: UIStepper) {
        
        totalDaysTextField.text = Int(sender.value).description
        calculateStorage()
    }
    
    // Total hours stepper changed
    @IBAction func totalHoursStepperPressed(_ sender: UIStepper) {
        
        totalHoursTextField.text = Int(sender.value).description
        calculateStorage()
    }
    
    // Motion detect selected segment changed
    @IBAction func motionDetectSegementedControlPressed(_ sender: UISegmentedControl) {
        
        switch motionDetectSegmentedControl.selectedSegmentIndex
         {
         case 0:
             motionDetectOn = false
             motionDetectSegmentedControl.selectedSegmentTintColor = .none
         case 1:
             motionDetectOn = true
             motionDetectSegmentedControl.selectedSegmentTintColor = lightOptiviewAccentColor
         default:
             break
         }
         calculateStorage()
    }
    
    // Megapixel selected segment changed
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
    
    // Compression selected segment changed
    @IBAction func compressionSegmentedControlPressed(_ sender: UISegmentedControl) {

        switch compressionSegmentedControl.selectedSegmentIndex
         {
        case 0:
            compression = 1.0
            compressionSegmentedControl.selectedSegmentTintColor = .none
        case 1:
            compression = 1.30
            compressionSegmentedControl.selectedSegmentTintColor = lightOptiviewAccentColor
        default:
            break
         }
        calculateStorage()
    }
    
    // FPS slider changed
    @IBAction func framesPerSecondSliderChanged(_ sender: UISlider) {
        calculateStorage()
        framesPerSecond = Int(sender.value)
        framesPerSecondLabel.text = "FPS: \(framesPerSecond)"
        
    }
    
    // Create setup function for easier editing later
    func setup() {
        
        setupText()
        setupSteppers()
        setupAccentColors()
    }
    
    // Create function to disable text fields
    func disableTextFields(named: UITextField) {
        named.isEnabled = false
    }
    
    // Set variables equal to text fields
    func retreiveValues() {
        totalHours = Int(totalHoursTextField.text!)!
        totalCameras = Int(totalCamerasTextField.text!)!
        totalDays = Int(totalDaysTextField.text!)!
    }
    
    // Setup accent colors
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
    
        totalCamerasStepper.tintColor = optiviewAccentColor
        totalDaysStepper.tintColor = optiviewAccentColor
        totalHoursStepper.tintColor = optiviewAccentColor
        framesPerSecondSlider.tintColor = optiviewAccentColor
        framesPerSecondSlider.thumbTintColor = optiviewAccentColor
        framesPerSecondSlider.thumbImage(for: .normal)
        megapixelSelectedSegementedControl.selectedSegmentTintColor = lightOptiviewAccentColor
    }
    
    // Setup text fields
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
    
    // Setup steppers
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
    
    // Create calculate storage function
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
            storageGB = storageGB / 1.35
            
         }
        
         // If audio is on, multiply total GB by 1.02
         if audioOn == true {
            storageGB = storageGB * 1.02
            motionDetectSegmentedControl.tintColor = .clear
            
         }
         
         // Then, if storage in GB is greater than 1000GB (1TB), calculate storage in TB
         if storageGB >= 1000 {
             storageTB = storageTB / compression
             storageTB = (storageGB / 1000).rounded(.up)
             
           totalStorageLabel.text = "\(storageTB) TB"
         } else {
            storageGB = storageGB.rounded(.up)
             totalStorageLabel.text = "\(storageGB) GB"
         }
    }
}

