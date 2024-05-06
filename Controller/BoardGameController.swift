//
//  BoardGameController.swift
//  Cards
//
//  Created by Daniil Polenskii on 12.11.2023.
//

import UIKit
/// в результате высокой связанности Представления и Контроллера большую часть кода,
/// реализующего отображение элементов (который по факту должен быть частью Представления),
/// в действительноcти мы будем писать в классе Контроллера.

/// этот класс нужен для размещения игральной доски, кнопки и карточек на корневом представлении
class BoardGameController: UIViewController {
    
    override func loadView() {
        
        super.loadView()
        view.addSubview(startBoardGameView)
        startGame()
        view.backgroundColor = UIColor(named: "View")
        setupNavigationBar()
        configureRestartGameButton()
    }
    var cardsPairsCounts = 8
    
    lazy var game: Game = getNewGame()
    lazy var startBoardGameView = getBoardGameView()
    
    
    private func getBoardGameView() -> UIView {
        
        let margin: CGFloat = 10
        
        let boardView = UIView()
        
        boardView.frame.origin.x = margin
        let window = UIApplication.shared.windows[0]
        let topPadding = window.safeAreaInsets.top
        boardView.frame.origin.y = topPadding + margin + 40
        
        boardView.frame.size.width = UIScreen.main.bounds.width - margin*2
        let bottomPadding = window.safeAreaInsets.bottom
        boardView.frame.size.height = UIScreen.main.bounds.height - boardView.frame.origin.y - margin - bottomPadding
        
        boardView.layer.cornerRadius = 5
        boardView.layer.backgroundColor = UIColor(named: "PinkBoard")?.cgColor

        
        return boardView
    }
    
    
    private lazy var backGame = {
        let button = UIButton()
        button.setTitle("Back", for: .normal)
        button.backgroundColor = UIColor(named: "YellowButton")
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.systemYellow, for: .highlighted)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(endGame), for: .touchUpInside)
        return button
        
    }()
    
    
    private lazy var restartGame = {
        
        let button = UIButton()
        button.setTitle("Restart", for: .normal)
        button.backgroundColor = UIColor(named: "YellowButton")
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.systemYellow, for: .highlighted)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        return button
    }()
    
    
    @objc private func startGame() {
        game = getNewGame()
        let cards = getCardBy(modelData: game.cards)
        placeCardsOnBoard(cards)
        
    }
    
    @objc private func endGame() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupNavigationBar() {
        let restartButton = UIBarButtonItem(customView: restartGame)
        let backButton = UIBarButtonItem(customView: backGame)
        navigationItem.rightBarButtonItem = restartButton
        navigationItem.leftBarButtonItem = backButton
    }
    
    
    
   private func getNewGame() -> Game {
        
        let game = Game()
        game.cardsCount = self.cardsPairsCounts
        game.generateCards()
        return game
    }
    
    ///массив перевернутых карт
    private var flippedCards = [UIView]()
    
    ///здесь используеться метод get(), который возвращает сконфигурированную карточку, но метод getCardBy тоже нужно вызвать
    ///getCardBy возвращает массив сконфигурированных карточек
    ///этот метод вызываеться в @objc func startGame(_ sender: UIButton)
    private func getCardBy(modelData: [Card]) -> [UIView] {
        
        ///массив из пар карточек
        var cardViews = [UIView]()
        
        /// здесь лежит класс, с помощью которого можно получить сконфигурированную карточку
        let cardViewFactory = CardViewFactory()
        
        /// modelData это массив карточек
        /// Для каждой карточки генерируеться две одинаковые карточки для того, чтобы их сопоставить и эти карточки добавляются в переменную
        /// cardViews
        /// т.е по модели мы получаем массив сконфигурированных карточек 
        for (index, modelCard) in modelData.enumerated() {
            
            let cardOne = cardViewFactory.get(modelCard.type, withSize: cardSize, andColor: modelCard.color)
            cardOne.tag = index
            cardViews.append(cardOne)
            
            let cardTwo = cardViewFactory.get(modelCard.type, withSize: cardSize, andColor: modelCard.color)
            cardTwo.tag = index
            cardViews.append(cardTwo)
            
        }
        
//        ///не понимаю зачем нужен это цикл
//        for card in cardViews {
//            /// с помошью оператора as происходит проверка совместимости типов
//            /// т.е есть если карточка соответствует protocol FlippableView, то
//            /// в flipCompletionHandler помещается замыкание
//            (card as? FlippableView)?.flipCompletionHandler = {flippedCard in
//                flippedCard.superview?.bringSubviewToFront(flippedCard)
//            }
//        }
        
        for card in cardViews {
            
            /// в flipCompletionHandler помещаем замыкание
            (card as! FlippableView).flipCompletionHandler = { [self] flippedCard in
                
                ///переносим карточку вверх иерархии
                flippedCard.superview?.bringSubviewToFront(flippedCard)
                
                //добавляем или удаляем карточку
                if flippedCard.isFlipped {
                    self.flippedCards.append(flippedCard)
                } else {
                    if let cardIndex = self.flippedCards.firstIndex(of: flippedCard) {
                        self.flippedCards.remove(at: cardIndex)
                    }
                }
                if flippedCards.count == 2 {
                    let firstCard = game.cards[self.flippedCards.first!.tag]
                    let secondCard = game.cards[self.flippedCards.last!.tag]
                    
                    //если карточки одинаковые
                    if game.checkCards(firstCard, secondCard) {
                        
                        UIView.animate(withDuration: 1, animations: {
                            self.flippedCards.first!.layer.opacity = 0
                            self.flippedCards.last!.layer.opacity = 0
                        }, completion: {_ in
                            self.flippedCards.first!.removeFromSuperview()
                            self.flippedCards.last!.removeFromSuperview()
                            self.flippedCards = []
                        })
                    } else {
                        for card in self.flippedCards {
                            (card as! FlippableView).flip()
                        }
                    }
                }
            }
        }
        
        return cardViews
    }
    
    private var cardSize: CGSize {
        CGSize(width: 80, height: 120)
    }
    private var cardMaxXCoordinat: Int {
        Int(startBoardGameView.frame.width - cardSize.width)
    }
    private var cardMaxYCoordinat: Int {
        Int(startBoardGameView.frame.height - cardSize.height)
    }
    var cardViews = [UIView]()
    
    private func placeCardsOnBoard(_ cards: [UIView]) {
        
        for card in cardViews {
            card.removeFromSuperview()
        }
        cardViews = cards
        for card in cardViews {
            let randomXCoordinate = Int.random(in: 0...cardMaxXCoordinat)
            let randomYCoordinate = Int.random(in: 0...cardMaxYCoordinat)
            card.frame.origin = CGPoint(x: randomXCoordinate, y: randomYCoordinate)
            startBoardGameView.addSubview(card)
        }
    }
}

private extension BoardGameController {
    
    func configureRestartGameButton() {
        
        NSLayoutConstraint.activate([
            restartGame.widthAnchor.constraint(equalToConstant: 110),
            restartGame.heightAnchor.constraint(equalToConstant: 40),
            backGame.widthAnchor.constraint(equalToConstant: 110),
            backGame.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
