//
//  ManCityEnrollmentTableViewCell.swift
//  
//
//  Created by Abdul Rehman Amjad on 26/06/2023.
//

import UIKit
import SmilesUtilities
import SmilesLanguageManager

class ManCityEnrollmentTableViewCell: UITableViewCell {

    // MARK: - OUTLETS -
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var rewardsTableView: UITableView!
    @IBOutlet weak var bgView: UICustomView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var enrollButton: UICustomButton!
    
    // MARK: - PROPERTIES -
    private var benefits = [WhatYouGet]()
    private var rowHeight: CGFloat = 40
    private var spacing: CGFloat = 16
    var enrollPressed: (() -> Void)?
    
    // MARK: - ACTIONS -
    @IBAction func enrollPressed(_ sender: Any) {
        enrollPressed?()
    }
    
    
    // MARK: - METHODS -
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    private func setupViews() {
        setupTableView()
    }
    
    private func setupTableView() {
        
        rewardsTableView.registerCellFromNib(EnrollmentBenefitsTableViewCell.self, bundle: Bundle.module)
        rewardsTableView.delegate = self
        rewardsTableView.dataSource = self
        
    }
    
    func setupData(subscriptionData: SubscriptionInfoResponse) {
        
        logoImageView.setImageWithUrlString(subscriptionData.themeResources?.mancityImageURL ?? "", defaultImage: "manCity_logo")
        descriptionLabel.text = subscriptionData.lifestyleOffers?.first?.offerDescription
        pointsLabel.text = "\(subscriptionData.lifestyleOffers?.first?.pointsValue ?? 0) \(SmilesLanguageManager.shared.getLocalizedString(for: "PTS"))"
        priceLabel.text = "\(subscriptionData.lifestyleOffers?.first?.price ?? 0) \(SmilesLanguageManager.shared.getLocalizedString(for: "AED"))"
        enrollButton.setTitle(subscriptionData.themeResources?.mancitySubButtonText, for: .normal)
        benefits = subscriptionData.lifestyleOffers?.first?.benefits ?? []
        tableViewHeight.constant = (rowHeight + spacing) * CGFloat(benefits.count)
        rewardsTableView.reloadData()
        
    }
    
}

// MARK: - UITABLEVIEW DELEGATE & DATASOURCE -
extension ManCityEnrollmentTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return benefits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueCell(withClass: EnrollmentBenefitsTableViewCell.self, for: indexPath)
        cell.setupData(benefit: benefits[indexPath.row])
        return cell
        
    }
    
}
