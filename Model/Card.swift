//
//  Card.swift
//  Cards
//
//  Created by Daniil Polenskii on 12.11.2023.
//

import UIKit

enum CardColor: CaseIterable {
    case green
    case red
    case purple
    case orange
    case yellow
    case blue
}

enum CardType: CaseIterable {
    case circle
    case cross
    case square
    case fill
    case empty
}

typealias Card = (type: CardType, color: CardColor)
