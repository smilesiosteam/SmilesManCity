//
//  ManCityBannerTableViewCell.swift
//  
//
//  Created by Abdul Rehman Amjad on 27/07/2023.
//

import UIKit

class ManCityBannerTableViewCell: UITableViewCell {

    // MARK: - OUTLETS -
    @IBOutlet weak var updatesCollectionView: UICollectionView!
    
    // MARK: - PROPERTIES -
    private var collectionsData: [Any]?
    
    // MARK: - ACTIONS -
    
    
    // MARK: - METHODS -
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        
        updatesCollectionView.register(nib: UINib(nibName: "ManCityNewsUpdatesCollectionViewCell", bundle: .module), forCellWithClass: ManCityBannerCollectionViewCell.self)
        updatesCollectionView.delegate = self
        updatesCollectionView.dataSource = self
        updatesCollectionView.collectionViewLayout = setupCollectionViewLayout()
        
    }
    
    private func setupCollectionViewLayout() ->  UICollectionViewCompositionalLayout {
        
        let layout = UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(138)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .paging
            return section
        }
        return layout
        
    }
    
}

// MARK: - UICOLLECTIONVIEW DELEGATE -
extension ManCityBannerTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionsData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ManCityBannerCollectionViewCell", for: indexPath) as! ManCityBannerCollectionViewCell
        return cell
        
    }
    
}
