//
//  SecondViewController.swift
//  Cards
//
//  Created by Daniil Polenskii on 11.02.2024.
//

import UIKit

class SecondViewController: UIViewController {
    
    override func loadView() {
        super.loadView()
        view.addSubview(getEndButtonView())
    }

    @objc func showNextScreen(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let viewController = storyboard.instantiateViewController(withIdentifier: "BoardGameController")
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    
    private func getEndButtonView() -> UIButton {
        let button = UIButton(frame: CGRect(x: 50, y: 50, width: 100, height: 50))
        button.setTitle("Go ", for: .normal)
        button.setTitleColor(.purple, for: .normal)
        button.setTitleColor(.yellow, for: .highlighted)
        button.layer.cornerRadius = 10
        
        let window = UIApplication.shared.windows[0]
        let topPadding = window.safeAreaInsets.top
        button.frame.origin.y = topPadding
        
        button.addTarget(nil, action: #selector(showNextScreen(_:)), for: .touchUpInside)
        
        return button
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
