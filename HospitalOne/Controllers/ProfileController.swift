//
//  ProfileController.swift
//  HospitalOne
//
//  Created by Daniil Belikov on 18.10.2019.
//  Copyright © 2019 Tolyatti City Hospital No.1. All rights reserved.
//

import CoreData
import UIKit

final class ProfileController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var nameText: UITextField!
    @IBOutlet private weak var surnameText: UITextField!
    @IBOutlet private weak var emailText: UITextField!
    @IBOutlet private weak var phoneNumberText: UITextField!
    @IBOutlet private weak var saveButton: UIButton!
    
    // MARK: - Public Properties
    
    let alertProvider = AlertProvider()
    
    weak var delegate: DataPassProtocol?
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureGestures()
        configureViews()
        configureTexts()
        addDoneButton()
        updateInCoreData()
    }
    
    // MARK: - IBActions
    
    @IBAction func saveAction(_ sender: UIButton) {
        saveInCoreData()
        showAlert()
    }
    
}

// MARK: - TextField Delegate Methods

extension ProfileController: UITextFieldDelegate {
    // Hide the keyboard by pressing the Done button (Text Fields).
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

// MARK: - Private Configure Methods

private extension ProfileController {
    
    func configureViews() {
        saveButton.layer.cornerRadius = 20.0
        
        nameText.applyShadow()
        surnameText.applyShadow()
        emailText.applyShadow()
        phoneNumberText.applyShadow()
    }
    
    func configureTexts() {
        infoLabel.text = "Fill out the profile and you do not have to enter data in the application.".localize()
    }
    
    func configureNavigationBar() {
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain,
                                                        target: nil, action: nil)
        }
    }
    
    func configureGestures() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func handleTap() {
        view.endEditing(true)
    }
    
    func addDoneButton() {
        // Add Done button on Phone number Text Field.
        phoneNumberText.addDoneButton(title: "Done".localize(),
                                      target: self,
                                      selector: #selector(handleTap))
    }
    
    func showAlert() {
        alertProvider.showAlert(on: self,
                                with: "Excellent!".localize(),
                                message: "Your data has been saved.".localize())
    }
    
}

// MARK: - Private CoreData Methods

private extension ProfileController {
    
    func updateInCoreData() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let container = appDelegate.persistentContainer
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
            
            do {
                guard let results = try container.viewContext.fetch(fetchRequest) as? [Person] else { return }
                
                for result in results {
                    nameText.text = result.name
                    surnameText.text = result.surname
                    emailText.text = result.email
                    phoneNumberText.text = result.phone
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func saveInCoreData() {
        guard let name = nameText.text,
              let surname = surnameText.text,
              let email = emailText.text,
              let phone = phoneNumberText.text,
              let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                  return
              }
        
        let container = appDelegate.persistentContainer
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        
        do {
            guard let results = try container.viewContext.fetch(fetchRequest) as? [Person] else { return }
            
            for result in results {
                container.viewContext.delete(result)
            }
        } catch {
            print(error)
        }

        let entityDescription = NSEntityDescription.entity(forEntityName: "Person",
                                                           in: container.viewContext)

        let managedObject = Person(entity: entityDescription!,
                                   insertInto: container.viewContext)
        
        managedObject.name = name
        managedObject.surname = surname
        managedObject.email = email
        managedObject.phone = phone
        
        appDelegate.saveContext()
        delegate?.updateData()
    }
    
}
