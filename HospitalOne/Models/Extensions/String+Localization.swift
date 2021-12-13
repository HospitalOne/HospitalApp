//
//  String+Localization.swift
//  HospitalOne
//
//  Created by Daniil Belikov on 18.10.2019.
//  Copyright © 2019 Tolyatti City Hospital No.1. All rights reserved.
//

import UIKit

extension String {
    // Russian translation method.
    func localize() -> String {
        return NSLocalizedString(self, comment: "")
    }
    
}
