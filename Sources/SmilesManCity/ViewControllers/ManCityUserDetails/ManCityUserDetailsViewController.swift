//
//  ManCityUserDetailsViewController.swift
//  
//
//  Created by Abdul Rehman Amjad on 19/06/2023.
//

import UIKit
import SmilesUtilities
import SmilesLanguageManager

public class ManCityUserDetailsViewController: UIViewController {

    // MARK: - OUTLETS -
    @IBOutlet weak var firstNameTextField: TextFieldWithValidation!
    @IBOutlet weak var lastNameTextField: TextFieldWithValidation!
    @IBOutlet weak var mobileTextField: TextFieldWithValidation!
    @IBOutlet weak var emailTextField: TextFieldWithValidation!
    @IBOutlet weak var playerTextField: TextFieldWithValidation!
    @IBOutlet weak var referralTextField: TextFieldWithValidation!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    // MARK: - PROPERTIES -
    public static let moduleName = Bundle.module
    
    // MARK: - ACTIONS -
    
    @IBAction func yesPressed(_ sender: Any) {
        configureMatchSelection(isAttended: true)
    }
    
    @IBAction func noPressed(_ sender: Any) {
        configureMatchSelection(isAttended: false)
    }
    
    @IBAction func proceedPressed(_ sender: Any) {
        
        if isDataValid() {
            print("Data is valid")
        }
        
    }
    
    // MARK: - METHODS -
    public override func loadView() {
        super.loadView()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        
        setupTextFields()
        
    }
    
    private func setupUserData() {
        
        
        
    }
    
    private func setupTextFields() {
        
        
        
    }
    
    private func configureMatchSelection(isAttended: Bool) {
        
        yesButton.tintColor = isAttended ? UIColor(hex: "FF7300") : .black.withAlphaComponent(0.2)
        noButton.tintColor = isAttended ? .black.withAlphaComponent(0.2) : UIColor(hex: "FF7300")
        
    }
    
    private func isDataValid() -> Bool {
        
        let fields = [firstNameTextField, lastNameTextField, mobileTextField, emailTextField, playerTextField]
        for field in fields {
            if !field!.isDataValid {
                return false
            }
        }
        return true
        
    }

}
