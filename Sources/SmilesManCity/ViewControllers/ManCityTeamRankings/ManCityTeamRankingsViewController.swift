//
//  ManCityTeamRankingsViewController.swift
//  
//
//  Created by Abdul Rehman Amjad on 18/09/2023.
//

import UIKit
import SmilesLanguageManager
import SmilesUtilities
import SmilesFontsManager

class ManCityTeamRankingsViewController: UIViewController {

    // MARK: - OUTLETS -
    @IBOutlet weak var teamRankingsCollectionView: UICollectionView!
    
    // MARK: - PROPERTIES -
    private var gridLayout = StickyGridCollectionViewLayout()
    private var teamRankingRowsData: [TeamRankingRowData] = []
    var teamRankings: [TeamRanking]
    
    // MARK: - METHODS -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigationBar()
    }
    
    init(teamRankings: [TeamRanking]) {
        self.teamRankings = teamRankings
        super.init(nibName: "ManCityTeamRankingsViewController", bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollectionView() {
        
        gridLayout.stickyRowsCount = 1
        gridLayout.stickyColumnsCount = 1
        teamRankingsCollectionView.bounces = false
        teamRankingsCollectionView.collectionViewLayout = gridLayout
        teamRankingsCollectionView.register(UINib(nibName: String(describing: TeamRankingCollectionViewCell.self), bundle: .module), forCellWithReuseIdentifier: String(describing: TeamRankingCollectionViewCell.self))
        teamRankingsCollectionView.dataSource = self
        teamRankingsCollectionView.delegate = self
        teamRankingsCollectionView.showsVerticalScrollIndicator = false
        setupTeamRankingGrid()
        if SmilesLanguageManager.shared.currentLanguage == .ar {
            teamRankingsCollectionView.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        teamRankingsCollectionView.reloadData()
        
    }
    
    private func setupTeamRankingGrid() {
        
        teamRankingRowsData.removeAll()
        teamRankingRowsData.append(TeamRankingRowData(rankings: [
            TeamRankingColumnData(text: SmilesLanguageManager.shared.getLocalizedString(for: "TEAM")),
            TeamRankingColumnData(text: SmilesLanguageManager.shared.getLocalizedString(for: "P")),
            TeamRankingColumnData(text: SmilesLanguageManager.shared.getLocalizedString(for: "W")),
            TeamRankingColumnData(text: SmilesLanguageManager.shared.getLocalizedString(for: "D")),
            TeamRankingColumnData(text: SmilesLanguageManager.shared.getLocalizedString(for: "L")),
            TeamRankingColumnData(text: SmilesLanguageManager.shared.getLocalizedString(for: "GD")),
            TeamRankingColumnData(text: SmilesLanguageManager.shared.getLocalizedString(for: "Pts"))
        ]))
        teamRankings.forEach({ obj in
            teamRankingRowsData.append(TeamRankingRowData(rankings: [
                TeamRankingColumnData(text: obj.teamName, iconUrl: obj.imageURL), TeamRankingColumnData(text: obj.played?.string), TeamRankingColumnData(text: obj.won?.string), TeamRankingColumnData(text: obj.drawn?.string), TeamRankingColumnData(text: obj.lost?.string), TeamRankingColumnData(text: obj.goalDifference), TeamRankingColumnData(text: obj.points?.string)
            ]))
        })
        
    }
    
    private func setUpNavigationBar() {
        
        title = SmilesLanguageManager.shared.getLocalizedString(for: "Team Rankings")
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

// MARK: - COLLECTION VIEW DELEGATE & DATASOURCE -
extension ManCityTeamRankingsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        teamRankingRowsData.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        teamRankingRowsData[section].rankings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let ranking = teamRankingRowsData[indexPath.section].rankings[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamRankingCollectionViewCell", for: indexPath) as? TeamRankingCollectionViewCell else { return UICollectionViewCell() }
        cell.configureCell(with: ranking)
        if indexPath.section == 0 {
            cell.backgroundColor = UIColor(hex: "DADBEA")
        }
        else {
            cell.backgroundColor = indexPath.section % 2 == 0 ? UIColor(hex: "F2F2F2") : .white
            if indexPath.row == 0 {
                cell.prefixLbl.text = "\(indexPath.section)"
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: indexPath.row == 0 ? UIScreen.main.bounds.width*0.45 : 40, height: indexPath.section == 0 ? 48 : 64)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if let data = teamRankingResponse[indexPath.row] {
//            self.didTapCell?(data)
//        }
    }
    
}
