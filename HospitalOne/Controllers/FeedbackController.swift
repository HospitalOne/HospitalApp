//
//  FeedbackController.swift
//  HospitalOne
//
//  Created by Daniil Belikov on 18.10.2019.
//  Copyright © 2019 Tolyatti City Hospital No.1. All rights reserved.
//

import CoreData
import UIKit

protocol DataPassProtocol: AnyObject {
    func updateData()
    
}

final class FeedbackController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var whiteView: UIView!
    @IBOutlet private weak var switchMode: UISwitch!
    @IBOutlet private weak var nameText: UITextField!
    @IBOutlet private weak var surnameText: UITextField!
    @IBOutlet private weak var emailText: UITextField!
    @IBOutlet private weak var phoneNumberText: UITextField!
    @IBOutlet private weak var yourDoctorText: UITextField!
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var ratingStack: RatingStackView!
    @IBOutlet private weak var feedbackLabel: UILabel!
    @IBOutlet private weak var sendButton: UIButton!
    
    // MARK: - Public Properties
    
    let currentDate = Date()
    
    var selectedElement: String?
    var dischargeDate = ""
    
    // MARK: - Life Cycles Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDoneButton()
        setupObserver()
        textFieldDelegate()
        textViewDelegate()
        configureGestures()
        configureObjects()
        chooseElements()
        updateData()
    }
    
    // MARK: - Public Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ProfileController {
            vc.delegate = self
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func switchAction(_ sender: UISwitch) {
        setupSwitch(sender)
    }
    
    @IBAction func datePickerAction(_ sender: UIDatePicker) {
        setupDatePicker(sender)
    }
    
    @IBAction func sendAction(_ sender: UIButton) {
        feedbackRequest(sender)
    }
    
}

// MARK: - DataPass Protocol Methods

extension FeedbackController: DataPassProtocol {
    
    func updateData() {
        // Retrieving records.
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
                print(error)
            }
        }
    }
    
}

// MARK: - TextField/TextView Delegates Methods

extension FeedbackController: UITextFieldDelegate,
                              UITextViewDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard by pressing the Done button (Text Fields).
        textField.resignFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        // Hide the keyboard by pressing the Done button (Text View).
        if (text == "\n") {
            view.endEditing(true)
            return false
        } else {
            return true
        }
    }
    
}
// MARK: - UIPickerView Methods

extension FeedbackController: UIPickerViewDataSource,
                              UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // Set the number of components in Picker View.
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        // Set the number of rows in the components.
        return Doctors.names.count
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        // Display the names of doctors on Picker View.
        return Doctors.names[row]
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        // Select the row in the component.
        selectedElement = Doctors.names[row]
        yourDoctorText.text = selectedElement
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    viewForRow row: Int,
                    forComponent component: Int,
                    reusing view: UIView?) -> UIView {
        // Change the characteristics of the text in the rows.
        var pickerViewLabel = UILabel()
        
        if let currentLabel = view as? UILabel {
            pickerViewLabel = currentLabel
        } else {
            pickerViewLabel = UILabel()
        }
        
        pickerViewLabel.textColor = .black
        pickerViewLabel.textAlignment = .center
        pickerViewLabel.text = Doctors.names[row]
        
        return pickerViewLabel
    }
    
}

// MARK: - Private Configure Methods

private extension FeedbackController {
    
    func setupSwitch(_ sender: UISwitch) {
        if sender.isOn {
            configureSwitch(text: "Is hidden".localize(),
                            interaction: false,
                            color: #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1),
                            label: "Anonymous reviews are noted, but do not affect our decisions.".localize())
        } else {
            configureSwitch(text: "",
                            interaction: true,
                            color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
                            label: "Reviews with profanity, threats or insults will not be considered.".localize())
            updateData()
        }
    }
    
    func setupDatePicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateStyle = .long
        
        let dateValue = dateFormatter.string(from: sender.date)
        dischargeDate = dateValue
    }
    
    func feedbackRequest(_ sender: UIButton) {
        guard nameText.text?.isEmpty == false else {
            sender.shake()
            showAlertOnFeedback(title: "Error".localize(),
                                message: "Enter your name or enable anonymous mode.".localize())
            return
        }
        
        guard surnameText.text?.isEmpty == false else {
            sender.shake()
            showAlertOnFeedback(title: "Error".localize(),
                                message: "Enter your surname or enable anonymous mode.".localize())
            return
        }
        
        guard emailText.text?.isEmpty == false else {
            sender.shake()
            showAlertOnFeedback(title: "Error".localize(),
                                message: "Enter an E-mail or enable anonymous mode.".localize())
            return
        }
        
        guard phoneNumberText.text?.isEmpty == false else {
            sender.shake()
            showAlertOnFeedback(title: "Error".localize(),
                                message: "Enter a phone number or enable anonymous mode.".localize())
            return
        }
        
        guard yourDoctorText.text?.isEmpty == false else {
            sender.shake()
            showAlertOnFeedback(title: "Error".localize(), message: "Choose your doctor or enable anonymous mode.".localize())
            return
        }
        
        if let _ = Double(nameText.text ?? "") {
            sender.shake()
            showAlertOnFeedback(title: "Wrong format".localize(), message: "Enter text instead of numbers in the Name field.".localize())
            
        } else if let _ = Double(surnameText.text ?? "") {
            sender.shake()
            showAlertOnFeedback(title: "Wrong format".localize(), message: "Enter text instead of numbers in the Surname field.".localize())
            
        } else if let _ = Double(emailText.text ?? "") {
            sender.shake()
            showAlertOnFeedback(title: "Wrong format".localize(), message: "Enter text instead of numbers in the E-mail field.".localize())
            
        } else if let _ = Double(yourDoctorText.text ?? "") {
            sender.shake()
            showAlertOnFeedback(title: "Wrong format".localize(), message: "Enter text instead of numbers in the Your doctor field.".localize())
            
        } else {
            configureViewOut(hidden: false)
            datePickerAction(datePicker)
            
            // Show the Activity Indicator.
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0))
            activityIndicator.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
            activityIndicator.hidesWhenStopped = true
            activityIndicator.center = view.center
            activityIndicator.color = #colorLiteral(red: 0.2431372549, green: 0.6352941176, blue: 0.8470588235, alpha: 1)
            activityIndicator.startAnimating()
            
            view.addSubview(activityIndicator)
            view.isUserInteractionEnabled = false
            
            let os = ProcessInfo().operatingSystemVersion
            
            var components = URLComponents()
            components.host = "tgkb1.ru"
            components.path = "/send_feedback.php"
            components.scheme = "https"
            components.queryItems = [
                URLQueryItem(name: "name", value: nameText.text ?? ""),
                URLQueryItem(name: "surname", value: surnameText.text ?? ""),
                URLQueryItem(name: "email", value: emailText.text ?? ""),
                URLQueryItem(name: "phone_number", value: phoneNumberText.text ?? ""),
                URLQueryItem(name: "discharge_date", value: yourDoctorText.text ?? ""),
                URLQueryItem(name: "discharge_date", value: dischargeDate),
                URLQueryItem(name: "feedback", value: displayDefaultValue()),
                URLQueryItem(name: "rating", value: String(ratingStack.starsRating)),
                URLQueryItem(name: "platform", value: "iOS"),
                URLQueryItem(name: "os_version", value: os.getFullVersion()),
                URLQueryItem(name: "app_version", value: getAppCurrentVersion())
            ]
            
            guard let url = components.url else { return }
            
            let request = URLRequest(url: url)
            
            URLSession.shared.dataTask(with: request) { [weak self] data, _, _ in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                    
                    self.view.isUserInteractionEnabled = true
                    
                    self.configureViewOut(hidden: true)
                    
                    guard let data = data, let string = String(data: data, encoding: .utf8) else {
                        self.showAlertOnFeedback(title: "Connection error".localize(),
                                                 message: "Check your internet connection and try again.".localize())
                        return
                    }
                    
                    if string.contains("1") {
                        self.showAlertOnFeedback(title: "Feedback sent!".localize(),
                                                 message: "Thanks for your feedback. To become better, we read and parse each message.".localize())
                        self.resetAllParameters()
                    } else {
                        self.showAlertOnFeedback(title: "Connection error".localize(),
                                                 message: "Check your internet connection and try again.".localize())
                    }
                }
            }.resume()
        }
    }
    
    func showAlertOnFeedback(title: String,
                             message: String) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok".localize(),
                                     style: .default)
        
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    func configureSwitch(text: String,
                         interaction: Bool,
                         color: UIColor,
                         label: String) {
        
        nameText.text = text
        surnameText.text = text
        emailText.text = text
        phoneNumberText.text = text
        yourDoctorText.text = text
        
        nameText.isUserInteractionEnabled = interaction
        surnameText.isUserInteractionEnabled = interaction
        emailText.isUserInteractionEnabled = interaction
        phoneNumberText.isUserInteractionEnabled = interaction
        yourDoctorText.isUserInteractionEnabled = interaction
        
        nameText.backgroundColor = color
        surnameText.backgroundColor = color
        emailText.backgroundColor = color
        phoneNumberText.backgroundColor = color
        yourDoctorText.backgroundColor = color
        
        feedbackLabel.text = label
    }
    
    func configureViewOut(hidden: Bool) {
        whiteView.isHidden = hidden
    }
    
    func resetAllParameters() {
        // Reset parameters after sending feedback.
        if switchMode.isOn {
            configureSwitch(text: "Is hidden".localize(),
                            interaction: false,
                            color: #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1),
                            label: "Anonymous reviews are noted, but do not affect our decisions.".localize())
        } else {
            updateData()
            yourDoctorText.text = ""
        }
        
        textView.text = nil
        textView.textColor = UIColor.black
        
        datePicker.date = currentDate
        
        ratingStack.starsRating = 0
        ratingStack.setStarsRating(rating: 0)
    }
    
    func displayDefaultValue() -> String {
        // Display the default value of Text View in case the user has not left a review.
        if textView.text == "" {
            textView.text = "Is absent".localize()
            textView.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        
        guard let defaultText = textView.text else { return "Is absent".localize() }
        return defaultText
    }
    
    func getAppCurrentVersion() -> String {
        guard let value = Bundle.main.infoDictionary else { return "" }
        let NSObject: AnyObject? = value["CFBundleShortVersionString"] as AnyObject?
        return NSObject as! String
    }
    
    func setupDoneButton() {
        // Add Done button on Phone number Text Field.
        phoneNumberText.addDoneButton(title: "Done".localize(),
                                      target: self,
                                      selector: #selector(handleTap))
        
        // Add Done button on Your Doctors Text Field.
        yourDoctorText.addDoneButton(title: "Done".localize(),
                                     target: self,
                                     selector: #selector(handleTap))
    }
    
    func setupObserver() {
        // Add an observer when the keyboard appears.
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification,
                                               object: nil,
                                               queue: nil) { notification in
            
            if let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect {
                let insets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
                self.scrollView.scrollIndicatorInsets = insets
                self.scrollView.contentInset = insets
            }
        }
        
        // Add an observer when hiding the keyboard.
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification,
                                               object: nil,
                                               queue: nil) { notification in
            
            let insets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
            self.scrollView.scrollIndicatorInsets = insets
            self.scrollView.contentInset = insets
        }
    }
    
    func textFieldDelegate() {
        nameText.delegate = self
        surnameText.delegate = self
        emailText.delegate = self
        phoneNumberText.delegate = self
        yourDoctorText.delegate = self
    }
    
    func textViewDelegate() {
        textView.delegate = self
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
    
    func configureObjects() {
        textView.text = ""
        
        feedbackLabel.text = "Reviews with profanity, threats or insults will not be considered.".localize()
        sendButton.layer.cornerRadius = 20.0
        
        configureViewOut(hidden: true)
        
        nameText.applyShadow()
        surnameText.applyShadow()
        emailText.applyShadow()
        phoneNumberText.applyShadow()
        yourDoctorText.applyShadow()
        
        backgroundView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        backgroundView.layer.borderWidth = 0.5
        backgroundView.layer.cornerRadius = 10.0
        
        backgroundView.applyShadow()
    }
    
    func chooseElements() {
        let elementPicker = UIPickerView()
        elementPicker.delegate = self
        
        yourDoctorText.inputView = elementPicker
    }
    
}
