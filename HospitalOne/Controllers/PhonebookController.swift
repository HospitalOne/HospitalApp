//
//  PhonebookController.swift
//  HospitalOne
//
//  Created by Daniil Belikov on 18.10.2019.
//  Copyright © 2019 Tolyatti City Hospital No.1. All rights reserved.
//

import UIKit

final class PhonebookController: UITableViewController {
    
    // MARK: - Private Properties
    
    private let contacts: [PhonebookContact] = Phonebook.contacts
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewColor()
    }
    
    // MARK: - UItabelView Methods
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        
        return contacts.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView
            .dequeueReusableCell(withIdentifier: "Cell",
                                 for: indexPath) as? PhonebookCell {
            
            cell.configure(with: contacts[indexPath.row])
            cell.indexDelegate = indexPath
            cell.cellDelegate = self
            
            return cell
        }
        return UITableViewCell()
    }
    
}

// MARK: - Phonebook Protocol Methods

extension PhonebookController: PhonebookCellProtocol {
    
    func pressButton(index: Int) {
        if let phone: URL = URL(string: "TEL://\(Phonebook.contacts[index].phone)") {
            UIApplication.shared.open(phone, options: [:], completionHandler: nil)
        }
    }
    
}

// MARK: - Private Configure Methods

private extension PhonebookController {
    
    func configureViewColor() {
        view.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
    }
    
}
