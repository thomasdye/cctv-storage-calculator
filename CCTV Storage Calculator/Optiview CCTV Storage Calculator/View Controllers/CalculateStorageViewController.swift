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
    
    // MARK: Outlets
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
    
    // MARK: Variables and Constants
    var totalCameras: Int = 0
    var cameraBitrate: Int = FrameSize.twoMegapixel.rawValue
    var totalDays: Int = 30
    var totalHours: Int = 24
    var motionDetectOn: Bool = false
    var audioOn: Bool = false
    var storageGB: Double = 0.0
    var storageTB: Double = 0.0
    var compression: Double = CompressionMethod.h264.rawValue
    var framesPerSecond: Int = 7
    let convertSecondsToHour: Int = 3600
    let darkAccentColor: UIColor = UIColor(hue: 0.5889,
                                               saturation: 1,
                                               brightness: 0.91,
                                               alpha: 1.0)
    let lightAccentColor: UIColor = UIColor(hue: 0.5694,
                                                    saturation: 1,
                                                    brightness: 0.97,
                                                    alpha: 1.0)
    
    // CameraBitrate enum to use in calculation
    enum FrameSize: Int {
        case twoMegapixel = 20
        case threeMegapixel = 26
        case fourMegapixel = 36
        case fiveMegapixel = 46
        case eightMegapixel = 72
    }
    
    // Compression method enum
    enum CompressionMethod: Double {
        case h264 = 1.0
        case h265 = 1.3
    }

    // View loaded. Call setup and calculateStorage functions
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        calculateStorage()

    }
    
    // MARK: Functions
    
    // Create setup function for easier editing later
    func setup() {
        
        setDefaultText()
        setupSteppers()
        changeLabelTextColor()
        changeTextFieldColor()
        changeStepperTintColor()
        changeSliderTintColor()
        changeSegmentedControlTintColor()
    }
    
    // Set variables equal to text fields
    func retreiveValues() {
        
        guard let hoursTextField = totalHoursTextField?.text, let camerasTextField = totalCamerasTextField.text, let daysTextField = totalDaysTextField.text else { return }
            
            
        totalHours = Int(hoursTextField) ?? 1
        totalCameras = Int(camerasTextField) ?? 1
        totalDays = Int(daysTextField) ?? 1
    }

    // Setup text fields
    func setDefaultText() {
        
        // Text field and label default text
        totalCamerasTextField.text = "8"
        totalDaysTextField.text = "30"
        totalHoursTextField.text = "24"
        totalStorageLabel.text = "0 TB"
        
    }
    
    // Setup steppers
    func setupSteppers() {

        setupTotalCamerasStepper()
        setupTotalDaysStepper()
        setupTotalHoursStepper()
    }
    
    // Total cameras stepper setup
    func setupTotalCamerasStepper() {
        
        totalCamerasStepper.value = 8
        totalCamerasStepper.minimumValue = 1
        totalCamerasStepper.maximumValue = 128
        totalCamerasStepper.wraps = true
    }
    
    // Total days stepper setup
    func setupTotalDaysStepper() {
        
        totalDaysStepper.value = 30
        totalDaysStepper.minimumValue = 1
        totalDaysStepper.maximumValue = 365
        totalDaysStepper.wraps = true
        
    }
    
    // Total hours stepper setup
    func setupTotalHoursStepper() {
        
        totalHoursStepper.value = 24
        totalHoursStepper.minimumValue = 1
        totalHoursStepper.maximumValue = 24
        totalHoursStepper.wraps = true
        
    }
    
    // MARK: IBActions
    
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
             audioSegmentedControl.selectedSegmentTintColor = lightAccentColor
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
             motionDetectSegmentedControl.selectedSegmentTintColor = lightAccentColor
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
            cameraBitrate = FrameSize.twoMegapixel.rawValue
        case 1:
            cameraBitrate = FrameSize.threeMegapixel.rawValue
        case 2:
            cameraBitrate = FrameSize.fourMegapixel.rawValue
        case 3:
            cameraBitrate = FrameSize.fiveMegapixel.rawValue
        case 4:
            cameraBitrate = FrameSize.eightMegapixel.rawValue
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
            compression = CompressionMethod.h264.rawValue
            compressionSegmentedControl.selectedSegmentTintColor = .none
        case 1:
            compression = CompressionMethod.h265.rawValue
            compressionSegmentedControl.selectedSegmentTintColor = lightAccentColor
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
    
    // MARK: Calculate storage function
    
    // Create calculate storage function
    func calculateStorage() {
        
        // Retreive values from text fields
         retreiveValues()
         
         // Calculate total frame size per second
         // ex: 7 (FPS) * 50KB (twoMegapixel) = 350KB/s
         let totalFrameSizePerSecond = (framesPerSecond * cameraBitrate)
         
         // Example: 350KB/s * 3600 (seconds/hour) = 1_260_000KB/hr
         let totalSizePerHour = totalFrameSizePerSecond * convertSecondsToHour
         
         // Calculate storage in GB
         // Example: (1,260,000 * 30 * 24) = 907,200,000 / 1,000,000
         storageGB = Double((totalSizePerHour * totalDays * totalHours) / 1_000_000)
         
         // Multiplying total storage calculated per camera times the total number of cameras
         storageGB = storageGB * Double(totalCameras)
         
         // Divide storage by compression
         storageGB = storageGB / compression
         
         // If motion detect is on, divide total GB by 1.35
         if motionDetectOn == true {
            storageGB = storageGB / 1.35
         }
        
         // If audio is on, multiply total GB by 1.04
         if audioOn == true {
            storageGB = storageGB * 1.04
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

