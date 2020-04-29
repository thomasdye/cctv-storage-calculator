//
//  JobTableViewCell.swift
//  CCTV Storage Calculator
//
//  Created by Thomas Dye on 4/29/20.
//  Copyright © 2020 Thomas Dye. All rights reserved.
//

import UIKit

class JobTableViewCell: UITableViewCell {
    
    @IBOutlet weak var customerPhoneNumberButton: UIButton!
    @IBOutlet weak var jobNameLabel: UILabel!
    
    static let reuseIdentifier = "JobCell"
    
    var job: Job? {
        didSet {
            updateViews()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func updateViews() {
        guard let job = job,
            let customerPhoneNumber = job.customerPhoneNumber else { return }
       
        jobNameLabel.text = job.jobName
        customerPhoneNumberButton.setTitle(customerPhoneNumber, for: .normal)
    }
    
    @IBAction func customerPhoneNumberButtonTapped(_ sender: UIButton) {
        
        self.callCustomerPhoneNumber()
    }
    
    func callCustomerPhoneNumber()  {
        
        guard let customerPhoneNumber = job?.customerPhoneNumber else { return }
        let url: NSURL = URL(string: "TEL://\(customerPhoneNumber)")! as NSURL

        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    }
}
