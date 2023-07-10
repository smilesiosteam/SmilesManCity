//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 08/07/2023.
//

import Foundation
import SmilesBaseMainRequestManager

class QuickAccessRequestModel: SmilesBaseMainRequest {
    
    // MARK: - PROPERTIES -
    var categoryId: Int?
    
    // MARK: - INITIALIZER -
    init(categoryId: Int?) {
        super.init()
        self.categoryId = categoryId
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    // MARK: - CODING KEYS
    enum CodingKeys: CodingKey {
        case categoryId
    }
    
    // MARK: - METHODS -
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.categoryId, forKey: .categoryId)
    }
}
