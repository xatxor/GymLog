//
//  CreateViewController.swift
//  GymLog
//
//  Created by Вика on 8/23/22.
//

import UIKit

class NameSetterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //half screen presentation
        self.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height / 5 * 2, width: self.view.bounds.width, height: UIScreen.main.bounds.height / 5 * 3)
                        self.view.layer.cornerRadius = 20
                        self.view.layer.masksToBounds = true
    }
    
    
    let textfield: UITextField = {
        let tf = UITextField()
        tf.font = .systemFont(ofSize: 18, weight: .bold)
        tf.textAlignment = .center
        
        tf.placeholder = "Enter name"
        
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 15.0, height: 2.0))
        tf.leftView = leftView
        tf.leftViewMode = .always
        
        let rightView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 15.0, height: 2.0))
        tf.rightView = leftView
        tf.rightViewMode = .always
        
        tf.layer.cornerRadius = 15
        tf.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let closeButton: UIButton = {
        let btn = UIButton()
        
        let icon = UIImage(systemName: "xmark")
        btn.setImage(icon, for: .normal)
        
        btn.tintColor = .black
        btn.setTitleColor(.black, for: .normal)
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let doneButton: UIButton = {
        let btn = UIButton()
        
        let icon = UIImage(systemName: "checkmark")
        btn.setImage(icon, for: .normal)
        
        btn.tintColor = .black
        btn.setTitleColor(.black, for: .normal)
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    @objc func closeButtonTapped(){
        self.dismiss(animated: true)
    }
    
    var returnedName = String()
    
    @objc func doneButtonTapped(){
        self.dismiss(animated: true)
        
    }
    
    @objc func textFieldDidChange(){
        if textfield.text != "" { doneButton.isEnabled = true }
        else { doneButton.isEnabled = false }
    }

    func setup(){
        
        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
            //doneButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        view.addSubview(doneButton)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        doneButton.isEnabled = false
        
        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            //doneButton.heightAnchor.constraint(equalToConstant: 40)
        ])

        view.addSubview(textfield)
        
        textfield.becomeFirstResponder()
        textfield.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

        NSLayoutConstraint.activate([
            textfield.topAnchor.constraint(equalTo: doneButton.bottomAnchor, constant: 15),
            textfield.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            textfield.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            textfield.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
