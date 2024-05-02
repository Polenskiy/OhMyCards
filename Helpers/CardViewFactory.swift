//
//  CardViewFactory.swift
//  Cards
//
//  Created by Daniil Polenskii on 19.11.2023.
//

import UIKit

///т.е этот класс нужен для получения сконфигурированной карточки, для этого нужен слой, размер и цвет 
class CardViewFactory {
    
    ///т.е этот метод возвращает сконфигурированную карточку, только этот метод надо вызвать и
    ///поместить в его параметры тип карточки(круг, квадрат и т.д), цвет и размер.
    ///Этот метод вызывается в методе getCardBy в BoardGameController
    func get(_ shape: CardType, withSize size: CGSize, andColor color: CardColor) -> UIView {
        
        let frame = CGRect(origin: .zero, size: size)
        
        ///сюда прилетает какой-то цвет, когда мы вызовем этй функцию
        ///тогда эта функция возвращает цвет из кейса и здесь будет лежать рандомный цвет
        let viewColor = getViewColorBy(modelColor: color)
        
        /// в зависимости от того какой цвет положат в метод get,
        /// оператор switch веренет сконфигурированную карточку
        switch shape {
            
        case .circle:
            return CardView<CircleShape>(frame: frame, color: viewColor)
        case .cross:
            return CardView<CrossShape>(frame: frame, color: viewColor)
        case .square:
            return CardView<SquareShape>(frame: frame, color: viewColor)
        case .fill:
            return CardView<FillShape>(frame: frame, color: viewColor)
        case .empty:
            return CardView<EmptyCircleShape>(frame: frame, color: viewColor)
        }
    }
    
    ///Вместо параметра мы помещаем какой-либо цвет
    /// и фунция возвращает цвет фигуры на лицевой стороне карточки
    func getViewColorBy(modelColor: CardColor) -> UIColor {
        
        switch modelColor {
            
        case .green:
            return .systemGreen
        case .red:
            return .red
        case .purple:
            return .systemPurple
        case .orange:
            return .systemOrange
        case .yellow:
            return .systemYellow
        case .blue:
            return .systemBlue
        }
    }
}

