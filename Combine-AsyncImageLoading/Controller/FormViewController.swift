//
//  FormViewController.swift
//  Combine-AsyncImageLoading
//
//  Created by Asif Mujtaba on 7/12/22.
//

import UIKit
import Combine

class FormViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var secondNameTextField: UITextField!
    
    @IBOutlet weak var postCodeTextField: UITextField!
    @IBOutlet weak var firstAddressTextField: UITextField!
    @IBOutlet weak var countryNameTextField: UITextField!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var fullAddressLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    var subscriptions = Set<AnyCancellable>()
    
    @Published var fullName: String = ""
    @Published var fullAddress: String = ""
    @Published var countryName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubscriptions()
    }
    
    func addSubscriptions() {
        firstNameTextField.textPublisher
            .combineLatest(secondNameTextField.textPublisher)
            .sink { print($0); return self.fullName = $0 + " " + $1 }.store(in: &subscriptions)
        
        firstAddressTextField.textPublisher
            .combineLatest( postCodeTextField.textPublisher)
            .sink { self.fullAddress =  $0 + $1 }
            .store(in: &subscriptions)
        
        $fullName
            .map { $0 }
            .assign(to: \.text, on: nameLabel)
            .store(in: &subscriptions)
        
        $fullAddress
            .map { $0 }
            .assign(to: \.text, on: fullAddressLabel)
            .store(in: &subscriptions)
    }
}
