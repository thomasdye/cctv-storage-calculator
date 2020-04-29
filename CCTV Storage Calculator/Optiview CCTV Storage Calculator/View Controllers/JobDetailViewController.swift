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
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
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
    
    @objc func save() {
        guard let jobName = jobNameTextField.text,
            !jobName.isEmpty,
            let customerName = customerNameTextField.text,
            let customerPhoneNumber = customerPhoneNumberTextField.text
        else {
            return
        }

        let systemType = systemTypeSegmentedController.selectedSegmentIndex
        let systemTypeRawValue = SystemType.allCases[systemType]
        let jobNotes = jobNotesTextView.text ?? ""
        let numberOfCameras = Int64(numberOfCamerasTextField.text!) ?? 0
        let totalStorage = totalStorageLabel.text ?? "8.0 TBB"
        
        
        Job(jobName: jobName,
            customerName: customerName,
            customerPhoneNumber:
            customerPhoneNumber,
            systemType: systemTypeRawValue,
            numberOfCameras: numberOfCameras,
            totalStorage: totalStorage,
            jobNotes: jobNotes)
        
        do {
            try CoreDataStack.shared.mainContext.save()
            navigationController?.dismiss(animated: true, completion: nil)
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func saveBarButtonTapped(_ sender: UIBarButtonItem) {
    }
    
    private func updateViews() {
        jobNameTextField.text = job?.jobName
        jobNameTextField.isUserInteractionEnabled = isEditing
        
        jobNotesTextView.text = job?.jobNotes
        jobNotesTextView.isUserInteractionEnabled = isEditing
        
        customerNameTextField.text = job?.customerName
        customerNameTextField.isUserInteractionEnabled = isEditing
        
        customerPhoneNumberTextField.text = job?.customerPhoneNumber
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
