//
//  ManCityInviteFriendsViewController.swift
//  
//
//  Created by Abdul Rehman Amjad on 27/07/2023.
//

import UIKit
import SmilesUtilities
import Combine
import LottieAnimationManager
import SmilesLanguageManager
import SmilesFontsManager
import SmilesLoader

class ManCityInviteFriendsViewController: UIViewController {

    // MARK: - OUTLETS -
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var infoLbl: UILabel!
    @IBOutlet weak var detailsLbl: UILabel!
    @IBOutlet weak var notesLbl: UILabel!
    @IBOutlet weak var sendInviteBtn: UICustomButton!
    @IBOutlet weak var pinView: RectangularDashedView!
    @IBOutlet weak var pinLabel: UILabel!
    @IBOutlet weak var copyCodeBtn: UIButton!
    @IBOutlet weak var copyView: UIView!
    @IBOutlet weak var codeCopiedLbl: UILabel!
    @IBOutlet weak var copyToClipViewTopToPinView: NSLayoutConstraint!
    @IBOutlet weak var noteLblTopToPinView: NSLayoutConstraint!
    
    // MARK: - PROPERTIES -
    private var input: PassthroughSubject<ManCityInviteFriendsViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    private lazy var viewModel: ManCityInviteFriendsViewModel = {
        return ManCityInviteFriendsViewModel()
    }()
    private var response:InviteFriendsResponse?
    private var onInviteSent:()->Void = {}
    // MARK: - ACTIONS -
    @IBAction func copyCodePressed(_ sender: UIButton) {
        copyCodeBtn.isUserInteractionEnabled = false
        UIPasteboard.general.string = pinLabel.text
        showHideInfo(hide: false){
            self.showHideInfo(hide: true){
                self.copyCodeBtn.isUserInteractionEnabled = true
            }
        }
    }
    
    @IBAction func sendInvitePressed(_ sender: UIButton) {
        self.share(text: self.response?.inviteFriend.invitationText ?? "")
    }
    
    // MARK: - METHODS -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.bind(to: viewModel)
        input.send(.fetchInviteFriendsData)
        SmilesLoader.show(on: self.view)
        // Do any additional setup after loading the view.
    }
    
    init(onInviteSent:@escaping ()->Void) {
        self.onInviteSent = onInviteSent
        super.init(nibName: "ManCityInviteFriendsViewController", bundle: .module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigationBar()
    }
    
    func setupUI(){
        infoLbl.fontTextStyle = .smilesHeadline3
        detailsLbl.fontTextStyle = .smilesBody3
        pinLabel.fontTextStyle = .smilesTitle1
        notesLbl.fontTextStyle = .smilesBody3
        sendInviteBtn.fontTextStyle = .smilesTitle1
        copyView.isHidden = true
        pinView.dashColor = response != nil ? UIColor(red: 117/255, green: 66/255, blue: 142/255, alpha: 1) : .clear
        sendInviteBtn.isHidden = response == nil
        pinView.dashWidth = 2
        pinView.dashLength = 2
        pinView.betweenDashesSpace = 2
        pinLabel.text = response?.inviteFriend.referralCode
        if let urlStr = response?.inviteFriend.image, !urlStr.isEmpty {
            imgView.isHidden = false
            if urlStr.hasSuffix(".json") {
                LottieAnimationManager.showAnimationFromUrl(FromUrl: urlStr, animationBackgroundView: self.imgView, removeFromSuper: false, loopMode: .loop, shouldAnimate: true) { _ in }
            }else{
                self.imgView.setImageWithUrlString(urlStr)
            }
        }else{
            imgView.isHidden = true
        }
        infoLbl.text = response?.inviteFriend.title
        detailsLbl.text = response?.inviteFriend.subtitle
        notesLbl.text = response?.inviteFriend.additionalInfo
    }
    private func setUpNavigationBar() {
        
        title = SmilesLanguageManager.shared.getLocalizedString(for: "Invite a friend")
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black, .font: SmilesFonts.circular.getFont(style: .bold, size: 16)]
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
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
    
    func bind(to viewModel: ManCityInviteFriendsViewModel) {
        input = PassthroughSubject<ManCityInviteFriendsViewModel.Input, Never>()
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                case .getInviteFriendsDataDidSucceed(let response):
                    SmilesLoader.dismiss(from: self?.view ?? UIView())
                    self?.response = response
                    self?.setupUI()
                case .getInviteFriendsDataDidFail(error: let error):
                    debugPrint(error.localizedDescription)
                }
            }.store(in: &cancellables)
    }
    
    fileprivate func showHideInfo(hide:Bool, _ finished:@escaping ()->Void) {
        copyToClipViewTopToPinView.priority = hide ? .defaultLow : .defaultHigh
        noteLblTopToPinView.priority = hide ? .defaultHigh : .defaultLow
        copyView.isHidden=false
        UIView.transition(with: copyView, duration: 2.0, options: .transitionCrossDissolve) {
            self.copyView.alpha = hide ? 0 : 1
        } completion: { _ in
            self.copyView.isHidden = hide
            finished()
        }
    }
    
    func share(text:String) {
        if !text.isEmpty {
            onInviteSent()
            let shareItems = [text]
            let activityViewController = UIActivityViewController(activityItems: shareItems as [Any], applicationActivities: nil)
            
            // exclude some activity types from the list (optional)
            activityViewController.excludedActivityTypes = [UIActivity.ActivityType.postToWeibo,
                                                            UIActivity.ActivityType.print,
                                                            UIActivity.ActivityType.copyToPasteboard,
                                                            UIActivity.ActivityType.assignToContact,
                                                            UIActivity.ActivityType.saveToCameraRoll,
                                                            UIActivity.ActivityType.addToReadingList,
                                                            UIActivity.ActivityType.postToTencentWeibo,
                                                            UIActivity.ActivityType.airDrop]
            
            present(activityViewController, animated: true)
        }
    }
}
