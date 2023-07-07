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
    
    // MARK: - PROPERTIES -
    private var userData: RewardPointsResponseModel?
    private var viewModel: ManCityHomeViewModel!
    private var input: PassthroughSubject<ManCityHomeViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    private var players: [ManCityPlayer]?
    private var selectedPlayer: ManCityPlayer?
    
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
    
    @IBAction func pickPlayerPressed(_ sender: Any) {
        presentPlayersList()
    }
    
    // MARK: - METHODS -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    init(userData: RewardPointsResponseModel?, viewModel: ManCityHomeViewModel) {
        self.userData = userData
        self.viewModel = viewModel
        super.init(nibName: "ManCityUserDetailsViewController", bundle: .module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        setUpNavigationBar()
        bind(to: viewModel)
        setupTextFields()
        SmilesLoader.show(on: self.view)
        input.send(.getPlayersList)
        setupUserData()
        
    }
    
    private func setupUserData() {
        
        if let userData {
            firstNameTextField.text = userData.name?.components(separatedBy: " ").first ?? ""
            lastNameTextField.text = userData.name?.components(separatedBy: " ").last ?? ""
            mobileTextField.text = userData.phoneNumber
            emailTextField.text = userData.emailAddress
        } else {
            SmilesLoader.show(on: self.view)
            input.send(.getRewardPoints)
        }
        
    }
    
    private func setupTextFields() {
        
        
        
    }
    
    private func configureMatchSelection(isAttended: Bool) {
        
        yesButton.tintColor = isAttended ? .clear : .black.withAlphaComponent(0.2)
        noButton.tintColor = isAttended ? .black.withAlphaComponent(0.2) : .clear
        let attendedImage = UIImage(named: "checkbox", in: .module, compatibleWith: nil)
        let unAttendedImage = UIImage(systemName: "circle")
        yesButton.setImage(isAttended ? attendedImage : unAttendedImage, for: .normal)
        noButton.setImage(isAttended ? unAttendedImage : attendedImage, for: .normal)
        
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
    
    private func setUpNavigationBar() {
        
        navigationItem.title = "Your details"
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = .clear
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white, .font: SmilesFonts.circular.getFont(style: .bold, size: 16)]
            appearance.shadowColor = .clear
            appearance.shadowImage = UIImage()
            
            UINavigationBar.appearance().tintColor = .clear
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            UINavigationBar.appearance().overrideUserInterfaceStyle = .dark
            self.navigationController?.navigationItem.largeTitleDisplayMode = .never
            
        } else {
            UINavigationBar.appearance().tintColor = .clear
            UINavigationBar.appearance().barTintColor = .clear
            UINavigationBar.appearance().isTranslucent = false
        }
        let btnBack: UIButton = UIButton(type: .custom)
        btnBack.setImage(UIImage(named: AppCommonMethods.languageIsArabic() ? "back_arrow_ar" : "back_arrow", in: .module, compatibleWith: nil), for: .normal)
        btnBack.addTarget(self, action: #selector(self.onClickBack), for: .touchUpInside)
        btnBack.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        let barButton = UIBarButtonItem(customView: btnBack)
        self.navigationItem.leftBarButtonItem = barButton
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
    }
    
    @objc func onClickBack() {
        self.navigationController?.popViewController(animated: true)
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
