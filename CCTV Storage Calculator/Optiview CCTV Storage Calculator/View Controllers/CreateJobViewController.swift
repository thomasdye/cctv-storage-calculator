//
//  CreateJobViewController.swift
//  CCTV Storage Calculator
//
//  Created by Thomas Dye on 4/15/20.
//  Copyright © 2020 Thomas Dye. All rights reserved.
//

import UIKit

var totalCamerasFromCreateJob: Int = 0

class CreateJobViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var jobNotesTextView: UITextView!
    @IBOutlet weak var totalStorageLabel: UILabel!
    @IBOutlet weak var jobNameTextField: UITextField!
    @IBOutlet weak var customerNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var systemTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var numberOfCamerasTextField: UITextField!
    @IBOutlet weak var customerAddressTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTextView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setTotalStorage()
    }
    
    func setTotalStorage() {
        totalStorageLabel.text = totalStorageCalculated
    }
    
    func setupTextView() {
        jobNotesTextView.layer.borderColor = UIColor.lightGray.cgColor
        jobNotesTextView.layer.borderWidth = 1
        jobNotesTextView.layer.cornerRadius = 15.0
    }
    
    // Save button tapped
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        // Check if job name, customer name, phone number, total storage have value
        guard let jobName = jobNameTextField.text,
            let customerName = customerNameTextField.text,
            let customerPhoneNumber = phoneNumberTextField.text,
            let customerAddress = customerAddressTextField.text,
            let totalStorage = totalStorageLabel.text,
            let numberOfCameras = Int64(numberOfCamerasTextField.text ?? "0"),
            let jobNotes = jobNotesTextView.text else { return }
        
        // Need to determine the selectedSegmentIndex for systemType and convert it to a string
        
        let systemTypeIndex = systemTypeSegmentedControl.selectedSegmentIndex
        let systemType = SystemType.allCases[systemTypeIndex]
        
        Job(jobName: jobName,
            customerName: customerName,
            customerPhoneNumber: customerPhoneNumber,
            customerAddress: customerAddress,
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
        
        navigationController?.popViewController(animated: true)
        
    }
    @IBAction func calculateButtonTapped(_ sender: UIButton) {
        
        guard let numberOfCameras = numberOfCamerasTextField.text else { return }
        totalCamerasFromCreateJob = Int(numberOfCameras) ?? 8
    }
}
