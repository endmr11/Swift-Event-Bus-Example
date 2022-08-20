//
//  ViewController.swift
//  SwiftBusExample
//
//  Created by Eren Demir on 21.08.2022.
//

import UIKit
import SwiftEventBus

enum HomeState {
    case loading
    case loaded
}

class HomeViewController: UIViewController {
    
    var currentState:HomeState = .loaded
    
    lazy var settingsBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(settingsBarButtonItemTapped))
    @objc fileprivate func settingsBarButtonItemTapped() {
        let controller = SettingsViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.text = "Default Name"
        return label
    }()
    

    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor.systemGray
        label.text = "Default Info"
        return label
    }()
    
    var activityIndicator: UIActivityIndicatorView{
        let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)

        return indicator
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupView()
        SwiftEventBus.onBackgroundThread(self, name: "myEvent") { notification in
            if (notification?.object) != nil{
                if let obj = notification?.object as? HomeModel{
                    DispatchQueue.main.async {
                        self.currentState = .loading
                        self.setupView()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            SwiftEventBus.postToMainThread("updateUI",sender: obj)
                        }
                    }
                }
            }
        }

        SwiftEventBus.onMainThread(self, name: "updateUI") { notification in
            if let obj = notification?.object as? HomeModel{
                self.nameLabel.text = obj.name
                self.infoLabel.text = obj.info
            }
            
            DispatchQueue.main.async {
                self.currentState = .loaded
                self.setupView()
            }
        }
    }
    fileprivate func setupNavigation() {
        title = "Home"
        navigationItem.setRightBarButton(settingsBarButtonItem, animated: false)
    }
    fileprivate func setupView() {
        guard let view = view else { return }
        view.backgroundColor = UIColor.systemBackground
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        if currentState == .loaded {
            view.addSubview(nameLabel)
            view.addSubview(infoLabel)
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

            infoLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
            infoLabel.centerXAnchor.constraint(equalTo: nameLabel.centerXAnchor).isActive = true
        }else{
            let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
            myActivityIndicator.center = view.center
            myActivityIndicator.hidesWhenStopped = false
            myActivityIndicator.startAnimating()
            view.addSubview(myActivityIndicator)
            
        }


    }
}

