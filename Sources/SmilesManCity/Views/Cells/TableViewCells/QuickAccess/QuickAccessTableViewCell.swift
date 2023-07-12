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
    @IBOutlet weak var manCityLogoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
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
        setupUI()
        setupCollectionView()
    }
    
    private func setupUI() {
        titleLabel.fontTextStyle = .smilesHeadline2
        titleLabel.textColor = .black
        
        descriptionLabel.fontTextStyle = .smilesBody3
        descriptionLabel.textColor = .black.withAlphaComponent(0.6)
    }
    
    private func setupCollectionView() {
        collectionView.register(UINib(nibName: String(describing: QuickAccessCollectionViewCell.self), bundle: Bundle.module), forCellWithReuseIdentifier: String(describing: QuickAccessCollectionViewCell.self))
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = setupCollectionViewLayout()
    }
    
    func setupCollectionViewLayout() ->  UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1)), subitems: [item])
            let outerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)), subitems: [group])
            outerGroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0)
            let section = NSCollectionLayoutSection(group: outerGroup)
            section.orthogonalScrollingBehavior = .continuous
            
            return section
        }
        
        return layout
    }
    
    func configureCell(with quickAccessResponse: QuickAccessResponseModel) {
        titleLabel.text = quickAccessResponse.quickAccess?.title
        descriptionLabel.text = quickAccessResponse.quickAccess?.subTitle
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
