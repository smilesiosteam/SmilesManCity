//
//  File.swift
//  
//
//  Created by Shmeel Ahmad on 27/07/2023.
//

import UIKit
import SmilesUtilities
import SmilesLanguageManager

class TeamRankingTableViewCell: UITableViewCell {
    
    // MARK: - OUTLETS -
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    var gridLayout = StickyGridCollectionViewLayout()
    
    // MARK: - PROPERTIES -
    var teamRankingResponse: TeamRankingResponse! {
        didSet {
            setupTeamRankingGrid()
            collectionView.reloadData()
        }
    }
    private var teamRankingRowsData: [TeamRankingRowData] = []
    var didTapCell: ((TeamRanking) -> ())?
    private var recordsToShow = 5
    
    // MARK: - METHODS -
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        gridLayout.stickyRowsCount = 1
        gridLayout.stickyColumnsCount = 1
        collectionView.bounces = false
        collectionView.collectionViewLayout = gridLayout
        collectionView.register(UINib(nibName: String(describing: TeamRankingCollectionViewCell.self), bundle: .module), forCellWithReuseIdentifier: String(describing: TeamRankingCollectionViewCell.self))
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        if AppCommonMethods.languageIsArabic() {
            collectionView.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
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
        teamRankingResponse.teamRankings?.forEach({ obj in
            guard teamRankingRowsData.count < (recordsToShow + 1) else { return }
            teamRankingRowsData.append(TeamRankingRowData(rankings: [
                TeamRankingColumnData(text: obj.teamName, iconUrl: obj.imageURL), TeamRankingColumnData(text: obj.played?.string), TeamRankingColumnData(text: obj.won?.string), TeamRankingColumnData(text: obj.drawn?.string), TeamRankingColumnData(text: obj.lost?.string), TeamRankingColumnData(text: obj.goalDifference), TeamRankingColumnData(text: obj.points?.string)
            ]))
        })
        
    }
    
    func setBackGroundColor(color: UIColor) {
        mainView.backgroundColor = color
    }
    
}

// MARK: - COLLECTION VIEW DELEGATE & DATASOURCE -
extension TeamRankingTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
