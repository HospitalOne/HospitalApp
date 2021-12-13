//
//  RatingStackView.swift
//  HospitalOne
//
//  Created by Daniil Belikov on 18.10.2019.
//  Copyright © 2019 Tolyatti City Hospital No.1. All rights reserved.
//

import UIKit

final class RatingStackView: UIStackView {
    
    // MARK: - Public Properties
    
    var starsRating = 0
    var starsFilledPicName = "star"
    var starsEmptyPicName = "emptyStar"
    
    // MARK: - Draw Method
    
    override func draw(_ rect: CGRect) {
        let starButtons = subviews.filter {
            $0 is UIButton
        }
        
        var starTag = 1
        
        for button in starButtons {
            if let button = button as? UIButton {
                button.setImage(UIImage(named: starsEmptyPicName), for: .normal)
                button.addTarget(self, action: #selector(pressed(sender:)), for: .touchUpInside)
                button.tag = starTag
                starTag = starTag + 1
            }
        }
        setStarsRating(rating: starsRating)
    }
    
    @objc
    func pressed(sender: UIButton) {
        setStarsRating(rating: sender.tag)
    }
    
}

// MARK: - Public Methods

extension RatingStackView {
    
    func setStarsRating(rating: Int) {
        starsRating = rating
        
        let stackSubViews = subviews.filter {
            $0 is UIButton
        }
        
        for subView in stackSubViews {
            if let button = subView as? UIButton {
                if button.tag > starsRating {
                    button.setImage(UIImage(named: starsEmptyPicName), for: .normal)
                } else {
                    button.setImage(UIImage(named: starsFilledPicName), for: .normal)
                }
            }
        }
    }
    
}
