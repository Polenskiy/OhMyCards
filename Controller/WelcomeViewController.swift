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
        button.backgroundColor = UIColor(named: "YellowButton")
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.systemYellow, for: .highlighted)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(AddBoardGameController), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var showGameSettings = {
        
        let button = UIButton()
        button.setTitle("Settings game", for: .normal)
        button.backgroundColor = UIColor(named: "YellowButton")
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.systemYellow, for: .highlighted)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(AddSettingsController), for: .touchUpInside)
        return button
    }()
    
    @objc private func AddBoardGameController() {
        let boardGameController = BoardGameController()
        navigationController?.pushViewController(boardGameController, animated: true)
    }
    
    @objc private func AddSettingsController() {
        let settingsController = SettingsViewController()
        navigationController?.pushViewController(settingsController, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        view.backgroundColor = UIColor(named: "View")
        setBunnerImage()
        configureAddStartButton()
        configureGameSettingsButton()
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
    
    func configureGameSettingsButton() {
        view.addSubview(showGameSettings)
        NSLayoutConstraint.activate([
            showGameSettings.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showGameSettings.topAnchor.constraint(equalTo: view.topAnchor, constant: 654),
            showGameSettings.widthAnchor.constraint(equalToConstant: 346),
            showGameSettings.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
}
