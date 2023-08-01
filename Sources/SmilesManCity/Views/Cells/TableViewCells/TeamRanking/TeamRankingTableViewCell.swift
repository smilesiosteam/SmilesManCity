//
//  File.swift
//  
//
//  Created by Shmeel Ahmad on 27/07/2023.
//

import UIKit
import SmilesUtilities

class TeamRankingTableViewCell: UITableViewCell {
    public static let module = Bundle.module
    // MARK: - OUTLETS -
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    var gridLayout = StickyGridCollectionViewLayout()
    
    // MARK: - PROPERTIES -
    var teamRankingResponse: TeamRankingResponseModel! {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var didTapCell: ((TeamRanking) -> ())?
    
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
        collectionView.register(UINib(nibName: String(describing: TeamRankingCollectionViewCell.self), bundle: Bundle.module), forCellWithReuseIdentifier: String(describing: TeamRankingCollectionViewCell.self))
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
    }
    
}

extension TeamRankingTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        teamRankingResponse.data.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        teamRankingResponse.data[section].rankings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let ranking = self.teamRankingResponse.data[indexPath.section].rankings[indexPath.row]
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
