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
    
    var job: Job?
    var wasEdited = false
    var systemType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = editButtonItem
        updateViews()
    }
    
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
            let numberOfCameras = numberOfCamerasTextField.text
            let totalStorage = totalStorageLabel.text
            let jobNotes = jobNotesTextView.text
            
            let systemTypeIndex = systemTypeSegmentedController.selectedSegmentIndex
            job.systemType = SystemType.allCases[systemTypeIndex].rawValue
            
            job.customerName = cutstomerName
            job.customerPhoneNumber = customerPhoneNumber
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
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing { wasEdited = true }
        
        jobNameTextField.isUserInteractionEnabled = editing
        customerNameTextField.isUserInteractionEnabled = editing
        customerPhoneNumberTextField.isUserInteractionEnabled = editing
        systemTypeSegmentedController.isUserInteractionEnabled = editing
        numberOfCamerasTextField.isUserInteractionEnabled = editing
        jobNotesTextView.isUserInteractionEnabled = editing
        
        navigationItem.hidesBackButton = editing
    }
    
    private func updateViews() {
        jobNameTextField.text = job?.jobName
        jobNameTextField.isUserInteractionEnabled = isEditing
        
        jobNotesTextView.text = job?.jobNotes
        jobNotesTextView.isUserInteractionEnabled = isEditing
        
        customerNameTextField.text = job?.customerName
        customerNameTextField.isUserInteractionEnabled = isEditing
        
        let formattedPhoneNumber = format(phoneNumber: job?.customerPhoneNumber ?? "")
        
        customerPhoneNumberTextField.text = formattedPhoneNumber
        customerPhoneNumberTextField.isUserInteractionEnabled = isEditing
        
        let systemType: SystemType
        if let jobSystemType = job?.systemType {
            systemType = SystemType(rawValue: jobSystemType)!
        } else {
            systemType = .COAX
        }
        
        systemTypeSegmentedController.selectedSegmentIndex = SystemType.allCases.firstIndex(of: systemType) ?? 1
        systemTypeSegmentedController.isUserInteractionEnabled = isEditing
        
        numberOfCamerasTextField.text = "\(job?.numberOfCameras ?? 8)"
        totalStorageLabel.text = job?.totalStorage
    }
    
}
