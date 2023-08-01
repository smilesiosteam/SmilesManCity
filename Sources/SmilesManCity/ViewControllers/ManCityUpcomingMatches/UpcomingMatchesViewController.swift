//
//  UpcomingMatchesViewController.swift
//  
//
//  Created by Shmeel Ahmad on 26/07/2023.
//

import UIKit
import SmilesUtilities
import SmilesSharedServices
import Combine
import SmilesOffers
import SmilesStoriesManager

public class UpcomingMatchesViewController: UIViewController {
    
    // MARK: - OUTLETS -
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var contentTableView: UITableView!
    @IBOutlet weak var tableViewTopSpaceToHeaderView: NSLayoutConstraint!
    @IBOutlet weak var tableViewTopSpaceToSuperView: NSLayoutConstraint!
    
    // MARK: - PROPERTIES -
    var dataSource: SectionedTableViewDataSource?
    private var input: PassthroughSubject<UpcomingMatchesViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    private lazy var viewModel: UpcomingMatchesViewModel = {
        return UpcomingMatchesViewModel()
    }()
    private let categoryId: Int
    var upcomingMatchesSections: GetSectionsResponseModel?
    var sections = [UpcomingMatchesSectionData]()
    var isUserSubscribed: Bool? = nil
    

    var offersPage = 1 // For offers list pagination
    var offers = [OfferDO]()
    
    // MARK: - VIEW LIFECYCLE -
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigationBar()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    public init(categoryId: Int, isUserSubscribed: Bool? = nil) {
        self.categoryId = categoryId
        self.isUserSubscribed = isUserSubscribed
        super.init(nibName: "UpcomingMatchesViewController", bundle: Bundle.module)
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
        contentTableView.sectionFooterHeight = .leastNormalMagnitude
        if #available(iOS 15.0, *) {
            contentTableView.sectionHeaderTopPadding = CGFloat(0)
        }
        contentTableView.sectionHeaderHeight = UITableView.automaticDimension
        contentTableView.estimatedSectionHeaderHeight = 1
        contentTableView.delegate = self
        let upcomingMatchesCellRegistrable: CellRegisterable = UpcomingMatchesCellRegistration()
        upcomingMatchesCellRegistrable.register(for: contentTableView)
        
    }
    
    fileprivate func configureDataSource() {
        self.contentTableView.dataSource = self.dataSource
        DispatchQueue.main.async {
            self.contentTableView.reloadData()
        }
    }
    
    private func configureSectionsData(with sectionsResponse: GetSectionsResponseModel) {
        upcomingMatchesSections = sectionsResponse
        setUpNavigationBar()
        if let sectionDetailsArray = sectionsResponse.sectionDetails, !sectionDetailsArray.isEmpty {
            self.dataSource = SectionedTableViewDataSource(dataSources: Array(repeating: [], count: sectionDetailsArray.count))
        }
        if let topPlaceholderSection = sectionsResponse.sectionDetails?.first(where: { $0.sectionIdentifier == UpcomingMatchesSectionIdentifier.topPlaceholder.rawValue }) {
            headerImageView.setImageWithUrlString(topPlaceholderSection.backgroundImage ?? "")
        }
    
        setupUI()
        
    }
    
    func getSectionIndex(for identifier: UpcomingMatchesSectionIdentifier) -> Int? {
        
        return sections.first(where: { obj in
            return obj.identifier == identifier
        })?.index
        
    }
    
    
    private func setupUI() {
        self.contentTableView.addMaskedCorner(withMaskedCorner: [.layerMinXMinYCorner, .layerMaxXMinYCorner], cornerRadius: 20.0)
        self.contentTableView.backgroundColor = .white
        self.sections.removeAll()
        self.UpcomingMatchesAPICalls()
    }
    
    func setUpNavigationBar(isLightContent: Bool = true) {
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = isLightContent ? .clear : .white
        appearance.configureWithTransparentBackground()
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
        guard let headerData = upcomingMatchesSections?.sectionDetails?.first(where: { $0.sectionIdentifier == UpcomingMatchesSectionIdentifier.topPlaceholder.rawValue }) else { return }
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
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
    }
    
    @objc func onClickBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - VIEWMODEL BINDING -
extension UpcomingMatchesViewController {
    
    func bind(to viewModel: UpcomingMatchesViewModel) {
        input = PassthroughSubject<UpcomingMatchesViewModel.Input, Never>()
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                case .fetchSectionsDidSucceed(let sectionsResponse):
                    self?.configureSectionsData(with: sectionsResponse)
                    
                case .fetchSectionsDidFail(error: let error):
                    debugPrint(error.localizedDescription)
                    
                
                    
                case .fetchOffersCategoryListDidSucceed(let response):
                    self?.configureUpcomingMatchesOffers(with: response)
                    
                case .fetchOffersCategoryListDidFail(let error):
                    debugPrint(error.localizedDescription)
                    
                    
                    
                case .fetchTeamRankingsDidSucceed(let response):
                    self?.configureTeamRankings(with: response)
                    
                case .fetchTeamRankingsDidFail(let error):
                    debugPrint(error.localizedDescription)
                }
            }.store(in: &cancellables)
    }
    
}

// MARK: - SERVICE CALLS -
extension UpcomingMatchesViewController {
    
    private func getSections() {
        self.input.send(.getSections(categoryID: categoryId))
    }
    
    private func UpcomingMatchesAPICalls() {
        
        if let sectionDetails = self.upcomingMatchesSections?.sectionDetails, !sectionDetails.isEmpty {
            sections.removeAll()
            for (index, element) in sectionDetails.enumerated() {
                guard let sectionIdentifier = element.sectionIdentifier, !sectionIdentifier.isEmpty else {
                    return
                }
                if let section = UpcomingMatchesSectionIdentifier(rawValue: sectionIdentifier), section != .topPlaceholder {
                    sections.append(UpcomingMatchesSectionData(index: index, identifier: section))
                }
                switch UpcomingMatchesSectionIdentifier(rawValue: sectionIdentifier) {
                
                case .offerListing:
                    if let offersCategory = OffersCategoryResponseModel.fromFile() {
                        self.dataSource?.dataSources?[index] = TableViewDataSource.make(forNearbyOffers: offersCategory.offers ?? [], data: "#FFFFFF", isDummy: true, completion: nil)
                    }
                    
                    self.input.send(.getOffersCategoryList(pageNo: self.offersPage, categoryId: "\(self.categoryId)", searchByLocation: false, sortingType: "", subCategoryId: "", subCategoryTypeIdsList: []))
                case .teamRankings:
                    if let resp = TeamRankingResponseModel.fromFile() {
                        self.dataSource?.dataSources?[index] = TableViewDataSource.make(rankingsResponse: [resp], data: "#FFFFFF", isDummy:true, completion: nil)
                    }
                    
                    self.input.send(.getTeamRankings)
                case .topPlaceholder:break
                case .none:
                    break
                }
            }
        }
    }
}

// MARK: - TABLEVIEW DATASOURCE CONFIGURATION -
extension UpcomingMatchesViewController {
    
    private func configureUpcomingMatchesOffers(with response: OffersCategoryResponseModel) {
        let offers = getAllOffers(offersCategoryListResponse: response)
        if !offers.isEmpty {
            if let upcomingMatchesOffersIndex = getSectionIndex(for: .offerListing) {
                self.dataSource?.dataSources?[upcomingMatchesOffersIndex] = TableViewDataSource.make(forNearbyOffers: offers, offerCellType: .manCity, data: self.upcomingMatchesSections?.sectionDetails?[upcomingMatchesOffersIndex].backgroundColor ?? "#FFFFFF"
                ) { [weak self] isFavorite, offerId, indexPath in
                    

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
    
    fileprivate func configureHideSection<T>(for section: UpcomingMatchesSectionIdentifier, dataSource: T.Type) {
        if let index = getSectionIndex(for: section) {
            (self.dataSource?.dataSources?[index] as? TableViewDataSource<T>)?.models = []
            (self.dataSource?.dataSources?[index] as? TableViewDataSource<T>)?.isDummy = false
            
            self.configureDataSource()
        }
    }
    
}

extension UpcomingMatchesViewController {
    
    private func configureTeamRankings(with response: TeamRankingResponseModel) {
        if !response.data.isEmpty {
            if let teamRankingsIndex = getSectionIndex(for: .teamRankings) {
                self.dataSource?.dataSources?[teamRankingsIndex] = TableViewDataSource.make(rankingsResponse: [response], data: "#FFFFFF", completion: { teamRanking, indexPath in
                    
                })
                self.configureDataSource()
            }
        } else {
            self.configureHideSection(for: .teamRankings, dataSource: TeamRankingResponseModel.self)
        }
    }
}
