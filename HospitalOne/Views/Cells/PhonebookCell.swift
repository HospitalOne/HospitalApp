//
//  PhonebookCell.swift
//  HospitalOne
//
//  Created by Daniil Belikov on 18.10.2019.
//  Copyright © 2019 Tolyatti City Hospital No.1. All rights reserved.
//

import UIKit

final class PhonebookCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var positionLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var phoneLabel: UILabel!
    
    // MARK: - Public Properties
    
    var cellDelegate: PhonebookCellProtocol?
    var indexDelegate: IndexPath?
    
    // MARK: - IBActions
    
    @IBAction func buttonAction(_ sender: UIButton) {
        guard let index = indexDelegate?.row else { return }
        sender.flash()
        cellDelegate?.pressButton(index: index)
    }
    
}

// MARK: - Public Configure Methods

extension PhonebookCell {
    
    func configure(with model: PhonebookContact) {
        positionLabel.text = model.position
        nameLabel.text = model.name
        phoneLabel.text = model.phone
    }
    
}
