//
//  UITextField+Shadow.swift
//  HospitalOne
//
//  Created by Daniil Belikov on 18.10.2019.
//  Copyright © 2019 Tolyatti City Hospital No.1. All rights reserved.
//

import UIKit

extension UITextField {
    // Change the appearance of Text Field.
    func applyShadowTextField() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 4.0
        clipsToBounds = false
    }
    
    func addDoneButton(title: String, target: Any, selector: Selector) {
        // Add the Done button above the keyboard (Phone number Text Field).
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))
        
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                       target: nil,
                                       action: nil)
        
        let barButton = UIBarButtonItem(title: title,
                                        style: .plain,
                                        target: target,
                                        action: selector)
        
        barButton.tintColor = #colorLiteral(red: 0.2431372549, green: 0.6352941176, blue: 0.8470588235, alpha: 1)
        
        toolBar.setItems([flexible, barButton], animated: false)
        
        inputAccessoryView = toolBar
    }
    
}
