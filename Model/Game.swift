//
//  Game.swift
//  Cards
//
//  Created by Daniil Polenskii on 12.11.2023.
//

import UIKit



///Этот класс нужен для того, чтобы заполнить массив cards рандомными типами
///и цветами и + еще сравнить например первую и втору карточку - и говорит совподают они или нет 
class Game {
    
    var cardsCount = 0
    var cards = [Card]()
    
    func generateCards() {
        var cards = [Card]()
    
        for _ in 0...cardsCount {
            let randomElement = (type: CardType.allCases.randomElement()!, color: CardColor.allCases.randomElement()!)
            cards.append(randomElement)
        }
        self.cards = cards
    }
    
    func checkCards(_ firstCard: Card, _ secondCard: Card) -> Bool {
        if firstCard == secondCard {
            return true
        }
        return false
    }
}





