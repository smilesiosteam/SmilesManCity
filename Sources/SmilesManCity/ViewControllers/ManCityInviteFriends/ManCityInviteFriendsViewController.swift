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
    
    // MARK: - PROPERTIES -
    private var input: PassthroughSubject<ManCityInviteFriendsViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    private lazy var viewModel: ManCityInviteFriendsViewModel = {
        return ManCityInviteFriendsViewModel()
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI(response: nil)
        self.bind(to: viewModel)
        input.send(.fetchInviteFriendsData)
        // Do any additional setup after loading the view.
    }
    
    init() {
        super.init(nibName: "ManCityInviteFriendsViewController", bundle: .module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(response:InviteFriendsResponse?){
        infoLbl.fontTextStyle = .smilesTitle1
        detailsLbl.fontTextStyle = .smilesBody3
        pinLabel.fontTextStyle = .smilesTitle1
        notesLbl.fontTextStyle = .smilesBody3
        sendInviteBtn.fontTextStyle = .smilesTitle1
        copyView.isHidden = true
        pinView.dashColor = UIColor(red: 117/255, green: 66/255, blue: 142/255, alpha: 1)
        pinView.dashWidth = 2
        pinView.dashLength = 2
        pinView.betweenDashesSpace = 2
        pinLabel.textColor = .black
        pinLabel.text = response?.inviteFriend.referralCode
        if let urlStr = response?.inviteFriend.image, !urlStr.isEmpty {
            if urlStr.hasSuffix(".json") {
                LottieAnimationManager.showAnimationFromUrl(FromUrl: urlStr, animationBackgroundView: self.imgView, removeFromSuper: false, loopMode: .loop, shouldAnimate: true) { _ in }
            }else{
                self.imgView.setImageWithUrlString(urlStr)
            }
        }
        infoLbl.text = response?.inviteFriend.title
        detailsLbl.text = response?.inviteFriend.subtitle
        notesLbl.text = response?.inviteFriend.additionalInfo
        
    }
    func bind(to viewModel: ManCityInviteFriendsViewModel) {
        input = PassthroughSubject<ManCityInviteFriendsViewModel.Input, Never>()
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                case .getInviteFriendsDataDidSucceed(let response):
                    self?.setupUI(response: response)
                case .getInviteFriendsDataDidFail(error: let error):
                    debugPrint(error.localizedDescription)
                }
            }.store(in: &cancellables)
    }
    
    // MARK: - ACTIONS -
    
    fileprivate func showHideInfo(hide:Bool, _ finished:@escaping ()->Void) {
        copyView.isHidden=false
        UIView.transition(with: copyView, duration: 2.0, options: .transitionCrossDissolve) {
            self.copyView.alpha = hide ? 0 : 1
        } completion: { _ in
            self.copyView.isHidden = hide
            finished()
        }
    }
    
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
        
    }
    
    func share(text:String) {
        if !text.isEmpty {
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
            
            activityViewController.completionWithItemsHandler = { (activityType, completed: Bool, returnedItems: [Any]?, error: Error?) in
                self.navigationController?.popViewController()
            }
            
            present(activityViewController, animated: true)
        }
    }
}
