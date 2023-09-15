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
import SmilesLanguageManager
import SmilesFontsManager

public class UpcomingMatchesViewController: UIViewController {
    
    // MARK: - OUTLETS -
    @IBOutlet weak var contentTableView: UITableView!
    
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
    
    // MARK: - VIEW LIFECYCLE -
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigationBar()
    }
    
    public init(categoryId: Int) {
        self.categoryId = categoryId
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
        setupUI()
        
    }
    
    func getSectionIndex(for identifier: UpcomingMatchesSectionIdentifier) -> Int? {
        
        return sections.first(where: { obj in
            return obj.identifier == identifier
        })?.index
        
    }
    
    
    private func setupUI() {
        self.sections.removeAll()
        self.UpcomingMatchesAPICalls()
    }
    
    private func setUpNavigationBar() {
        
        title = SmilesLanguageManager.shared.getLocalizedString(for: "Upcoming matches")
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
                if let section = UpcomingMatchesSectionIdentifier(rawValue: sectionIdentifier) {
                    sections.append(UpcomingMatchesSectionData(index: index, identifier: section))
                }
                switch UpcomingMatchesSectionIdentifier(rawValue: sectionIdentifier) {
                case .teamRankings:
                    if let rankings = TeamRankingResponseModel.fromModuleFile() {
                        self.dataSource?.dataSources?[index] = TableViewDataSource.make(rankingsResponse: [rankings], data:"#FFFFFF", isDummy:false, completion: nil)
                        self.configureDataSource()
                    }
                    self.input.send(.getTeamRankings)
                default: break
                }
            }
        }
        
    }
}

// MARK: - TABLEVIEW DATASOURCE CONFIGURATION -
extension UpcomingMatchesViewController {
    
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
        if !(response.teamRankings?.isEmpty ?? true) {
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
