//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

protocol FlippableView: UIView {
    var isFlipped: Bool { get set }
    var flipCompletionHandler: ((FlippableView) -> Void)? { get set }
    func flip()
}

class CardView<ShapeType: ShapeLayerProtocol>: UIView, FlippableView {
    
    //радиус закругления
    var cornerRadius = 20
    
    
    // представление с лицевой стороной карты
    lazy var frontSideView: UIView = getFrontSideView()
    // представление с обратной стороной карты
    lazy var backSideView: UIView = getBackSideView()
    
    //свойство используется для того,
    //чтобы определить положение игральной карточки
    var isFlipped = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    //замыкание, хранящиеся в этом свойстве,
    //позволит выполнить произвольный код после того, как карточка
    //будет перевернута
    var flipCompletionHandler: ((FlippableView) -> Void)?
    
    //метод будет ипользоваться для анимированного перевортота карточки
    func flip() {
        
        //Определение представления, которое будет скрытым после анимации
        let fromView = isFlipped ? frontSideView : backSideView
        //Определение представления, которое будет отображено после анимации
        let toView = isFlipped ? backSideView : frontSideView
        
        //Используется для создания анимации переворота
        //[.transitionFlipFromTop] - опции анимации в данном случае,
        //анимация переворота вокруг верхнего края
        UIView.transition(from: fromView, to: toView, duration: 0.5, options: [.transitionFlipFromTop], completion: {_ in
            //обработчик перевотора, вызывается после завершения анимации
            //вызывает зарегестрированный  обработчик перевортоа, если он установлен.
            //обработчик получает ссылку на сам объект CardView
            self.flipCompletionHandler?(self)
        })
        //инвертирует значение флага isFlipped. Если карта была лицевой,
        //теперь она станет обратной, и наоборот.
        isFlipped.toggle()
    }

    var color: UIColor
    
    init(frame: CGRect, color: UIColor) {
        self.color = color
        super.init(frame: frame)
        setupBorders()
    }
    
    override func draw(_ rect: CGRect) {
        
        //Удаляем существующие представления, чтобы избежать их повтороного добавления
        backSideView.removeFromSuperview()
        frontSideView.removeFromSuperview()
        
        //В зависимости от флага isFlipped добавляем
        //лицевую или обратную сторону представления
        if isFlipped {
            self.addSubview(backSideView)
            self.addSubview(frontSideView)
        } else {
            self.addSubview(frontSideView)
            self.addSubview(backSideView)
        }

    }
    
    // В данном случае, если он вызывается, программа завершится
    //с фатальной ошибкой, так как данный инициализатор не предполагается
    //использовать при декодировании из архива
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // внутренний отступ представления
    private let margin: Int = 10
    
    // возвращает представление для лицевой стороны карточки
    private func getFrontSideView() -> UIView {
        
        //Создается новое представление UIView с размерами равными
        //bounds (размерам текущего CardView).
        let view = UIView(frame: bounds)
        view.backgroundColor = .white
        
        //скругляем углы корневого слоя
        //Oбрезать все, что выходит за границы слоя.
        view.layer.masksToBounds = true
        view.layer.cornerRadius = CGFloat(cornerRadius)
        
        //Создается дополнительное под-представление shapeView внутри view.
        //Его размеры устанавливаются с учетом внутреннего отступа (margin) от границ view.
        let shapeView = UIView(frame: CGRect(
            x: margin,
            y: margin,
            width: Int(bounds.width) - margin * 2 ,
            height: Int(bounds.height) - margin * 2
        ))
        view.addSubview(shapeView)
        
        //Создается объект ShapeLayerProtocol (класс, соответствующий протоколу)
        //с использованием конкретного типа ShapeType, переданного в качестве
        //обобщенного параметра для CardView.
        //Созданный объект слоя добавляется на shapeView.
        let shapeLayer = ShapeType(size: shapeView.frame.size, fillColor: color.cgColor)
        shapeView.layer.addSublayer(shapeLayer)
        
        return view
    }
    
    enum Shape {
        case circle
        case line
    }
    
    // возвращает вью для обратной стороны карточки
    private func getBackSideView() -> UIView {
        let view  = UIView(frame: bounds)
        view.backgroundColor = .white
        //скругляем углы корневого слоя
        view.layer.masksToBounds = true
        view.layer.cornerRadius = CGFloat(cornerRadius)
        
        let shapes: [Shape] = [.circle, .line]
        
        //выбор случайного узора для рубашки
        switch shapes.randomElement() {
        case .circle:
            let layer = BackSideCircle(
                size: bounds.size,
                fillColor: UIColor.black.cgColor
            )
            view.layer.addSublayer(layer)
        case .line:
            let layer = BackSideLine(size: bounds.size, fillColor: UIColor.black.cgColor)
            view.layer.addSublayer(layer)
        default:
            break
        }
        return view
    }
    
    //настройка границ
    private func setupBorders() {
        //все подслои, выходящие за границы представления, будут обрезаны
        self.clipsToBounds = true
        self.layer.cornerRadius = CGFloat(cornerRadius)
        //Устанавливается толщина границы в 2 пикселя для корневого слоя
        self.layer.borderWidth = 2
        //Устанавливается цвет границы для корневого слоя в черный цвет.
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    private var anchorPointOne: CGPoint = CGPoint(x: 0, y: 0)
    
    private var startTouchPoint: CGPoint!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //Запоминаются начальные координаты frame.origin,
        //то есть начальная позиция CardView перед началом перемещения.
        startTouchPoint = frame.origin
        
        print(frame.origin)
//        print(self.responderChain())
        
        //Определяются текущие координаты касания в системе координат окна.
        let x = touches.first?.location(in: window).x ?? 0
        let y = touches.first?.location(in: window).y ?? 0
        
        //Задаются значения для anchorPointOne так, чтобы они представляли
        //разницу между текущими координатами касания и текущими координатами
        //верхнего левого угла CardView
        anchorPointOne.x = x - frame.minX
        anchorPointOne.y = y - frame.minY
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //Обновляются координаты frame.origin на основе текущего положения
        //касания и сохраненных значений anchorPointOne.
        //Это обеспечивает перемещение CardView по экрану
        //в соответствии с движением пальца.
        self.frame.origin.x = (touches.first?.location(in: window).x ?? 0) - anchorPointOne.x
        self.frame.origin.y = (touches.first?.location(in: window).y ?? 0) - anchorPointOne.y
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Если frame.origin после окончания жеста совпадает с начальными
        //координатами startTouchPoint, это означает, что пользователь
        //сделал простой тап на CardView (а не жест перемещения).
        if self.frame.origin == startTouchPoint {
            flip()
        }
    }
}
protocol ShapeLayerProtocol: CAShapeLayer {
    init(size: CGSize, fillColor: CGColor)
}

// Этот инициализатор реализован с использованием fatalError,
//что означает, что если кто-то попытается создать экземпляр этого протокола с помощью
//инициализатора init(), программа будет завершена с фатальной ошибкой и выведением сообщения
// "init() не может быть использован
extension ShapeLayerProtocol {
    init() {
        fatalError("init() не может быть использован")
    }
}

//Задняя сторона карточки с кругами
class BackSideCircle: CAShapeLayer, ShapeLayerProtocol {
    
    //Этот инициализатор объявлен с ключевым словом required,
    //что означает, что любой подкласс, который реализует этот протокол,
    //обязан реализовать этот инициализатор.
    //Когда подкласс протокола реализует этот инициализатор,
    //он также должен быть помечен как required.
    required init(size: CGSize, fillColor: CGColor) {
        
        // super.init() в данном контексте обеспечивает правильную
        //инициализацию базового класса CAShapeLayer перед выполнением
        //дополнительных настроек, определенных в инициализаторе класса BackSideCircle.
        super.init()
        
        let path = UIBezierPath()
        
        for _ in 1...15 {
            //координаты центра очередного круга
            let randomX = Int.random(in: 0...Int(size.width))
            let randomY = Int.random(in: 0...Int(size.height))
            let center = CGPoint(x: randomX, y: randomY)
            //смещаем указатель к центру круга
            path.move(to: center)
            //определяем случайный радиус
            let radius = Int.random(in: 5...15)
            //рисуем круг
            path.addArc(withCenter: center, radius: CGFloat(radius), startAngle: 0, endAngle: .pi*2, clockwise: true)
        }
        
        //Эти праметры содержит класс CAShapeLayer
        
        //Присвоение свойству path объекта CAShapeLayer пути,
        //созданного с использованием UIBezierPath.
        self.path = path.cgPath
        
        //Установка цвета обводки объекта CAShapeLayer
        //равным переданному цвету заливки.
        self.strokeColor = fillColor
        
        //Установка цвета заливки (fillColor) объекта CAShapeLayer
        //равным переданному цвету заливки
        self.fillColor = fillColor
        self.lineWidth = 1
    }
    
    // В данном случае, если он вызывается, программа завершится
    //с фатальной ошибкой, так как данный инициализатор не предполагается
    //использовать при декодировании из архива
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//задняя сторона карточки с линиями
class BackSideLine: CAShapeLayer, ShapeLayerProtocol {
    
    required init(size: CGSize, fillColor: CGColor) {
        super.init()
        
        let path = UIBezierPath()
        
        //рисуем 15 линий
        for _ in 1...15 {
            //координаты начала очередной линии
            let randomXStart = Int.random(in: 0...Int(size.width))
            let randomYStart = Int.random(in: 0...Int(size.height))
            
            //координаты конца очередной линиии
            let randomXEnd = Int.random(in: 0...Int(size.width))
            let randomYEnd = Int.random(in: 0...Int(size.height))
            
            //смещаем указазатель к началу линии
            path.move(to: CGPoint(x: randomXStart, y: randomYStart))
            
            //рисуем линию
            path.addLine(to: CGPoint(x: randomXEnd, y: randomYEnd))
        }
        //инициализируем созданный путь
        self.path = path.cgPath
        //изменяем стиль линий
        self.strokeColor = fillColor
        self.lineWidth = 3
        self.lineCap = .round
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class FillShape: CAShapeLayer, ShapeLayerProtocol {
    
    required init(size: CGSize, fillColor: CGColor) {
        super.init()
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        self.path = path.cgPath
        self.fillColor = fillColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CrossShape: CAShapeLayer, ShapeLayerProtocol {
    required init(size: CGSize, fillColor: CGColor) {
        super.init()
        
        //рисуем крест
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: size.width, y: size.height))
        path.move(to: CGPoint(x: size.width, y: 0))
        path.addLine(to: CGPoint(x: 0, y: size.height))

        self.path = path.cgPath
        self.strokeColor = fillColor
        self.lineWidth = 5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SquareShape: CAShapeLayer, ShapeLayerProtocol {
    
    required init(size: CGSize, fillColor: CGColor) {
        super.init()
        
        //сторона равна меньшей из сторон
        let edgeSize = ([size.width, size.height].min() ?? 0)
        
        //рисуем квадрат
        let rect = CGRect(
            x: 100,
            y: 300,
            width: edgeSize,
            height: edgeSize
        )
        
        let path = UIBezierPath(rect: rect)
        path.close()
        //инициализируем созданный путь
        self.path = path.cgPath
        self.fillColor = fillColor
        
    }
    required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
   }
}

class CircleShape: CAShapeLayer, ShapeLayerProtocol {
    
    required init(size: CGSize, fillColor: CGColor) {
        super.init()
        
        //рассчитываем данные для круга
        //радиус равен половине меньшей из сторон
        let radius = ([size.width, size.height].min() ?? 0) / 2
        //центр круга равен центрам каждой из сторон
        let centerX = size.width / 2
        let centerY = size.height / 2
        
        //рисуем круг
        let path = UIBezierPath(
            arcCenter: CGPoint(x: centerX, y: centerY),
            radius: radius,
            startAngle: 0,
            endAngle: .pi*2,
            clockwise: true
        )
        path.close()
        //инициализируем созданный путь
        self.path = path.cgPath
        self.fillColor = fillColor
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
