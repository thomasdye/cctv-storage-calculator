//
//  ColorFunctions.swift
//  CCTV Storage Calculator
//
//  Created by Casualty on 12/10/19.
//  Copyright © 2019 Thomas Dye. All rights reserved.
//

import Foundation
import UIKit

extension CalculateStorageViewController {
    
    // Change text field text color
    func changeTextFieldColor() {
        let arrayOfLabels: [UITextField] = [totalCamerasTextField,
                                            totalDaysTextField,
                                            totalHoursTextField]
        
        for textField in arrayOfLabels {
            textField.textColor = darkAccentColor
            textField.isEnabled = false
        }
    }
    
    // Change segmented control tint color
    func changeSegmentedControlTintColor() {
        megapixelSelectedSegementedControl.selectedSegmentTintColor = lightAccentColor
    }
    
    // Change stepper tint color
    func changeStepperTintColor() {
        let arrayOfSteppers: [UIStepper] = [totalCamerasStepper,
                                            totalDaysStepper,
                                            totalHoursStepper]
        
        for stepper in arrayOfSteppers {
            stepper.tintColor = darkAccentColor
            stepper.setDecrementImage(stepper.decrementImage(for: .normal), for: .normal)
            stepper.setIncrementImage(stepper.incrementImage(for: .normal), for: .normal)
        }
    }
    
    // Change slider tint color
    func changeSliderTintColor() {
        let arrayOfSliders: [UISlider] = [framesPerSecondSlider]
        
        for slider in arrayOfSliders {
            slider.tintColor = darkAccentColor
            slider.thumbTintColor = lightAccentColor
            slider.thumbImage(for: .normal)
        }
    }
    
    // Change label text color
    func changeLabelTextColor() {
        let arrayOfLabels: [UILabel] = [totalStorageLabel]
        
        for label in arrayOfLabels {
            label.textColor = lightAccentColor
        }
    }
}
