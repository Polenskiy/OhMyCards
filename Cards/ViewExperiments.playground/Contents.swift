//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

//Любой View Controller имеет корневое представление,
//доступ к которому можно получить с помощью свойства view.
class MyViewController : UIViewController {
    
    override func loadView() {
        setupViews()
    }
    
    func setupViews() {
        self.view = getRootView()
        let redView = getRedView()
        let greenView = getGreenView()
        let whiteView = getWhiteView()
        let pinkView = getPinkView()
        
        self.view.addSubview(redView)
        redView.addSubview(greenView)
        redView.addSubview(whiteView)
        self.view.addSubview(pinkView)
        pinkView.layer.addSublayer(getLayer())
        
        set(view: greenView, toCenterOfView: redView)
//        set(view: whiteView, toCenterOfView: greenView)
        whiteView.center = greenView.center
        
        redView.transform = CGAffineTransform(rotationAngle: .pi/6)
    }
    
    func getRootView() -> UIView {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }
    
    func getRedView() -> UIView {
        
        let viewFrame = CGRect(x: 50, y: 50, width: 200, height: 200)
        let view = UIView(frame: viewFrame)
        view.backgroundColor = .red
        return view
    }
    
    func getGreenView() -> UIView {
        let viewFrame = CGRect(x: 100, y: 100, width: 180, height: 180)
        let view = UIView(frame: viewFrame)
        view.backgroundColor = .green
        return view
    }
    
    func getWhiteView() -> UIView {
        let viewFrame = CGRect(x: 0, y: 0, width: 50, height: 50)
        let view = UIView(frame: viewFrame)
        view.backgroundColor = .white
        return view
    }
    
    func getPinkView() -> UIView {
        let viewFrame = CGRect(x: 50, y: 300, width: 100, height: 100)
        let view = UIView(frame: viewFrame)
        view.backgroundColor = .systemPink
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.yellow.cgColor
        view.layer.cornerRadius = 10
        view.layer.shadowOpacity = 0.95
        view.layer.shadowRadius = 20
        view.layer.shadowColor = UIColor.purple.cgColor
        view.layer.shadowOffset = CGSize(width: 15, height: 10)
        view.transform = CGAffineTransform(rotationAngle: .pi/4).scaledBy(x: 2, y: 0.5).translatedBy(x: 50, y: 40)
        
        print(view.frame)
        return view
    }
    
    func getLayer() -> CALayer {
        let layer = CALayer()
        layer.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        layer.backgroundColor = UIColor.black.cgColor
        layer.cornerRadius = 10
        return layer
        
    }
    
    func set(view moveView: UIView, toCenterOfView baseView: UIView) {
        moveView.center = CGPoint(x: baseView.bounds.midX, y: baseView.bounds.midY)
    }
    
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
    
