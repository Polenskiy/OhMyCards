//
//  Cards.swift
//  Cards
//
//  Created by Daniil Polenskii on 11.11.2023.
//

import UIKit

protocol FlippableView: UIView {
    var isFlipped: Bool { get set }
    var flipCompletionHandler: ((FlippableView) -> Void)? { get set }
    func flip()
}

class CardView<ShapeType: ShapeLayerProtocol>: UIView, FlippableView {
    
    var cornerRadius = 20
    
    ///эти свойста используются в методе flip() и в методе draw()
    lazy var frontSideView: UIView = getFrontSideView()
    lazy var backSideView: UIView = getBackSideView()
    
    var isFlipped = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    ///переменная которая содержит в себе замыкание
    var flipCompletionHandler: ((FlippableView) -> Void)?
    

    func flip() {
        
        let fromView = isFlipped ? frontSideView : backSideView
        let toView = isFlipped ? backSideView : frontSideView
        
        UIView.transition(from: fromView, to: toView, duration: 0.5, options: [.transitionFlipFromLeft], completion: {_ in
          
            self.flipCompletionHandler?(self)
        })
        isFlipped.toggle()
    }

    var color: UIColor
    
    init(frame: CGRect, color: UIColor) {
        self.color = color
        super.init(frame: frame)
        setupBorders()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
    
        backSideView.removeFromSuperview()
        frontSideView.removeFromSuperview()
        
        if isFlipped {
            self.addSubview(backSideView)
            self.addSubview(frontSideView)
        } else {
            self.addSubview(frontSideView)
            self.addSubview(backSideView)
        }
    }
    private let margin: Int = 10
    
    private func getFrontSideView() -> UIView {
        
        let view = UIView(frame: bounds)
        
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = CGFloat(cornerRadius)
        
        let shapeView = UIView(frame: CGRect(
            x: margin,
            y: margin,
            width: Int(bounds.width) - margin * 2 ,
            height: Int(bounds.height) - margin * 2
        ))
        view.addSubview(shapeView)
        
        let shapeLayer = ShapeType(size: shapeView.frame.size, fillColor: color.cgColor)
        shapeView.layer.addSublayer(shapeLayer)
        
        return view
    }
    
    enum Shape {
        case circle
        case line
    }

    private func getBackSideView() -> UIView {
        
        let view  = UIView(frame: bounds)
        
        view.backgroundColor = .systemBackground
        view.layer.masksToBounds = true
        view.layer.cornerRadius = CGFloat(cornerRadius)
        
        let shapes: [Shape] = [.circle, .line]
        
        switch shapes.randomElement() {
        case .circle:
            let layer = BackSideCircle(
                size: bounds.size,
                fillColor: UIColor.systemTeal.cgColor
            )
            view.layer.addSublayer(layer)
        case .line:
            let layer = BackSideLine(
                size: bounds.size,
                fillColor: UIColor.systemIndigo.cgColor
            )
            view.layer.addSublayer(layer)
        default:
            break
        }
        return view
    }
    
    private func setupBorders() {
        self.clipsToBounds = true
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    private var anchorPointOne: CGPoint = CGPoint(x: 0, y: 0)
    
    private var startTouchPoint: CGPoint!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        startTouchPoint = frame.origin
        
        print(frame.origin)

        let x = touches.first?.location(in: window).x ?? 0
        let y = touches.first?.location(in: window).y ?? 0
        
        anchorPointOne.x = x - frame.minX
        anchorPointOne.y = y - frame.minY
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.frame.origin.x = (touches.first?.location(in: window).x ?? 0) - anchorPointOne.x
        self.frame.origin.y = (touches.first?.location(in: window).y ?? 0) - anchorPointOne.y
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.frame.origin == startTouchPoint {
            flip()
        }
    }
}
