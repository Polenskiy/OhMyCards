//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

protocol ShapeLayerProtocol: CAShapeLayer {
    
    init(size: CGSize, fillColor: CGColor)
}

extension ShapeLayerProtocol {
    init() {
        fatalError("init() не может быть использован для создания экземпляра")
    }
}

extension UIResponder {
    func responderChain() -> String {
        guard let next = next else {
            return String(describing: Self.self)
        }
        return String(describing: Self.self) + "->" + next.responderChain()
    }
}

//переворчиваемый вид
protocol FlippableView: UIView {
    var isFlipped: Bool { get set }
    //обработчик завершения переворота
    var flipCompletionHandler: ((FlippableView) -> Void)? { get set }
    func flip()
}

class MyViewController : UIViewController {
    
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        self.view = view
        let firstCardView = CardView<EmptyCircleShape>(frame: CGRect(x: 100, y: 100, width: 120, height: 150), color: .red)
        
        firstCardView.flipCompletionHandler = { card in
            card.superview?.bringSubviewToFront(card)
        }
        
        let secondCardView = CardView<FillShape>(frame: CGRect(x: 100, y: 300, width: 120, height: 150), color: .green)
        
        secondCardView.flipCompletionHandler = { card in
            card.superview?.bringSubviewToFront(card)
        }
                
        self.view.addSubview(firstCardView)
        self.view.addSubview(secondCardView)
    }
}


class CardView<ShapeType: ShapeLayerProtocol>: UIView, FlippableView {
    
    private var margin: Int = 10
    
    //здесь хранятся передняя и задняя часть вьюшки
    lazy var frontSideView: UIView = self.getFrontSideView()
    lazy var backSideView: UIView = self.getBackSideView()
    
    ///Свойство isFlipped будет использоваться для того, чтобы определить,
    /// расположена ли игральная карточка лицевой стороной вверх или нет.
    var isFlipped: Bool = true {
        didSet {
            self.setNeedsDisplay()
        }
    }
    ///Замыкание, хранящееся в свойстве flipCompletionHandler,
    /// позволит выполнить произвольный код после того, как карточка будет перевернута.
    var flipCompletionHandler: ((FlippableView) -> Void)?
    var color: UIColor!
    
    init(frame: CGRect, color: UIColor) {
        super.init(frame: frame)
        self.color = color
        setupBorders()
    }
    
    override func draw(_ rect: CGRect) {
        frontSideView.removeFromSuperview()
        backSideView.removeFromSuperview()
        
        if isFlipped {
            self.addSubview(backSideView)
            self.addSubview(frontSideView)
        } else {
            self.addSubview(frontSideView)
            self.addSubview(backSideView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///Метод flip в дальнейшем будет использоваться для анимированного переворота карточки.
    func flip() {
        let fromView = isFlipped ? frontSideView : backSideView
        let toView = isFlipped ? backSideView : frontSideView
        
        UIView.transition(from: fromView, to: toView, duration: 0.5, options: [.transitionFlipFromLeft], completion: {_ in
            self.flipCompletionHandler?(self)
        })
        isFlipped = !isFlipped
        
    }
    
    var cornerRadius = 20
    
    private func setupBorders() {
        self.clipsToBounds = true
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    func getFrontSideView() -> UIView {
        
        let view = UIView(frame: self.bounds)
        
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = CGFloat(cornerRadius)
        view.clipsToBounds = true
        
        let shapeView = UIView(frame: CGRect(x: margin, y: margin, width: Int(self.bounds.width)-margin*2, height: Int(self.bounds.height)-margin*2))
        view.addSubview(shapeView)
        
        let shapeLayer = ShapeType(size: shapeView.frame.size, fillColor: color.cgColor)
        
        shapeView.layer.addSublayer(shapeLayer)
        
        return view
    }
    
    func getBackSideView() -> UIView {
        let view = UIView(frame: self.bounds)
        
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = CGFloat(cornerRadius)
        view.clipsToBounds = true
        
        switch ["circle", "line"].randomElement() ?? nil {
            
        case "circle":
            let layer = BackSideLine(size: self.bounds.size, fillColor: UIColor.orange.cgColor)
            view.layer.addSublayer(layer)
        case "line":
            let layer = BackSideCircle(size: self.bounds.size, fillColor: UIColor.orange.cgColor)
            view.layer.addSublayer(layer)
        default:
            break
        }
        return view
    }
    
    private var startTouchPoint: CGPoint!
    private var anchorPointTwo: CGPoint = CGPoint(x: 0, y: 0)

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        anchorPointTwo.x = touches.first!.location(in: window).x - frame.minX
        anchorPointTwo.y = touches.first!.location(in: window).y - frame.minY
        
        startTouchPoint = frame.origin
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.frame.origin.x = touches.first!.location(in: window).x - anchorPointTwo.x
        self.frame.origin.y = touches.first!.location(in: window).y - anchorPointTwo.y
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
//        UIView.animate(withDuration: 0.5) {
//            self.frame.origin = self.startTouchPoint
//        }
        if self.frame.origin == startTouchPoint {
            self.flip()
        }
    }
}

class BackSideCircle: CAShapeLayer, ShapeLayerProtocol {
    //В данном коде required используется для требования
    //чтобы все подклассы CircleShape обязательно реализовывали этот инициализатор
    required init(size: CGSize, fillColor: CGColor) {
        //
        super.init()
        
        let path = UIBezierPath()
        
        for _ in 1...15 {
            
            let radius = Int.random(in: 5...15)
            let centerX = Int.random(in: 0...Int(size.width))
            let centerY = Int.random(in: 0...Int(size.height))
            let center = CGPoint(x: centerX, y: centerY)
        
            path.move(to: center)
            
            path.addArc(withCenter: center, radius: CGFloat(radius), startAngle: 0, endAngle: .pi*2, clockwise: true)
            path.close()
        }
        self.path = path.cgPath
        self.strokeColor = fillColor
        self.fillColor = fillColor
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BackSideLine: CAShapeLayer, ShapeLayerProtocol {
    
    required init(size: CGSize, fillColor: CGColor) {
        super.init()
        
        let path = UIBezierPath()
        
        for _ in 1...15 {
            let randomXStart = Int.random(in: 0...Int(size.width))
            let randomYStart = Int.random(in: 0...Int(size.height))
            
            let randomXEnd = Int.random(in: 0...Int(size.width))
            let randomYEnd = Int.random(in: 0...Int(size.height))
            
            path.move(to: CGPoint(x: randomXStart, y: randomYStart))
            path.addLine(to: CGPoint(x: randomXEnd, y: randomYEnd))
        }
        self.path = path.cgPath
        self.strokeColor = fillColor
        self.lineWidth = 5
        self.lineCap = .round
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
        let rect = CGRect(x: 0, y: 0, width: edgeSize, height: edgeSize)
        
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

class EmptyCircleShape: CAShapeLayer, ShapeLayerProtocol {
    required init(size: CGSize, fillColor: CGColor) {
        
        super.init()
        
        let radius = ([size.width, size.height].min() ?? 0) / 2
        let centerX = size.width / 2
        let centerY = size.height / 2
        
        let path = UIBezierPath(
            arcCenter: CGPoint(x: centerX, y: centerX),
            radius: radius, startAngle: 0,
            endAngle: .pi*2,
            clockwise: true)
        path.close()
        
        self.path = path.cgPath
        self.strokeColor = fillColor
        self.fillColor = nil
        
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
