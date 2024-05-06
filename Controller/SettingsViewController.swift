//
//  SettingsViewController.swift
//  Cards
//
//  Created by Daniil Polenskii on 05.05.2024.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "View")
        configureBackGameButton()
        configureSaveOptionsButton()
        setupNavigationBar()
    }
    
    private lazy var returnToMenuButton = {
        let button = UIButton()
        button.setTitle("Back", for: .normal)
        button.backgroundColor = UIColor(named: "YellowButton")
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.systemYellow, for: .highlighted)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(finishSetting), for: .touchUpInside)
        return button
    }()
    
    private lazy var saveOptionsButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.backgroundColor = UIColor(named: "YellowButton")
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.systemYellow, for: .highlighted)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(<#T##target: Any?##Any?#>, action: <#T##Selector#>, for: <#T##UIControl.Event#>)
        return button
    }()
    
    @objc private func finishSetting() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupNavigationBar() {
        let backButton = UIBarButtonItem(customView: returnToMenuButton)
        let saveOptionsButton = UIBarButtonItem(customView: saveOptionsButton)
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = saveOptionsButton
    }
}

private extension SettingsViewController {
    
    func configureBackGameButton() {
        NSLayoutConstraint.activate([
            returnToMenuButton.widthAnchor.constraint(equalToConstant: 110),
            returnToMenuButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configureSaveOptionsButton() {
        NSLayoutConstraint.activate([
            saveOptionsButton.widthAnchor.constraint(equalToConstant: 110),
            saveOptionsButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
