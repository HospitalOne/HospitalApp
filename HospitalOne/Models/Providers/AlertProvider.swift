//
//  AlertProvider.swift
//  HospitalOne
//
//  Created by Daniil Belikov on 18.10.2019.
//  Copyright © 2019 Tolyatti City Hospital No.1. All rights reserved.
//

import UIKit

struct AlertProvider {
    // Logic of appearance AlertController.
    func showAlert(on viewcontroller: UIViewController,
                   with title: String,
                   message: String) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok".localize(),
                                     style: .default,
                                     handler: nil)
        
        alert.addAction(okAction)
        viewcontroller.present(alert, animated: true)
    }
    
}
