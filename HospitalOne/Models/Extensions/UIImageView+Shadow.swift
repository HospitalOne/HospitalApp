//
//  UIImageView+Shadow.swift
//  HospitalOne
//
//  Created by Daniil Belikov on 18.10.2019.
//  Copyright © 2019 Tolyatti City Hospital No.1. All rights reserved.
//

import UIKit

extension UIImageView {
    // Change the appearance of Image View.
    func applyShadowWithCornerRadius(_ cornerRadious: CGFloat) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.cornerRadius = cornerRadious
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 4.0
        clipsToBounds = true
    }
    
}
