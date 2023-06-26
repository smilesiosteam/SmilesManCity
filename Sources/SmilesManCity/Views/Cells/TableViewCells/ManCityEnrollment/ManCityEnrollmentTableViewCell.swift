//
//  ManCityEnrollmentTableViewCell.swift
//  
//
//  Created by Abdul Rehman Amjad on 26/06/2023.
//

import UIKit
import SmilesUtilities

class ManCityEnrollmentTableViewCell: UITableViewCell {

    // MARK: - OUTLETS -
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var rewardsTableView: UITableView!
    @IBOutlet weak var bgView: UICustomView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    // MARK: - PROPERTIES -
    private var rowHeight: CGFloat = 40
    private var numberOfCells = 3
    
    // MARK: - ACTIONS -
    @IBAction func enrollPressed(_ sender: Any) {
    }
    
    
    // MARK: - METHODS -
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTableView()
    }
    
    private func ssetupViews() {
        setupTableView()
    }
    
    private func setupTableView() {
        
        rewardsTableView.register(UINib(nibName: "EnrollmentBenefitsTableViewCell", bundle: Bundle.module), forCellReuseIdentifier: "EnrollmentBenefitsTableViewCell")
        rewardsTableView.delegate = self
        rewardsTableView.dataSource = self
        tableViewHeight.constant = rowHeight * CGFloat(numberOfCells)
        
    }
    
}

// MARK: - UITABLEVIEW DELEGATE & DATASOURCE -
extension ManCityEnrollmentTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return EnrollmentBenefitsTableViewCell()
    }
    
}
