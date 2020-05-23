//
//  CreateJobViewController.swift
//  CCTV Storage Calculator
//
//  Created by Thomas Dye on 4/15/20.
//  Copyright © 2020 Thomas Dye. All rights reserved.
//

import UIKit

var totalCamerasFromCreateJob: Int = Int()

class AddJobViewController: UIViewController, UITextFieldDelegate {
    
    // Outlets
    @IBOutlet weak var jobNotesTextView: UITextView!
    @IBOutlet weak var totalStorageLabel: UILabel!
    @IBOutlet weak var jobNameTextField: UITextField!
    @IBOutlet weak var customerNameTextField: UITextField!
    @IBOutlet weak var customerPhoneNumberTextField: UITextField!
    @IBOutlet weak var systemTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var numberOfCamerasTextField: UITextField!
    @IBOutlet weak var customerEmailTextField: UITextField!
    @IBOutlet weak var customerAddressTextField: UITextField!
    
    let accentColor: CGColor = UIColor(hue: 0.5694,
                                                saturation: 1,
                                                brightness: 0.97,
                                                alpha: 0.75).cgColor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpKeyboardNotification()
        setUpTextView()
        styleTextFields()
        
        jobNameTextField.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        setTotalStorage()
    }
    
    func setTotalStorage() {
        totalStorageLabel.text = totalStorageCalculated
    }
    
    func setUpTextView() {
        jobNotesTextView.layer.borderColor = accentColor
        jobNotesTextView.layer.borderWidth = 2
        jobNotesTextView.layer.cornerRadius = 10.0
        systemTypeSegmentedControl.selectedSegmentTintColor = UIColor(hue: 0.5694,
                                                                      saturation: 1,
                                                                      brightness: 0.97,
                                                                      alpha: 0.75)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            
            switch textField {
            case jobNameTextField:
                customerNameTextField.delegate = self
                customerNameTextField.becomeFirstResponder()
            case customerNameTextField:
                customerPhoneNumberTextField.delegate = self
                customerPhoneNumberTextField.becomeFirstResponder()
            default:
                textField.resignFirstResponder()
            }
            return true
    }
    
    func setUpKeyboardNotification() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        let jobNameHeight = jobNameTextField.frame.height
        let customerNameHeight = customerNameTextField.frame.height
        let phoneHeight = customerPhoneNumberTextField.frame.height
        let emailHeight = customerEmailTextField.frame.height
        let addressHeight = customerAddressTextField.frame.height
        let segmentedHeight = systemTypeSegmentedControl.frame.height
        let camerasHeight = numberOfCamerasTextField.frame.height
        let jobNotesHeight = jobNotesTextView.frame.height
        
        if jobNameTextField.isEditing {
            self.view.frame.origin.y = 0
        } else if customerNameTextField.isEditing {
            self.view.frame.origin.y = -(jobNameHeight)
        } else if customerPhoneNumberTextField.isEditing {
            self.view.frame.origin.y = -(jobNameHeight + customerNameHeight + phoneHeight)
        } else if customerEmailTextField.isEditing {
            self.view.frame.origin.y = -(jobNameHeight + customerNameHeight + phoneHeight + emailHeight)
        } else if customerAddressTextField.isEditing {
            self.view.frame.origin.y = -(jobNameHeight + customerNameHeight + phoneHeight + emailHeight + addressHeight)
        } else if numberOfCamerasTextField.isEditing {
            self.view.frame.origin.y = -(jobNameHeight + customerNameHeight + phoneHeight + emailHeight + addressHeight + segmentedHeight + camerasHeight)
        } else if jobNotesTextView.isTracking{
            self.view.frame.origin.y = -(jobNameHeight + customerNameHeight + phoneHeight + emailHeight + addressHeight + segmentedHeight + camerasHeight + jobNotesHeight)
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
            self.view.frame.origin.y = 0
    }
    
    // Remove borders from text fields
    func styleTextFields() {
        
        let allTextFields: [UITextField] = [jobNameTextField,
                                         customerNameTextField,
                                         customerPhoneNumberTextField,
                                         customerAddressTextField,
                                         numberOfCamerasTextField,
                                         customerEmailTextField]
        
        for textField in allTextFields {
            textField.borderStyle = .none
            let bottomLine = CALayer()
            
            bottomLine.frame = CGRect(x: 0,
                                      y: textField.frame.height + 4,
                                      width: textField.frame.width,
                                      height: 2)
            
            bottomLine.backgroundColor = accentColor
            textField.layer.addSublayer(bottomLine)
        }
    }

    // Save button tapped
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        if jobNameTextField.text?.isEmpty == true || customerNameTextField.text?.isEmpty == true || customerPhoneNumberTextField.text?.isEmpty == true || customerAddressTextField.text?.isEmpty == true || customerEmailTextField.text?.isEmpty == true {
            
            let alertController = UIAlertController(title: "Missing Information",
                                                    message: "Please fill out all required fields marked with *",
                                                    preferredStyle: .alert)
            
            // Create OK button
            let OKAction = UIAlertAction(title: "OK",
                                         style: .default)
            
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)
            
            let requiredTextFields: [UITextField] = [jobNameTextField,
                                                     customerNameTextField,
                                                     customerPhoneNumberTextField,
                                                     customerAddressTextField,
                                                     customerEmailTextField]
            
            for textField in requiredTextFields {
                textField.placeholder?.append("*")
            }
            
        } else {
            
        let alertController = UIAlertController(title: "New Job Added!",
                                                message: "You have successfully added a new job.",
                                                preferredStyle: .alert)
        
        // Create OK button
        let OKAction = UIAlertAction(title: "OK",
                                     style: .default) { (action:UIAlertAction!) in
                                        
                                        guard let jobName = self.jobNameTextField.text,
                                            let customerName = self.customerNameTextField.text,
                                            let customerPhoneNumber = self.customerPhoneNumberTextField.text,
                                            let customerEmailAddress = self.customerEmailTextField.text,
                                            let customerAddress = self.customerAddressTextField.text,
                                            let totalStorage = self.totalStorageLabel.text,
                                            let numberOfCameras = Int64(self.numberOfCamerasTextField.text ?? "0"),
                                            let jobNotes = self.jobNotesTextView.text else { return }
                                        
                                        // Need to determine the selectedSegmentIndex for systemType and convert it to a string
                                        let systemTypeIndex = self.systemTypeSegmentedControl.selectedSegmentIndex
                                        let systemType = SystemType.allCases[systemTypeIndex]
                                        
                                        Job(jobName: jobName,
                                            customerName: customerName,
                                            customerPhoneNumber: customerPhoneNumber,
                                            customerAddress: customerAddress,
                                            customerEmailAddress: customerEmailAddress,
                                            systemType: systemType,
                                            numberOfCameras: numberOfCameras,
                                            totalStorage: totalStorage,
                                            jobNotes: jobNotes,
                                            context: CoreDataStack.shared.mainContext)
                                        
                                        // do try catch to save the context we have created
                                        do {
                                            try CoreDataStack.shared.mainContext.save()
                                        } catch {
                                            NSLog("Error saving manage object context: \(error)")
                                        }
                                        
                                        self.navigationController?.popViewController(animated: true)
                                        
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
        
        }
    }
    
    @IBAction func calculateButtonTapped(_ sender: UIButton) {
        
        guard let numberOfCameras = numberOfCamerasTextField.text else { return }
        totalCamerasFromCreateJob = Int(numberOfCameras) ?? 8
    }
}
