//
//  JobDetailViewCellViewController.swift
//  CCTV Storage Calculator
//
//  Created by Thomas Dye on 4/29/20.
//  Copyright © 2020 Thomas Dye. All rights reserved.
//

import UIKit

class JobDetailViewController: UIViewController {
    
    @IBOutlet weak var jobNameTextField: UITextField!
    @IBOutlet weak var customerNameTextField: UITextField!
    @IBOutlet weak var customerPhoneNumberTextField: UITextField!
    @IBOutlet weak var systemTypeSegmentedController: UISegmentedControl!
    @IBOutlet weak var numberOfCamerasTextField: UITextField!
    @IBOutlet weak var totalStorageLabel: UILabel!
    @IBOutlet weak var jobNotesTextView: UITextView!
    @IBOutlet weak var customerEmailTextField: UITextField!
    @IBOutlet weak var customerAddressTextField: UITextField!
    @IBOutlet weak var jobNameLabel: UILabel!
    @IBOutlet weak var calculateStorageButton: UIButton!
    
    var job: Job?
    var wasEdited = false
    var systemType = ""
    let accentColor: CGColor = UIColor(hue: 0.5694,
                                                saturation: 1,
                                                brightness: 0.97,
                                                alpha: 0.8).cgColor
    var newTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = editButtonItem
        updateViews()
        styleTextFields()
        setupTextView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setTotalStorage()
    }
    
    
    
    // This will run when we hit back in the navigation bar
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if wasEdited {
            guard let jobName = jobNameTextField.text,
                !jobName.isEmpty,
                let job = job else {
                return
            }
            
            let cutstomerName = customerNameTextField.text
            let customerPhoneNumber = customerPhoneNumberTextField.text
            let customerEmailAddress = customerEmailTextField.text
            let customerAddress = customerAddressTextField.text
            let numberOfCameras = numberOfCamerasTextField.text
            let totalStorage = totalStorageLabel.text
            let jobNotes = jobNotesTextView.text
            let systemTypeIndex = systemTypeSegmentedController.selectedSegmentIndex
            
            job.systemType = SystemType.allCases[systemTypeIndex].rawValue
            job.customerName = cutstomerName
            job.customerPhoneNumber = customerPhoneNumber
            job.customerEmailAddress = customerEmailAddress
            job.customerAddress = customerAddress
            job.numberOfCameras = Int64(numberOfCameras ?? "0") ?? 0
            job.totalStorage = totalStorage
            job.jobName = jobName
            job.jobNotes = jobNotes
            
            do {
                try CoreDataStack.shared.mainContext.save()
            } catch {
                NSLog("Error saving managed object context: \(error)")
            }
        }
    }
    
    func setTotalStorage() {
//        totalStorageLabel.text = totalStorageCalculated
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing { wasEdited = true }
        
        styleTextFields()
        
        title = ""
        jobNameTextField.isUserInteractionEnabled = editing
        jobNameTextField.isHidden = false
        jobNameLabel.isHidden = false
        calculateStorageButton.isHidden = false
        
        let allTextFields: [UITextField] = [customerNameTextField,
                                            customerPhoneNumberTextField,
                                            customerAddressTextField,
                                            numberOfCamerasTextField,
                                            customerEmailTextField]
        
        for textField in allTextFields {
            textField.isUserInteractionEnabled = editing
        }

        jobNotesTextView.isUserInteractionEnabled = editing
        jobNotesTextView.isEditable = true
        
        newTitle = jobNameTextField.text!
        
        navigationItem.hidesBackButton = editing
        
        if editing == false {
            
            title = newTitle
            jobNameLabel.isHidden = true
            jobNameTextField.isHidden = true
            
            customerNameTextField.isUserInteractionEnabled = false
            customerNameTextField.borderStyle = .none
            
            customerPhoneNumberTextField.isUserInteractionEnabled = false
            customerPhoneNumberTextField.borderStyle = .none
            
            customerEmailTextField.isUserInteractionEnabled = false
            customerEmailTextField.borderStyle = .none
            
            customerAddressTextField.isUserInteractionEnabled = false
            customerAddressTextField.borderStyle = .none
            
            systemTypeSegmentedController.isUserInteractionEnabled = false
            
            numberOfCamerasTextField.isUserInteractionEnabled = false
            numberOfCamerasTextField.borderStyle = .none
            
            calculateStorageButton.isHidden = true
        }
    }
    
    
    
    func setupTextView() {
        jobNotesTextView.layer.borderColor = accentColor
        jobNotesTextView.layer.borderWidth = 2
        jobNotesTextView.layer.cornerRadius = 10.0
    }
    
    
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
        systemTypeSegmentedController.selectedSegmentTintColor = UIColor(hue: 0.5694,
                                                                         saturation: 1,
                                                                         brightness: 0.97,
                                                                         alpha: 0.8)
    }
    
    private func updateViews() {
        
        let formattedPhoneNumber = format(phoneNumber: job?.customerPhoneNumber ?? "")
        let systemType: SystemType
        
        if let jobSystemType = job?.systemType {
            systemType = SystemType(rawValue: jobSystemType)!
        } else {
            systemType = .COAX
        }
        
        jobNameTextField.isHidden = true
        jobNameLabel.isHidden = true
        calculateStorageButton.isHidden = true
        
        jobNameTextField.text = job?.jobName?.capitalized
        jobNameTextField.isUserInteractionEnabled = isEditing
        title = job?.jobName?.capitalized
        
        customerNameTextField.text = job?.customerName?.capitalized
        customerNameTextField.isUserInteractionEnabled = isEditing
        
        customerPhoneNumberTextField.text = formattedPhoneNumber
        customerPhoneNumberTextField.isUserInteractionEnabled = isEditing
        
        customerEmailTextField.text = job?.customerEmailAddress
        customerEmailTextField.isUserInteractionEnabled = isEditing
        
        customerAddressTextField.text = job?.customerAddress?.capitalized
        customerAddressTextField.isUserInteractionEnabled = isEditing
        
        systemTypeSegmentedController.selectedSegmentIndex = SystemType.allCases.firstIndex(of: systemType) ?? 1
        systemTypeSegmentedController.isUserInteractionEnabled = isEditing
        
        numberOfCamerasTextField.isUserInteractionEnabled = isEditing
        numberOfCamerasTextField.text = "\(job?.numberOfCameras ?? 8)"
        totalStorageLabel.text = job?.totalStorage
        
        jobNotesTextView.text = job?.jobNotes
        jobNotesTextView.isUserInteractionEnabled = isEditing
    }
    
    @IBAction func calculateStorageButtonTapped(_ sender: UIButton) {
        
        guard let numberOfCameras = numberOfCamerasTextField.text else { return }
        totalCamerasFromCreateJob = Int(numberOfCameras) ?? 8
    }
    
}
