//
//  ContactViewController.swift
//  CCTV Storage Calculator
//
//  Created by Casualty on 10/13/19.
//  Copyright © 2019 Thomas Dye. All rights reserved.
//

import UIKit
import MapKit
import MessageUI

class ContactViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    // IB Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var navigateAddressButton: UIButton!
    @IBOutlet weak var salesTitleLabel: UILabel!
    @IBOutlet weak var salesPhoneButton: UIButton!
    @IBOutlet weak var techSupportPhoneButton: UIButton!
    @IBOutlet weak var techSupportTitleLabel: UILabel!
    @IBOutlet weak var salesEmailButton: UIButton!
    @IBOutlet weak var techSupportEmailButton: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    
    // Constants
    let optiviewSalesPhoneText = "(904)-805-1581"
    let optiviewTechSupportPhoneText = "(904)-855-1121"
    let optiviewSalesEmailText = "sales@optiviewusa.com"
    let optiviewTechSupportEmailText = "tech@optiviewusa.com"
    let optiviewAddressText = "5211 Fairmont St.\nJacksonville, FL\n32207"
    
    // Create function to center map
    func centerMapOnLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = 750
        let optiviewLocation = CLLocationCoordinate2D(latitude: 30.296767,
                                                      longitude: -81.611463)
        let mapPin = MapPin(title: "Optiview",
                            locationName: "5211 Fairmont Street",
                            discipline: "Office",
                            coordinate: optiviewLocation)
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius,
                                                  longitudinalMeters: regionRadius)
        mapView.addAnnotation(mapPin)
        mapView.setRegion(coordinateRegion,
                          animated: true)
    }
    
    // View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        setupText()
        setupMap()
        centerOptiviewLocation()
    }
    
    // Setup text
    func setupText() {
        
        // Setup Sales Text
        setupSalesText()
        
        // Setup Tech Support Text
        setupTechSupportText()
    
        // Address Button
        setupAddressButtonText()
        
        // Location Label
        setupLocationLabelText()
    }
    
    func setupSalesText() {
        
        salesTitleLabel.textAlignment = .center
        salesTitleLabel.text = "Sales 👨‍💼"
        salesPhoneButton.setTitle(optiviewSalesPhoneText, for: .normal)
        salesEmailButton.setTitle(optiviewSalesEmailText, for: .normal)
        salesEmailButton.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    func setupTechSupportText() {
        
        techSupportTitleLabel.textAlignment = .center
        techSupportTitleLabel.text = "Tech Support 👨‍💻"
        techSupportPhoneButton.setTitle(optiviewTechSupportPhoneText, for: .normal)
        techSupportEmailButton.setTitle(optiviewTechSupportEmailText, for: .normal)
        techSupportEmailButton.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    func setupAddressButtonText() {
        
        // Navigation Button Title
        navigateAddressButton.setTitle("Navigate", for: .normal)
    }
    
    func setupLocationLabelText() {
        
        // Location Label
        locationLabel.textAlignment = .center
        locationLabel.numberOfLines = 0
        locationLabel.text = optiviewAddressText
    }
    
    // Set up map
    func setupMap() {
        
        // Map can zoom
        mapView.isZoomEnabled = true
        
        // Map can scroll
        mapView.isScrollEnabled = true
        
        // Map can rotate
        mapView.isRotateEnabled = true
        
        // Map's pitch is enabled
        mapView.isPitchEnabled = true
        
        // Pitch's Angle
        mapView.camera.pitch = 15.0
    }
    
    // Create function to center optiview on map
    func centerOptiviewLocation() {
        let optiviewLocation = CLLocation(latitude: 30.296767,
        longitude: -81.611463)
        centerMapOnLocation(location: optiviewLocation)
    }
    
    // Create function to call sales
    func callSalesPhoneNumber()  {
        let url: NSURL = URL(string: "TEL://9048051581")! as NSURL
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    }
    
    // Create function to call tech support
    func callTechSupportPhoneNumber()  {
        let url: NSURL = URL(string: "TEL://9048551121")! as NSURL
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    }
    
    // Create button for when address button is tapped
    func addressButtonTapped() {
        let optiviewAddressLink = "https://maps.apple.com/?address=5211%20Fairmont%20St,%20Jacksonville,%20FL%20%2032207,%20United%20States&ll=30.296857,-81.611421&q=5211%20Fairmont%20St&_ext=EiYpNcHcddhKPkAx322NwHZnVMA5MWwoLiVNPkBBWR2KSsxmVMBQAw%3D%3D"
        let url: NSURL = URL(string: optiviewAddressLink)! as NSURL
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        
    }
    
    // Create function to email sales
    func emailSales() {
        let emailTitle = "Optiview Sales"
        let messageBody = "I'm contacting you via your mobile app"
        let toRecipents = ["sales@optiviewusa.com"]
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        
        mc.mailComposeDelegate = self
        mc.setSubject(emailTitle)
        mc.setMessageBody(messageBody, isHTML: false)
        mc.setToRecipients(toRecipents)
        self.present(mc, animated: true, completion: nil)
    }
    
    // Create function to email tech support
    func emailTechSupport() {
        let emailTitle = "Optiview Tech Support"
        let messageBody = "I'm contacting you via your mobile app"
        let toRecipents = ["tech@optiviewusa.com"]
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        
        mc.mailComposeDelegate = self
        mc.setSubject(emailTitle)
        mc.setMessageBody(messageBody, isHTML: false)
        mc.setToRecipients(toRecipents)
        self.present(mc, animated: true, completion: nil)
    }
    
    // Create switch inside function to control mail results
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("Mail cancelled")
            self.dismiss(animated: true, completion: messageCancelledAlert)
        case .saved:
            print("Mail saved")
            self.dismiss(animated: true, completion: messageSavedAlert)
        case .sent:
            print("Mail sent")
            self.dismiss(animated: true, completion: messageSentAlert)
        case .failed:
            print("Mail sent failure")
            self.dismiss(animated: true, completion: messageFailedAlert)
        default:
            break
        }
    }
    
    // Create alert to show after mail has been cancelled
    func messageCancelledAlert() {
        let alertController = UIAlertController(title: "Message Cancelled",
                                                message: "Your message was cancelled.",
                                                preferredStyle: .alert)
        
        // Create OK button
        let OKAction = UIAlertAction(title: "OK",
                                     style: .default) { (action:UIAlertAction!) in
            
                                        // Code in this block will trigger when OK button tapped.
                                        print("Message cancelled")
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)

    }
    
    // Create alert to show after mail has been sent
    func messageSentAlert() {
        let alertController = UIAlertController(title: "Message Sent",
                                                message: "Your message was successfully sent!",
                                                preferredStyle: .alert)
        
        // Create OK button
        let OKAction = UIAlertAction(title: "OK",
                                     style: .default) { (action:UIAlertAction!) in
            
                                        // Code in this block will trigger when OK button tapped.
                                        print("Message sent")
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)

    }
    
    // Create alert to show after mail has been saved
    func messageSavedAlert() {
        let alertController = UIAlertController(title: "Message Saved",
                                                message: "Your message was successfully saved.",
                                                preferredStyle: .alert)
        
        // Create OK button
        let OKAction = UIAlertAction(title: "OK",
                                     style: .default) { (action:UIAlertAction!) in
            
                                        // Code in this block will trigger when OK button tapped.
                                        print("Message saved")
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)

    }
    
    // Create alert to show after mail has failed to send
    func messageFailedAlert() {
        let alertController = UIAlertController(title: "Message Sending Failed",
                                                message: "Your message failed to send. Please check your connection and try again.",
                                                preferredStyle: .alert)
        
        // Create OK button
        let OKAction = UIAlertAction(title: "OK",
                                     style: .default) { (action:UIAlertAction!) in
            
                                        // Code in this block will trigger when OK button tapped.
                                        print("Message failed to send.")
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)

    }
    
    // Call addressButtonTapped() function when button pressed
    @IBAction func navigateAddressButtonTapped(_ sender: UIButton) {
        addressButtonTapped()
    }
    
    // Sales phone number tapped
    @IBAction func salesPhoneNumberButtonTapped(_ sender: UIButton) {
        self.callSalesPhoneNumber()
    }
    
    // Tech Support phone number tapped
    @IBAction func techSupportPhoneNumberTapped(_ sender: UIButton) {
        self.callTechSupportPhoneNumber()
    }
    
    // Sales email address tapped
    @IBAction func salesEmailButtonTapped(_ sender: UIButton) {
        emailSales()
    }

    // Tech Support email address tapped
    @IBAction func techSupportEmailButtonTapped(_ sender: UIButton) {
        emailTechSupport()
    }
    
    // Create a class MapPin for annotation on map
    class MapPin: NSObject, MKAnnotation {
      let title: String?
      let locationName: String
      let discipline: String
      let coordinate: CLLocationCoordinate2D
      
      init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
      }
      
      var subtitle: String? {
        return locationName
      }
    }
}
