//
//  ViewBuilder.swift
//  Cards
//
//  Created by Daniil Polenskii on 02.05.2024.
//

import UIKit

class ViewBuilder {
    
    static let shared = ViewBuilder()
    
    private init() {}
    
    lazy var bannerImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.widthAnchor.constraint(equalToConstant: 282).isActive = true
        image.heightAnchor.constraint(equalToConstant: 112).isActive = true
        return image
        
    }()
}
