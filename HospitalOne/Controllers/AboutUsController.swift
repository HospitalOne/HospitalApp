//
//  AboutUsController.swift
//  HospitalOne
//
//  Created by Daniil Belikov on 18.10.2019.
//  Copyright © 2019 Tolyatti City Hospital No.1. All rights reserved.
//

import MessageUI
import StoreKit
import UIKit

final class AboutUsController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var firstImageView: UIImageView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var firstTextView: UITextView!
    @IBOutlet private weak var secondTextView: UITextView!
    @IBOutlet private weak var thirdTextView: UITextView!
    @IBOutlet private weak var contactUsButton: UIButton!
    @IBOutlet private weak var rateButton: UIButton!
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureTexts()
    }
    
    // MARK: - IBActions
    
    @IBAction func shareAction(_ sender: UIBarButtonItem) {
        showShareActivity()
    }
    
    @IBAction func contactUsAction(_ sender: UIButton) {
        sender.flash()
        showMailComposer()
    }
    
    @IBAction func rateTheAppAction(_ sender: UIButton) {
        sender.flash()
        SKStoreReviewController.requestReview()
    }
    
}

// MARK: - MFMailCompose Methods

extension AboutUsController: MFMailComposeViewControllerDelegate {
    // Send E-mail.
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
        switch result {
        case .cancelled:
            print("Cancelled.")
        case .failed:
            print("Failed to send.")
        case .saved:
            print("Saved.")
        case .sent:
            print("Email sent.")
        default:
            return
        }
        
        controller.dismiss(animated: true)
    }
    
}

// MARK: - Private Configure Methods

private extension AboutUsController {
    
    func showMailComposer() {
        if MFMailComposeViewController.canSendMail() {
            let composer = MFMailComposeViewController()
            composer.mailComposeDelegate = self
            composer.setToRecipients(["hospital1@mail.ru"])
            composer.setSubject("Letter to the chief of hospital Max Zamulin".localize())
            composer.setMessageBody("Hello, ".localize(), isHTML: false)
            
            present(composer, animated: true)
        }
    }
    
    func showShareActivity() {
        let activityViewController = UIActivityViewController(activityItems: [firstImageView.image as Any, "I recommend downloading the app «Tolyatti City Hospital No.1. Here's a link: https://apps.apple.com/app/id1497757302".localize()], applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = view
        
        present(activityViewController, animated: true)
    }
    
    func configureViews() {
        contactUsButton.layer.cornerRadius = 20.0
        rateButton.layer.cornerRadius = 20.0
        backgroundView.layer.cornerRadius = 20.0
        
        firstImageView.applyShadowWithCornerRadius(10.0)
        backgroundView.applyShadow()
    }
    
    func configureTexts() {
        firstTextView.text = "Tolyatti City Hospital No.1 is one of the largest clinics in the city. Our multidisciplinary medical institution is equipped with the modern medical equipment. The unique experience of hospital specialists and advanced equipment allows us to provide high-tech medical care in difficult and emergency cases. The priority areas of Hospital No.1 are nephrology, urology and coloproctology.".localize()
        
        secondTextView.text = "It is important for us that every patient who turned to the Togliatti City Hospital No.1 for help can receive it quickly, in full and with the best quality. We guarantee the use of effective, modern and safe methods of diagnosis, treatment and prevention. Our specialists take personal and professional responsibility for the result of treatment. Doctors of Hospital No.1 can be trusted!".localize()
        
        thirdTextView.text = "Since 2014, the Tolyatti City Hospital No.1 has been included in the system of providing high-tech medical care in the fields of Urology and Gynecology. High-tech medical care is carried out using complex and unique medical technologies, based on the most modern achievements of science and technology, only by highly qualified medical personnel. In addition, an inter-district coloproctology center operates on the basis of the institution, with about 1,000 people treated annually. At Hospital No.1, you will be provided with high-quality medical care at the level of international standards.".localize()
    }
    
}
