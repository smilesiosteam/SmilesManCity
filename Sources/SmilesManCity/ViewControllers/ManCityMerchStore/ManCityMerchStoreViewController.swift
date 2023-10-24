//
//  ManCityMerchStoreViewController.swift
//
//
//  Created by Abdul Rehman Amjad on 13/10/2023.
//

import UIKit
import AppHeader
import SmilesSharedServices
import Combine
import SmilesUtilities
import SmilesOffers

class ManCityMerchStoreViewController: UIViewController {

    // MARK: - OUTLETS -
    @IBOutlet weak var topHeaderView: AppHeaderView!
    @IBOutlet weak var contentTableView: UITableView!


    // MARK: - PROPERTIES -
    var dataSource: SectionedTableViewDataSource?
    private var input: PassthroughSubject<ManCityMerchStoreViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    private lazy var viewModel: ManCityMerchStoreViewModel = {
        return ManCityMerchStoreViewModel()
    }()
    private let categoryId: Int
    var merchStoreSections: GetSectionsResponseModel?
    var sections = [TableSectionData<ManCityMerchStoreSectionIdentifier>]()
    private var selectedOfferIndexPath: IndexPath?

    private var offerFavoriteOperation = 0 // Operation 1 = add and Operation 2 = remove
    var offersPage = 1 // For offers list pagination
    var offers = [OfferDO]()

    // MARK: - ACTIONS -

    // MARK: - VIEW LIFECYCLE -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    init(categoryId: Int) {
        self.categoryId = categoryId
        super.init(nibName: "ManCityMerchStoreViewController", bundle: Bundle.module)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - METHODS -
    private func setupHeaderView() {

//        topHeaderView.delegate = self
//        topHeaderView.setupHeaderView(backgroundColor: .appRevampEnableStateColor, searchBarColor: .white, pointsViewColor: nil, titleColor: .black, headerTitle: self.headerTitle.asStringOrEmpty(), showHeaderNavigaton: true, haveSearchBorder: true, shouldShowBag: true,isGuestUser:isGuestUser, toolTipInfo: nil)

    }

    private func setupViews() {

        setupTableView()
        bind(to: viewModel)
        input.send(.getSections(categoryID: categoryId))

    }

    private func setupTableView() {
        
        contentTableView.sectionHeaderHeight = UITableView.automaticDimension
        contentTableView.estimatedSectionHeaderHeight = 1
//        contentTableView.delegate = self
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
        
        merchStoreSections = sectionsResponse
        if let sectionDetailsArray = sectionsResponse.sectionDetails, !sectionDetailsArray.isEmpty {
            self.dataSource = SectionedTableViewDataSource(dataSources: Array(repeating: [], count: sectionDetailsArray.count))
        }
        if let topPlaceholderSection = sectionsResponse.sectionDetails?.first(where: { $0.sectionIdentifier == ManCityHomeSectionIdentifier.topPlaceholder.rawValue }) {
            self.topHeaderView.setHeaderTitle(title: topPlaceholderSection.title)
            if let iconURL = topPlaceholderSection.iconUrl {
                self.topHeaderView.headerTitleImageView.isHidden = false
                self.topHeaderView.setHeaderTitleIcon(iconURL: iconURL)
            }
            if let searchTag = topPlaceholderSection.searchTag {
                self.topHeaderView.setSearchText(with: searchTag)
            }
        }
        displayRewardPoints()

    }

    func getSectionIndex(for identifier: ManCityMerchStoreSectionIdentifier) -> Int? {

        return sections.first(where: { obj in
            return obj.identifier == identifier
        })?.index

    }
    
    private func displayRewardPoints() {
        if let rewardPoints = UserDefaults.standard.value(forKey: .rewardPoints) as? Int {
            self.topHeaderView.setPointsOfUser(with: rewardPoints.numberWithCommas())
        }
        
        if let rewardPointsIcon = UserDefaults.standard.value(forKey: .rewardPointsIcon) as? String {
            self.topHeaderView.setPointsIcon(with: rewardPointsIcon, shouldShowAnimation: false)
        }
    }

}

// MARK: - VIEWMODEL BINDING -
extension ManCityMerchStoreViewController {
    
    func bind(to viewModel: ManCityMerchStoreViewModel) {
        input = PassthroughSubject<ManCityMerchStoreViewModel.Input, Never>()
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                case .fetchSectionsDidSucceed(let sectionsResponse):
                    self?.configureSectionsData(with: sectionsResponse)
                    
                case .fetchSectionsDidFail(error: let error):
                    debugPrint(error.localizedDescription)
                    
                case .fetchOffersCategoryListDidSucceed(let response):
                    self?.configureManCityOffers(with: response)
                    
                case .fetchOffersCategoryListDidFail(let error):
                    debugPrint(error.localizedDescription)
                    
                case .emptyOffersListDidSucceed:
                    self?.offersPage = 1
                    self?.offers.removeAll()
                    self?.configureDataSource()
                    
                case .updateWishlistStatusDidSucceed(let updateWishlistResponse):
                    self?.configureWishListData(with: updateWishlistResponse)
                    
                case .updateWishlistStatusDidFail(let error):
                    print(error.localizedDescription)
                    
                }
            }.store(in: &cancellables)
    }
    
}

// MARK: - TABLEVIEW DATASOURCE CONFIGURATION -
extension ManCityMerchStoreViewController {
    
    private func configureManCityOffers(with response: OffersCategoryResponseModel) {
        let offers = getAllOffers(offersCategoryListResponse: response)
        if !offers.isEmpty {
            if let manCityOffersIndex = getSectionIndex(for: .offerListing) {
                self.dataSource?.dataSources?[manCityOffersIndex] = TableViewDataSource.make(forNearbyOffers: offers, offerCellType: .manCity, data: self.merchStoreSections?.sectionDetails?[manCityOffersIndex].backgroundColor ?? "#FFFFFF"
                ) { [weak self] isFavorite, offerId, indexPath in
                    self?.selectedOfferIndexPath = indexPath
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
    
    fileprivate func configureHideSection<T>(for section: ManCityMerchStoreSectionIdentifier, dataSource: T.Type) {
        if let index = getSectionIndex(for: section) {
            (self.dataSource?.dataSources?[index] as? TableViewDataSource<T>)?.models = []
            (self.dataSource?.dataSources?[index] as? TableViewDataSource<T>)?.isDummy = false
            
            self.configureDataSource()
        }
    }
    
    func updateOfferWishlistStatus(isFavorite: Bool, offerId: String) {
        offerFavoriteOperation = isFavorite ? 1 : 2
        self.input.send(.updateOfferWishlistStatus(operation: offerFavoriteOperation, offerId: offerId))
    }
    
    fileprivate func configureWishListData(with updateWishlistResponse: WishListResponseModel) {
        var isFavoriteOffer = false
        
        if let favoriteIndexPath = self.selectedOfferIndexPath {
            if let updateWishlistStatus = updateWishlistResponse.updateWishlistStatus, updateWishlistStatus {
                isFavoriteOffer = self.offerFavoriteOperation == 1 ? true : false
            } else {
                isFavoriteOffer = false
            }
            
            (self.dataSource?.dataSources?[favoriteIndexPath.section] as? TableViewDataSource<OfferDO>)?.models?[favoriteIndexPath.row].isWishlisted = isFavoriteOffer
            
            if let cell = contentTableView.cellForRow(at: favoriteIndexPath) as? RestaurantsRevampTableViewCell {
                cell.offerData?.isWishlisted = isFavoriteOffer
                cell.showFavouriteAnimation(isRestaurant: false)
            }
        }
    }
    
}
