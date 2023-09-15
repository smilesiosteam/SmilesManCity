//
//  TeamNewsTableViewCell.swift
//  
//
//  Created by Abdul Rehman Amjad on 15/09/2023.
//

import UIKit

class TeamNewsTableViewCell: UITableViewCell {

    // MARK: - OUTLETS -
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var newsCollectionView: UICollectionView!
    
    
    // MARK: - PROPERTIES -
    var teamNewsResponse: TeamNewsResponse! {
        didSet {
            newsCollectionView.reloadData()
        }
    }
    var didTapCell: ((TeamNews) -> ())?
    
    // MARK: - ACTIONS -
    
    
    // MARK: - METHODS -
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
    
        newsCollectionView.register(UINib(nibName: String(describing: TeamNewsCollectionViewCell.self), bundle: .module), forCellWithReuseIdentifier: String(describing: TeamNewsCollectionViewCell.self))
        newsCollectionView.dataSource = self
        newsCollectionView.delegate = self
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 148, height: 218)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 16
        newsCollectionView.collectionViewLayout = layout
        
    }
    
    func setBackGroundColor(color: UIColor) {
        mainView.backgroundColor = color
    }
    
}

extension TeamNewsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teamNewsResponse.teamNews?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamNewsCollectionViewCell", for: indexPath) as? TeamNewsCollectionViewCell else { return UICollectionViewCell() }
        if let news = teamNewsResponse.teamNews?[indexPath.item] {
            cell.setupData(news: news)
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let news = teamNewsResponse.teamNews?[indexPath.item] {
            didTapCell?(news)
        }
    }
    
}
