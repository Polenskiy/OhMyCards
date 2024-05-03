//
//  SecondViewController.swift
//  Cards
//
//  Created by Daniil Polenskii on 11.02.2024.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    private let build = ViewBuilder.shared
    
    private func setBunnerImage() {
        let bannerImage = build.bannerImage
        view.addSubview(bannerImage)
        bannerImage.image = UIImage(named: "baner")
        
        NSLayoutConstraint.activate([
            bannerImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bannerImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 162)
        ])
    }
    
    private lazy var showNextScreen = {
        
        let button = UIButton()
        button.setTitle("Start game", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.systemYellow, for: .highlighted)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(AddBoardGameController), for: .touchUpInside)
        
        return button
    }()
    
    @objc private func AddBoardGameController() {
        let boardGameController = BoardGameController()
        navigationController?.pushViewController(boardGameController, animated: true)
    }
//    override func loadView() {
//        super.loadView()
//        view.addSubview(getEndButtonView())
//    }

//    @objc func showNextScreen(_ sender: UIButton) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        
//        let viewController = storyboard.instantiateViewController(withIdentifier: "BoardGameController")
//        viewController.modalPresentationStyle = .fullScreen
//        self.present(viewController, animated: true, completion: nil)
//    }
    
//    private func getEndButtonView() -> UIButton {
//        let button = UIButton(frame: CGRect(x: 50, y: 50, width: 346, height: 56))
//        button.setTitle("Go ", for: .normal)
//        button.setTitleColor(.purple, for: .normal)
//        button.setTitleColor(.yellow, for: .highlighted)
//        button.layer.cornerRadius = 10
//        
//        let window = UIApplication.shared.windows[0]
//        let topPadding = window.safeAreaInsets.top
//        button.frame.origin.y = topPadding
        
//        button.addTarget(nil, action: #selector(showNextScreen(_:)), for: .touchUpInside)
        
//        return button
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        setBunnerImage()
        configureAddStartButton()
    }

}

private extension WelcomeViewController {
    
    func configureAddStartButton() {
        view.addSubview(showNextScreen)
        NSLayoutConstraint.activate([
            showNextScreen.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showNextScreen.topAnchor.constraint(equalTo: view.topAnchor, constant: 722),
            showNextScreen.widthAnchor.constraint(equalToConstant: 346),
            showNextScreen.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
}
