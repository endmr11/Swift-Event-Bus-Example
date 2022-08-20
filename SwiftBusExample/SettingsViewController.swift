//
//  SettingsViewController.swift
//  SwiftBusExample
//
//  Created by Eren Demir on 21.08.2022.
//

import UIKit
import SwiftEventBus
class SettingsViewController: UIViewController {
    lazy var saveBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .done, target: self, action: #selector(saveBarButtonItemTapped))
    @objc fileprivate func saveBarButtonItemTapped() {
        if let name = nameTextField.text, let info = infoTextField.text{
            let model:HomeModel = HomeModel(name: name, info: info)
            SwiftEventBus.post("myEvent",sender: model)
            navigationController?.popViewController(animated: true)
        }
    }
    
    lazy var nameTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Enter Name"
        return tf
    }()
    
    lazy var infoTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Enter Info"
        return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupView()

    }
    
    
    fileprivate func setupNavigation() {
        title = "Settings"
        navigationItem.setRightBarButton(saveBarButtonItem, animated: false)
    }
    
    fileprivate func setupView() {
        guard let view = view else { return }
        
        view.backgroundColor = UIColor.systemBackground
        
        view.addSubview(nameTextField)
        view.addSubview(infoTextField)
        
        nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        
        infoTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 32).isActive = true
        infoTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        infoTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
    
    }


}
