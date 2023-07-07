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
    @IBOutlet weak var contentTableView: UITableView!
    
    
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
    private var subscriptionInfo: SubscriptionInfoResponse?
    private var userData: RewardPointsResponseModel?
    
    // MARK: - ACTIONS -
    
    
    // MARK: - VIEW LIFECYCLE -
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    public init(categoryId: Int, isUserSubscribed: Bool? = nil) {
        self.categoryId = categoryId
        self.isUserSubscribed = isUserSubscribed
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
        if let sectionDetailsArray = sectionsResponse.sectionDetails, !sectionDetailsArray.isEmpty {
            self.dataSource = SectionedTableViewDataSource(dataSources: Array(repeating: [], count: sectionDetailsArray.count))
        }
        if let topPlaceholderSection = sectionsResponse.sectionDetails?.first(where: { $0.sectionIdentifier == ManCitySectionIdentifier.topPlaceholder.rawValue }) {
            headerImageView.setImageWithUrlString(topPlaceholderSection.backgroundImage ?? "")
            setUpNavigationBar(headerData: topPlaceholderSection)
        }
        if let isUserSubscribed {
            if !isUserSubscribed {
                setupPreEnrollmentUI()
            } else {
                
            }
        } else {
            self.input.send(.getRewardPoints)
        }
//        configureDataSource()
//        manCityHomeAPICalls()
        
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
        
        
        
    }
    
    private func setUpNavigationBar(headerData: SectionDetailDO) {
        
        let imageView = UIImageView()
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 24),
            imageView.widthAnchor.constraint(equalToConstant: 24)
        ])
        imageView.setImageWithUrlString(headerData.iconUrl ?? "")
        imageView.tintColor = .white

        let locationNavBarTitle = UILabel()
        locationNavBarTitle.text = headerData.title
        locationNavBarTitle.textColor = .white
        locationNavBarTitle.fontTextStyle = .smilesHeadline4
        let hStack = UIStackView(arrangedSubviews: [imageView, locationNavBarTitle])
        hStack.spacing = 4
        hStack.alignment = .center
        self.navigationItem.titleView = hStack
        
        let btnBack: UIButton = UIButton(type: .custom)
        btnBack.backgroundColor = .white
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
    
    private func getSubscriptionInfo() {
        self.input.send(.getSubscriptionInfo)
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
                    
                    break
                case .offerListing:
                    break
                case .about:
                    break
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
            ManCityRouter.shared.pushUserDetailsVC(navVC: self.navigationController!, userData: self.userData, viewModel: self.viewModel)
        })
        configureDataSource()
        
    }
    
    private func configureFAQsDetails(with response: FAQsDetailsResponse) {
        
        dataSource?.dataSources?[1] = TableViewDataSource.make(forFAQs: response.faqsDetails ?? [], data: "#FFFFFF", completion: nil)
        configureDataSource()
        
    }
    
}
