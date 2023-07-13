//
//  ManCityHomeViewController.swift
//  
//
//  Created by Abdul Rehman Amjad on 26/06/2023.
//

import UIKit
import SmilesUtilities
import SmilesSharedServices
import Combine

public class ManCityHomeViewController: UIViewController {
    
    // MARK: - OUTLETS -
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var contentTableView: UITableView!
    @IBOutlet weak var tableViewTopSpaceToHeaderView: NSLayoutConstraint!
    @IBOutlet weak var tableViewTopSpaceToSuperView: NSLayoutConstraint!
    
    // MARK: - PROPERTIES -
    var dataSource: SectionedTableViewDataSource?
    private var input: PassthroughSubject<ManCityHomeViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    private lazy var viewModel: ManCityHomeViewModel = {
        return ManCityHomeViewModel()
    }()
    private let categoryId: Int
    var manCitySections: GetSectionsResponseModel?
    var sections = [ManCitySectionData]()
    var isUserSubscribed: Bool? = nil
    var aboutVideoUrl: String?
    private var subscriptionInfo: SubscriptionInfoResponse?
    private var userData: RewardPointsResponseModel?
    private var proceedToPayment: ((BOGODetailsResponseLifestyleOffer, String, String) -> Void)?
    private var selectedIndexPath: IndexPath?
    private var offerFavoriteOperation = 0 // Operation 1 = add and Operation 2 = remove
    var offersPage = 1 // For offers list pagination
    
    // MARK: - ACTIONS -
    
    
    // MARK: - VIEW LIFECYCLE -
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    public init(categoryId: Int, isUserSubscribed: Bool? = nil, aboutVideoUrl: String? = nil, proceedToPayment: @escaping ((BOGODetailsResponseLifestyleOffer, String, String) -> Void)) {
        self.categoryId = categoryId
        self.isUserSubscribed = isUserSubscribed
        self.proceedToPayment = proceedToPayment
        self.aboutVideoUrl = aboutVideoUrl
        super.init(nibName: "ManCityHomeViewController", bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - METHODS -
    private func setupViews() {
        
        setupTableView()
        bind(to: viewModel)
        getSections()
        
    }
    
    private func setupTableView() {
        
        contentTableView.delegate = self
        let manCityCellRegistrable: CellRegisterable = ManCityHomeCellRegistration()
        manCityCellRegistrable.register(for: contentTableView)
        
    }
    
    fileprivate func configureDataSource() {
        self.contentTableView.dataSource = self.dataSource
        DispatchQueue.main.async {
            self.contentTableView.reloadData()
        }
    }
    
    private func configureSectionsData(with sectionsResponse: GetSectionsResponseModel) {
        manCitySections = sectionsResponse
        setUpNavigationBar()
        if let sectionDetailsArray = sectionsResponse.sectionDetails, !sectionDetailsArray.isEmpty {
            self.dataSource = SectionedTableViewDataSource(dataSources: Array(repeating: [], count: sectionDetailsArray.count))
        }
        if let topPlaceholderSection = sectionsResponse.sectionDetails?.first(where: { $0.sectionIdentifier == ManCitySectionIdentifier.topPlaceholder.rawValue }) {
            headerImageView.setImageWithUrlString(topPlaceholderSection.backgroundImage ?? "")
        }
    
        if let isUserSubscribed {
            if !isUserSubscribed {
                setupPreEnrollmentUI()
            } else {
                setupPostEnrollmentUI()
            }
        } else {
            self.input.send(.getRewardPoints)
        }
        
    }
    
    func getSectionIndex(for identifier: ManCitySectionIdentifier) -> Int? {
        
        return sections.first(where: { obj in
            return obj.identifier == identifier
        })?.index
        
    }
    
    private func setupPreEnrollmentUI() {
        
        self.dataSource = SectionedTableViewDataSource(dataSources: Array(repeating: [], count: 2))
        self.sections.removeAll()
        self.sections.append(ManCitySectionData(index: 0, identifier: .enrollment))
        self.sections.append(ManCitySectionData(index: 1, identifier: .FAQS))
        self.input.send(.getSubscriptionInfo)
        self.input.send(.getFAQsDetails(faqId: 9))
        
    }
    
    private func setupPostEnrollmentUI() {
        self.contentTableView.addMaskedCorner(withMaskedCorner: [.layerMinXMinYCorner, .layerMaxXMinYCorner], cornerRadius: 20.0)
        self.contentTableView.backgroundColor = .white
        self.sections.removeAll()
        self.manCityHomeAPICalls()
    }
    
    func setUpNavigationBar(isLightContent: Bool = true) {
        
        guard let headerData = manCitySections?.sectionDetails?.first(where: { $0.sectionIdentifier == ManCitySectionIdentifier.topPlaceholder.rawValue }) else { return }
        let imageView = UIImageView()
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 24),
            imageView.widthAnchor.constraint(equalToConstant: 24)
        ])
        imageView.tintColor = isLightContent ? .white : .black
        imageView.sd_setImage(with: URL(string: headerData.iconUrl ?? "")) { image, _, _, _ in
            imageView.image = image?.withRenderingMode(.alwaysTemplate)
        }

        let locationNavBarTitle = UILabel()
        locationNavBarTitle.text = headerData.title
        locationNavBarTitle.textColor = isLightContent ? .white : .black
        locationNavBarTitle.fontTextStyle = .smilesHeadline4
        let hStack = UIStackView(arrangedSubviews: [imageView, locationNavBarTitle])
        hStack.spacing = 4
        hStack.alignment = .center
        self.navigationItem.titleView = hStack
        
        let btnBack: UIButton = UIButton(type: .custom)
        btnBack.backgroundColor = isLightContent ? .white : UIColor(red: 226.0 / 255.0, green: 226.0 / 255.0, blue: 226.0 / 255.0, alpha: 1.0)
        btnBack.setImage(UIImage(named: AppCommonMethods.languageIsArabic() ? "back_icon_ar" : "back_icon", in: .module, compatibleWith: nil), for: .normal)
        btnBack.addTarget(self, action: #selector(self.onClickBack), for: .touchUpInside)
        btnBack.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        btnBack.layer.cornerRadius = btnBack.frame.height / 2
        btnBack.clipsToBounds = true
        let barButton = UIBarButtonItem(customView: btnBack)
        self.navigationItem.leftBarButtonItem = barButton
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
    }
    
    @objc func onClickBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - VIEWMODEL BINDING -
extension ManCityHomeViewController {
    
    func bind(to viewModel: ManCityHomeViewModel) {
        input = PassthroughSubject<ManCityHomeViewModel.Input, Never>()
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                case .fetchSectionsDidSucceed(let sectionsResponse):
                    self?.configureSectionsData(with: sectionsResponse)
                    
                case .fetchSectionsDidFail(error: let error):
                    debugPrint(error.localizedDescription)
                    
                case .fetchSubscriptionInfoDidSucceed(response: let response):
                    self?.configureEnrollment(with: response)
                    
                case .fetchSubscriptionInfoDidFail(error: let error):
                    debugPrint(error.localizedDescription)
                    
                case .fetchRewardPointsDidSucceed(response: let response, _):
                    self?.aboutVideoUrl = response.mcfcWelcomeVideoUrl
                    if response.mcfcSubscriptionStatus ?? false {
                        self?.setupPostEnrollmentUI()
                    } else {
                        self?.setupPreEnrollmentUI()
                    }
                    
                case .fetchRewardPointsDidFail(error: let error):
                    debugPrint(error.localizedDescription)
                    
                case .fetchFAQsDidSucceed(response: let response):
                    self?.configureFAQsDetails(with: response)
                    
                case .fetchFAQsDidFail(error: let error):
                    debugPrint(error.localizedDescription)
                    
                case .fetchQuickAccessListDidSucceed(let response):
                    self?.configureQuickAccessList(with: response)
                    
                case .fetchQuickAccessListDidFail(let error):
                    debugPrint(error.localizedDescription)
                    
                case .fetchOffersCategoryListDidSucceed(let response):
                    self?.configureManCityOffers(with: response)
                    
                case .fetchOffersCategoryListDidFail(let error):
                    debugPrint(error.localizedDescription)
                    
                default: break
                }
            }.store(in: &cancellables)
    }
    
}

// MARK: - SERVICE CALLS -
extension ManCityHomeViewController {
    
    private func getSections() {
        self.input.send(.getSections(categoryID: categoryId))
    }
    
    private func manCityHomeAPICalls() {
        
        if let sectionDetails = self.manCitySections?.sectionDetails, !sectionDetails.isEmpty {
            sections.removeAll()
            for (index, element) in sectionDetails.enumerated() {
                guard let sectionIdentifier = element.sectionIdentifier, !sectionIdentifier.isEmpty else {
                    return
                }
                if let section = ManCitySectionIdentifier(rawValue: sectionIdentifier), section != .topPlaceholder {
                    sections.append(ManCitySectionData(index: index, identifier: section))
                }
                switch ManCitySectionIdentifier(rawValue: sectionIdentifier) {
                case .quickAccess:
                    self.input.send(.getQuickAccessList(categoryId: self.categoryId))

                case .offerListing:
                    if let offersCategory = OffersCategoryResponseModel.fromFile() {
                        self.dataSource?.dataSources?[index] = TableViewDataSource.make(forNearbyOffers: offersCategory.offers ?? [], data: "#FFFFFF", isDummy: true, completion: nil)
                        configureDataSource()
                    }
                    self.input.send(.getOffersCategoryList(pageNo: self.offersPage, categoryId: "\(self.categoryId)", searchByLocation: false, sortingType: "", subCategoryId: "", subCategoryTypeIdsList: []))
                    
                case .about:
                    self.dataSource?.dataSources?[index] = TableViewDataSource.make(forAboutVideo: AboutVideo(videoUrl: ""), data: "#FFFFFF", isDummy: true)
                    configureDataSource()
                    if let aboutVideoUrl {
                        configureAboutVideo(with: AboutVideo(videoUrl: aboutVideoUrl))
                    }
                default: break
                }
            }
        }
        
    }
    
}

// MARK: - TABLEVIEW DATASOURCE CONFIGURATION -
extension ManCityHomeViewController {
    
    private func configureEnrollment(with response: SubscriptionInfoResponse) {
        
        self.subscriptionInfo = response
        dataSource?.dataSources?[0] = TableViewDataSource.make(forEnrollment: response, data: "#FFFFFF", isDummy: false, completion: { [weak self] in
            guard let self else {return}
            ManCityRouter.shared.pushUserDetailsVC(navVC: self.navigationController!, userData: self.userData, viewModel: self.viewModel) { (playerId, referralCode) in
                guard let offer = self.subscriptionInfo?.lifestyleOffers?.first else { return }
                self.proceedToPayment?(offer, playerId, referralCode)
            }
        })
        configureDataSource()
        
    }
    
    private func configureFAQsDetails(with response: FAQsDetailsResponse) {
        
        dataSource?.dataSources?[1] = TableViewDataSource.make(forFAQs: response.faqsDetails ?? [], data: "#FFFFFF", completion: nil)
        configureDataSource()
        
    }
    
    private func configureQuickAccessList(with response: QuickAccessResponseModel) {
        if let quickAccessIndex = getSectionIndex(for: .quickAccess) {
            dataSource?.dataSources?[quickAccessIndex] = TableViewDataSource.make(forQuickAccess: response, data: "#FFFFFF", completion: { quickAccessLink in
                debugPrint(quickAccessLink.redirectionUrl)
            })
            
            configureDataSource()
        }
    }
    
    private func configureAboutVideo(with response: AboutVideo) {
        if let aboutVideoIndex = getSectionIndex(for: .about) {
            dataSource?.dataSources?[aboutVideoIndex] = TableViewDataSource.make(forAboutVideo: response, data: "#FFFFFF")
            configureDataSource()
        }
    }
    
    private func configureManCityOffers(with response: OffersCategoryResponseModel) {
        let offers = getAllOffers(offersCategoryListResponse: response)
        if !offers.isEmpty {
            if let manCityOffersIndex = getSectionIndex(for: .offerListing) {
                self.dataSource?.dataSources?[manCityOffersIndex] = TableViewDataSource.make(forNearbyOffers: offers, offerCellType: .categoryDetails, data: self.manCitySections?.sectionDetails?[manCityOffersIndex].backgroundColor ?? "#FFFFFF"
                ) { [weak self] isFavorite, offerId, indexPath in
                    self?.selectedIndexPath = indexPath
//                    if !isGuestUser {
//                        self?.updateOfferWishlistStatus(isFavorite: isFavorite, offerId: offerId)
//                    } else {
//                        let guestVC = GuestUserLoginPopupRouter.setupModule()
//                        guestVC.prevNavigation = self?.navigationController
//                        guestVC.modalPresentationStyle = .overFullScreen
//                        self?.navigationController?.present(guestVC, animated: true)
//                    }
                    
                    self?.updateOfferWishlistStatus(isFavorite: isFavorite, offerId: offerId)
                }
                self.configureDataSource()
            }
        } else {
            if offers.isEmpty {
                self.configureHideSection(for: .offerListing, dataSource: OfferDO.self)
            }
        }
    }
    
    private func getAllOffers(offersCategoryListResponse: OffersCategoryResponseModel) -> [OfferDO] {
        
        let featuredOffers = offersCategoryListResponse.featuredOffers?.map({ offer in
            var _offer = offer
            _offer.isFeatured = true
            return _offer
        })
        var offers = [OfferDO]()
        if self.offersPage == 1 {
            offers.append(contentsOf: featuredOffers ?? [])
        }
        offers.append(contentsOf: offersCategoryListResponse.offers ?? [])
        return offers
        
    }
    
    fileprivate func configureHideSection<T>(for section: ManCitySectionIdentifier, dataSource: T.Type) {
        if let index = getSectionIndex(for: section) {
            (self.dataSource?.dataSources?[index] as? TableViewDataSource<T>)?.models = []
            (self.dataSource?.dataSources?[index] as? TableViewDataSource<T>)?.isDummy = false
//            self.mutatingSectionDetails.removeAll(where: { $0.sectionIdentifier == section.rawValue })
            
            self.configureDataSource()
        }
    }
    
    func updateOfferWishlistStatus(isFavorite: Bool, offerId: String) {
        offerFavoriteOperation = isFavorite ? 1 : 2
//        input.send(.updateOfferWishlistStatus(operation: offerFavoriteOperation, offerId: offerId))
    }
}
