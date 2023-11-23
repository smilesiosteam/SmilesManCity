//
//  ManCityUserDetailsViewController.swift
//  
//
//  Created by Abdul Rehman Amjad on 19/06/2023.
//

import UIKit
import SmilesUtilities
import SmilesLanguageManager
import SmilesSharedServices
import Combine
import SmilesFontsManager
import SmilesLoader
import PhoneNumberKit

class ManCityUserDetailsViewController: UIViewController {

    // MARK: - OUTLETS -
    @IBOutlet weak var firstNameTextField: TextFieldWithValidation!
    @IBOutlet weak var lastNameTextField: TextFieldWithValidation!
    @IBOutlet weak var mobileTextField: TextFieldWithValidation!
    @IBOutlet weak var emailTextField: TextFieldWithValidation!
    @IBOutlet weak var playerTextField: TextFieldWithValidation!
    @IBOutlet weak var referralTextField: TextFieldWithValidation!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesLabel: UILocalizableLabel!
    @IBOutlet weak var proceedButton: UICustomButton!
    
    // MARK: - PROPERTIES -
    private var userData: RewardPointsResponseModel?
    private var viewModel: ManCityHomeViewModel!
    private var input: PassthroughSubject<ManCityHomeViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    private var players: [ManCityPlayer]?
    private var selectedPlayer: ManCityPlayer?
    private var proceedToPayment: ((String, String, Bool) -> Void)?
    private var isAttendedMatch: Bool? = false
    // MARK: - ACTIONS -
    
    @IBAction func yesPressed(_ sender: Any) {
        configureMatchSelection(isAttended: true)
    }
    
    @IBAction func noPressed(_ sender: Any) {
        configureMatchSelection(isAttended: false)
    }
    
    @IBAction func proceedPressed(_ sender: Any) {
        
        if isDataValid() {
            if let playerId = selectedPlayer?.playerID {
                proceedToPayment?(playerId, referralTextField.text ?? "", isAttendedMatch ?? false)
            }
        }
        
    }
    
    @IBAction func pickPlayerPressed(_ sender: Any) {
        presentPlayersList()
    }
    
    // MARK: - METHODS -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigationBar()
    }
    
    init(userData: RewardPointsResponseModel?, viewModel: ManCityHomeViewModel, proceedToPayment: @escaping ((String, String, Bool) -> Void)) {
        self.userData = userData
        self.viewModel = viewModel
        self.proceedToPayment = proceedToPayment
        super.init(nibName: "ManCityUserDetailsViewController", bundle: .module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        fontSetup()
        bind(to: viewModel)
        SmilesLoader.show(on: self.view)
        input.send(.getPlayersList)
        setupUserData()
        yesLabel.text = SmilesLanguageManager.shared.getLocalizedString(for: "Yes").capitalizingFirstLetter()
        setupTextFields()
        
    }
    
    private func fontSetup(){
        proceedButton.fontTextStyle = .smilesHeadline4
        firstNameTextField.fontTextStyle = .smilesTitle1
        lastNameTextField.fontTextStyle = .smilesTitle1
        mobileTextField.fontTextStyle = .smilesTitle1
        emailTextField.fontTextStyle = .smilesTitle1
        playerTextField.fontTextStyle = .smilesTitle1
        referralTextField.fontTextStyle = .smilesTitle1
    }
    
    private func setupTextFields() {
        
        playerTextField.placeholder = SmilesLanguageManager.shared.getLocalizedString(for: "Pick a player")
        playerTextField.validationType = [.requiredField(errorMessage: SmilesLanguageManager.shared.getLocalizedString(for: "Please pick a player"))]
        
    }
    
    private func setupUserData() {
        
        if let userData {
            firstNameTextField.text = userData.name?.components(separatedBy: " ").first ?? ""
            lastNameTextField.text = userData.name?.components(separatedBy: " ").last ?? ""
            if var phoneNumber = userData.phoneNumber {
                let firstChar = phoneNumber.prefix(1)
                if firstChar == "0" {
                    phoneNumber.replacingCharacter(value: "0", startIndexOffsetBy: 0, endIndexOffsetBy: 1, replaceWith: "971")
                }
                phoneNumber = PartialFormatter().formatPartial("+" + phoneNumber)
                mobileTextField.text = phoneNumber
            }
            emailTextField.text = userData.emailAddress
        } else {
            SmilesLoader.show(on: self.view)
            input.send(.getRewardPoints)
        }
        
    }
    
    private func configureMatchSelection(isAttended: Bool) {
        
        yesButton.tintColor = isAttended ? .clear : .black.withAlphaComponent(0.2)
        noButton.tintColor = isAttended ? .black.withAlphaComponent(0.2) : .clear
        let attendedImage = UIImage(named: "checkbox", in: .module, compatibleWith: nil)
        let unAttendedImage = UIImage(systemName: "circle")
        yesButton.setImage(isAttended ? attendedImage : unAttendedImage, for: .normal)
        noButton.setImage(isAttended ? unAttendedImage : attendedImage, for: .normal)
        isAttendedMatch = isAttended
        setProceedButtonEnabled()
        
    }
    
    private func isDataValid() -> Bool {
        
        var isValid = true
        let fields = [firstNameTextField, lastNameTextField, mobileTextField, emailTextField, playerTextField]
        for field in fields {
            if !field!.isDataValid {
                return false
            }
        }
        isValid = isAttendedMatch != nil
        return isValid
        
    }
    
    private func setUpNavigationBar() {
        
        title = SmilesLanguageManager.shared.getLocalizedString(for: "Your details")
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black, .font: SmilesFonts.circular.getFont(style: .bold, size: 16)]
        appearance.shadowImage = UIImage()
        appearance.shadowColor = .clear
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
        let btnBack: UIButton = UIButton(type: .custom)
        btnBack.setImage(UIImage(named: AppCommonMethods.languageIsArabic() ? "back_arrow_ar" : "back_arrow", in: .module, compatibleWith: nil), for: .normal)
        btnBack.addTarget(self, action: #selector(self.onClickBack), for: .touchUpInside)
        btnBack.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        let barButton = UIBarButtonItem(customView: btnBack)
        self.navigationItem.leftBarButtonItem = barButton
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
    }
    
    @objc func onClickBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setProceedButtonEnabled() {
        
        self.proceedButton.isEnabled = isDataValid()
        self.proceedButton.alpha = isDataValid() ? 1 : 0.5
        
    }
    
    private func presentPlayersList() {
        
        guard let players else { return }
        var playerNames = [String]()
        players.forEach { player in
            playerNames.append(player.playerName ?? "")
        }
        self.present(options: playerNames, heading: "Who is your favourite Mancity Player?") { [weak self] index in
            guard let self else { return }
            self.selectedPlayer = players[index]
            self.playerTextField.text = self.selectedPlayer!.playerName
            self.setProceedButtonEnabled()
        }
        
    }

}

// MARK: - VIEWMODEL BINDING -
extension ManCityUserDetailsViewController {
    
    func bind(to viewModel: ManCityHomeViewModel) {
        input = PassthroughSubject<ManCityHomeViewModel.Input, Never>()
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                guard let self else { return }
                SmilesLoader.dismiss(from: self.view)
                switch event {
                case .fetchRewardPointsDidSucceed(response: let response, _):
                    self.userData = response
                    self.setupUserData()
                case .fetchRewardPointsDidFail(error: let error):
                    debugPrint(error.localizedDescription)
                case .fetchPlayersDidSucceed(response: let response):
                    self.players = response.players
                case .fetchPlayersDidFail(error: let error):
                    debugPrint(error.localizedDescription)
                default: break
                }
            }.store(in: &cancellables)
    }
    
}
