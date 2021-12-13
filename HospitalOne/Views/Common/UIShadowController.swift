//
//  UIShadowController.swift
//  HospitalOne
//
//  Created by Daniil Belikov on 18.10.2019.
//  Copyright © 2019 Tolyatti City Hospital No.1. All rights reserved.
//

import UIKit

private enum Constants {
    static let shadowColor: CGColor = UIColor.black.cgColor
    static let shadowOffset: CGSize = CGSize(width: 0.0, height: 0.0)
    static let shadowOpacity: Float = 0.15
    static let shadowRadius: CGFloat = 4.0
    
}

final class UIShadowController: UINavigationController {
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeShadowNavigationBar()
        makeShadowTabBar()
    }
    
}

// MARK: - Private Configure Methods

private extension UIShadowController {
    
    func makeShadowNavigationBar() {
        // Change the appearance of Navigation Controller.
        navigationBar.layer.shadowColor = Constants.shadowColor
        navigationBar.layer.shadowOffset = Constants.shadowOffset
        navigationBar.layer.shadowOpacity = Constants.shadowOpacity
        navigationBar.layer.shadowRadius = Constants.shadowRadius
    }
    
    func makeShadowTabBar() {
        // Change the appearance of Tab Bar Controller.
        tabBarController?.tabBar.layer.shadowColor = Constants.shadowColor
        tabBarController?.tabBar.layer.shadowOffset = Constants.shadowOffset
        tabBarController?.tabBar.layer.shadowOpacity = Constants.shadowOpacity
        tabBarController?.tabBar.layer.shadowRadius = Constants.shadowRadius
    }
    
}
