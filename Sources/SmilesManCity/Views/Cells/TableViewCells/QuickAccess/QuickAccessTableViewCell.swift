//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 05/07/2023.
//

import UIKit

class QuickAccessTableViewCell: UITableViewCell {
    
    // MARK: - OUTLETS -
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - PROPERTIES -
    var collectionsData: [QuickAccessLink]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var didTapCell: ((QuickAccessLink) -> ())?
    
    // MARK: - METHODS -
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.register(UINib(nibName: String(describing: QuickAccessCollectionViewCell.self), bundle: Bundle.module), forCellWithReuseIdentifier: String(describing: QuickAccessCollectionViewCell.self))
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = setupCollectionViewLayout()
    }
    
    func setupCollectionViewLayout() ->  UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .absolute(187), heightDimension: .fractionalHeight(1)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .absolute(187), heightDimension: .fractionalHeight(1)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets.leading = 16
            return section
        }
        
        return layout
    }
}

extension QuickAccessTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionsData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let data = collectionsData?[indexPath.row] {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuickAccessCollectionViewCell", for: indexPath) as? QuickAccessCollectionViewCell else { return UICollectionViewCell() }
            cell.configureCell(with: data)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let data = collectionsData?[indexPath.row] {
            self.didTapCell?(data)
        }
    }
}
