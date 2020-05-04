//
//  CalculateStorageViewController.swift
//  Optiview CCTV Storage Calculator
//
//  Created by Casualty on 10/1/19.
//  Copyright © 2019 Thomas Dye. All rights reserved.
//

import UIKit
import Foundation

public var totalStorageCalculated: String = String()

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
    @IBOutlet weak var shareResultsButton: UIButton!
    
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
    var framesPerSecond: Int = 15
    let convertSecondsToHour: Int = 3600
    let textFieldFontSize: CGFloat = 20
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
        case twoMegapixel = 15
        case threeMegapixel = 21
        case fourMegapixel = 30
        case fiveMegapixel = 36
        case eightMegapixel = 60
    }
    
    // Compression method enum
    enum CompressionMethod: Double {
        case h264 = 1.0
        case h265 = 1.33
    }

    // View loaded. Call setup and calculateStorage functions
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        calculateStorage()
    }
    
    // MARK: Functions
    
    // Create setup function
    func setup() {
        setDefaultText()
        setupSteppers()
        setupTextFields()
        changeLabelTextColor()
        changeTextFieldColor()
        changeStepperTintColor()
        changeSliderTintColor()
        changeSegmentedControlTintColor()
    }
    
    // Set variables equal to text fields
    func retreiveValues() {
        guard let hoursTextField = totalHoursTextField?.text,
              let daysTextField = totalDaysTextField.text else { return }
        totalHours = Int(hoursTextField) ?? 1
        totalCameras = totalCamerasFromCreateJob
        print("total cameras from create job: \(totalCamerasFromCreateJob), total cameras: \(totalCameras)")
        totalDays = Int(daysTextField) ?? 1
    }

    // Setup text fields
    func setDefaultText() {
        
        // Text field and label default text
        totalCamerasTextField.text = String(Int(totalCamerasFromCreateJob))
        totalDaysTextField.text = "30"
        totalHoursTextField.text = "24"
        totalStorageLabel.text = "0 TB"
        framesPerSecondSlider.value = 15
    }
    
    func setupTextFields() {
        let arrayOfTextFields: [UITextField] = [totalCamerasTextField,
                                                totalDaysTextField,
                                                totalHoursTextField]
        for textField in arrayOfTextFields {
            textField.borderStyle = .none
            textField.font = textField.font?.withSize(textFieldFontSize)
        }
    }
    
    // Setup steppers
    func setupSteppers() {
        setupTotalCamerasStepper()
        setupTotalDaysStepper()
        setupTotalHoursStepper()
    }
    
    // Total cameras stepper setup
    func setupTotalCamerasStepper() {
        totalCamerasStepper.value = Double(totalCamerasFromCreateJob)
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
        
        let totalCams = Int(totalCamerasTextField.text!)
        totalCamerasFromCreateJob = Int(totalCams!)
        calculateStorage()
    }
    
    // Audio selected segment changed
    @IBAction func audioSegmentedControlPressed(_ sender: UISegmentedControl) {
        let audioOffSelected: Int = 0
        let audioOnSelected: Int = 1
        
        switch audioSegmentedControl.selectedSegmentIndex
         {
         case audioOffSelected:
             audioOn = false
             audioSegmentedControl.selectedSegmentTintColor = .none
         case audioOnSelected:
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
        let motionDetectOffSelected: Int = 0
        let motionDetectOnSelected: Int = 1
        
        switch motionDetectSegmentedControl.selectedSegmentIndex
         {
         case motionDetectOffSelected:
             motionDetectOn = false
             motionDetectSegmentedControl.selectedSegmentTintColor = .none
         case motionDetectOnSelected:
             motionDetectOn = true
             motionDetectSegmentedControl.selectedSegmentTintColor = lightAccentColor
         default:
             break
         }
         calculateStorage()
    }
    
    // Megapixel selected segment changed
    @IBAction func megapixelSegmentedControlPressed(_ sender: UISegmentedControl) {
        let twoMegapixelSelected: Int = 0
        let threeMegapixelSelected: Int = 1
        let fourMegapixelSelected: Int = 2
        let fiveMegapixelSelected: Int = 3
        let eightMegapixelSelected: Int = 4
        
        switch megapixelSelectedSegementedControl.selectedSegmentIndex
         {
        case twoMegapixelSelected:
            cameraBitrate = FrameSize.twoMegapixel.rawValue
        case threeMegapixelSelected:
            cameraBitrate = FrameSize.threeMegapixel.rawValue
        case fourMegapixelSelected:
            cameraBitrate = FrameSize.fourMegapixel.rawValue
        case fiveMegapixelSelected:
            cameraBitrate = FrameSize.fiveMegapixel.rawValue
        case eightMegapixelSelected:
            cameraBitrate = FrameSize.eightMegapixel.rawValue
        default:
            break
         }
        calculateStorage()
    }
    
    // Compression selected segment changed
    @IBAction func compressionSegmentedControlPressed(_ sender: UISegmentedControl) {
        let compressionOffSelected: Int = 0
        let compressionOnSelected: Int = 1
        
        switch compressionSegmentedControl.selectedSegmentIndex
         {
        case compressionOffSelected:
            compression = CompressionMethod.h264.rawValue
            compressionSegmentedControl.selectedSegmentTintColor = .none
        case compressionOnSelected:
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
    
    
    @IBAction func saveResultsButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        
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
         
         // If motion detect is on, divide total GB by 1.40
         if motionDetectOn == true {
            storageGB = storageGB / 1.40
         }
        
         // If audio is on, multiply total GB by 1.05
         if audioOn == true {
            storageGB = storageGB * 1.05
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
        
        totalStorageCalculated = totalStorageLabel.text ?? "0.0GB"
    }
}


