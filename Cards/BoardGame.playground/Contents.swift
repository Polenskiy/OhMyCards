//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

//class MyViewController : UIViewController {
//    override func loadView() {
//        let view = UIView()
//        view.backgroundColor = .white
//
//        let label = UILabel()
//        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
//        label.text = "Hello World!"
//        label.textColor = .black
//        
//        view.addSubview(label)
//        self.view = view
//    }
//}
//class BoardGameController: UIViewController {
//    
//    
//    var cardsPairsCounts = 8
//    
//    //Для хранения настроенного экрана игры
//    lazy var game: Game = getNewGame()
//    //хранит ссылку на кнопку запуска игры
//    lazy var startButtonView = getStartButtonView()
//    //хранит ссылку на игровое поле
//    lazy var boardGameView = getBoardGameView()
//    
//    @objc func startGameFirst(_ sender: UIButton) {
//        print("Button was pressed")
//    }
//    
//    private func getNewGame() -> Game {
//        
//        let game = Game()
//        game.cardsCount = cardsPairsCounts
//        game.generateCards()
//        
//        return game
//    }
//    
//    //Метод для создания кнопки
//    private func getStartButtonView() -> UIButton {
//        // 1
//        // Создаем кнопку
//        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
//        // 2
//        // Изменяем положение кнопки
//        button.center.x = view.center.x
//        
//        //Получаем доступ к текущему окну
//        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
//            let window = UIWindow(windowScene: windowScene)
//            // определяем отступ сверху от границ окна до Safe Area
//            let topPadding = window.safeAreaInsets.top
//            // устанавливаем координату Y кнопки в соответствии с отступом
//            button.frame.origin.y = topPadding
//        }
//        
//        // 3
//        // Настраиваем внешний вид кнопки
//        
//        // устанавливаем текст
//        button.setTitle("Начать игру", for: .normal)
//        // устанавливаем цвет текста для обычного (не нажатого) состояния
//        button.setTitleColor(.black, for: .normal)
//        // устанавливаем цвет текста для нажатого состояния
//        button.setTitleColor(.gray, for: .highlighted)
//        // устанавливаем фоновый цвет
//        button.backgroundColor = .systemGray4
//        // скругляем углы
//        button.layer.cornerRadius = 10
//        
//        //Подключаем обработчик нажатия на кнопку
//        button.addTarget(nil, action: #selector(startGameFirst(_:)), for: .touchUpInside)
//        
//        return button
//    }
//    
//    private func getBoardGameView() -> UIView {
//        //отступ игрового поля от ближайших элементов
//        let margin: CGFloat = 10
//        
//        let boardView = UIView()
//        
//        //указываем координаты x
//        boardView.frame.origin.x = margin
//        //указываем координаты y
//        let window = UIApplication.shared.windows[0]
//        
//        // определяем отступ сверху от границ окна до Safe Area
//        let topPadding = window.safeAreaInsets.top
//        boardView.frame.origin.y = topPadding + startButtonView.frame.height - boardView.frame.origin.y + margin
//        
//        // рассчитываем ширину
//        boardView.frame.size.width = UIScreen.main.bounds.width - margin*2
//        // рассчитываем высоту
//        // c учетом нижнего отступа
//        let bottomPadding = window.safeAreaInsets.bottom
//        boardView.frame.size.height = UIScreen.main.bounds.height - boardView.frame.origin.y - margin - bottomPadding
//        
//        //изменяем стиль игрового поля
//        boardView.layer.cornerRadius = 5
//        boardView.backgroundColor = UIColor(red: 0.1, green: 0.9, blue: 0.1, alpha: 0.3)
//        
//        return boardView
//    }
//    
//    // генерация массива карточек на основе данных Модели
//    private func getCardsBy(modelData: [Card]) -> [UIView] {
//        // хранилище для представлений карточек
//        var cardViews = [UIView]()
//        // фабрика карточек
//        let cardViewFactory = CardViewFactory()
//        // перебираем массив карточек в Модели
//        for (index, modelCard) in modelData.enumerated() {
//            let cardOne = cardViewFactory.get(modelCard.type, withSize: cardSize, andColor: modelCard.color)
//            cardOne.tag = index
//            cardViews.append(cardOne)
//            
//            let cardTwo = cardViewFactory.get(modelCard.type, withSize: cardSize, andColor: modelCard.color)
//            cardTwo.tag = index
//            cardViews.append(cardTwo)
//        }
//        // добавляем всем картам обработчик переворота
//        for card in cardViews {
//            (card as! FlippableView).flipCompletionHandler = { flippedCard in
//                // переносим карточку вверх иерархии
//                flippedCard.superview?.bringSubviewToFront(flippedCard)
//            }
//        }
//        return cardViews
//    }
//    
//    override func loadView() {
//        super.loadView()
//        view.addSubview(getStartButtonView())
//        
//        view.addSubview(getBoardGameView())
//    }
//}
//
//// Present the view controller in the Live View window
//PlaygroundPage.current.liveView = MyViewController()
