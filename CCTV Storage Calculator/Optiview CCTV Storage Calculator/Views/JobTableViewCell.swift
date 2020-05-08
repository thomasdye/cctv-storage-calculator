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
    @IBOutlet weak var customerAddressLabel: UILabel!
    
    static let reuseIdentifier = "JobCell"
    
    // Call updateViews when job variable is changed
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
            let customerPhoneNumber = job.customerPhoneNumber,
            let customerAddress = job.customerAddress else { return }
       
        let formattedPhoneNumber = format(phoneNumber: customerPhoneNumber)
        jobNameLabel.text = job.jobName?.capitalized
        customerPhoneNumberButton.setTitle(formattedPhoneNumber, for: .normal)
        customerAddressLabel.text = customerAddress
        customerAddressLabel.adjustsFontSizeToFitWidth = true
    }
    
    func callCustomerPhoneNumber()  {
        
        guard let customerPhoneNumber = job?.customerPhoneNumber else { return }
        
        var formattedPhoneNumber = format(phoneNumber: customerPhoneNumber)
        
        formattedPhoneNumber = formattedPhoneNumber.replacingOccurrences(of: "(", with: "", options: NSString.CompareOptions.literal, range: nil)
        formattedPhoneNumber = formattedPhoneNumber.replacingOccurrences(of: ")", with: "", options: NSString.CompareOptions.literal, range: nil)
        formattedPhoneNumber = formattedPhoneNumber.replacingOccurrences(of: "-", with: "", options: NSString.CompareOptions.literal, range: nil)
        formattedPhoneNumber = formattedPhoneNumber.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil)
        let url: NSURL = URL(string: "TEL://\(formattedPhoneNumber)")! as NSURL

        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    }
    
    func navigateToAddress(addressLink: String) {
        
        var navigationURL = "https://maps.apple.com/?address="
        guard let formattedAddress = addressLink.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed) else { return }

        navigationURL.append(formattedAddress)

        let url: NSURL = URL(string: navigationURL)! as NSURL
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        
    }
    
    @IBAction func customerPhoneNumberButtonTapped(_ sender: UIButton) {
        
        
        self.callCustomerPhoneNumber()
    }
    
    @IBAction func navigateButtonTapped(_ sender: UIButton) {
        navigateToAddress(addressLink: (job?.customerAddress)!)
    }
}
