//
//  AddJobViewController.swift
//  CCTV Storage Calculator
//
//  Created by Thomas Dye on 4/15/20.
//  Copyright © 2020 Thomas Dye. All rights reserved.
//

import UIKit

var totalCamerasFromCreateJob: Int = 0

class CreateJobViewController: UIViewController {
    
    @IBOutlet weak var jobNotesTextView: UITextView!
    @IBOutlet weak var totalStorageLabel: UILabel!
    @IBOutlet weak var jobNameTextField: UITextField!
    @IBOutlet weak var customerNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var systemTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var numberOfCamerasTextField: UITextField!
    
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
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        // Create non-optional properties
        var systemType = ""
        
        // Check if job name, customer name, phone number, total storage have value
        guard let jobName = jobNameTextField.text,
            let customerName = customerNameTextField.text,
            let customerPhoneNumber = phoneNumberTextField.text,
            let totalStorage = totalStorageLabel.text,
            let numberOfCameras = Int64(numberOfCamerasTextField.text ?? "0"),
            let jobNotes = jobNotesTextView.text else { return }
        
        // Need to determine the selectedSegmentIndex for systemType and convert it to a string
        func determineSystemType() {
            if systemTypeSegmentedControl.selectedSegmentIndex == 0 {
                systemType = "IP"
            } else if systemTypeSegmentedControl.selectedSegmentIndex == 1 {
                systemType = "COAX"
            } else if systemTypeSegmentedControl.selectedSegmentIndex == 2 {
                systemType = "Hybrid"
            }
        }
    
        determineSystemType()
        
        Job(jobName: jobName,
            customerName: customerName,
            customerPhoneNumber: customerPhoneNumber,
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
