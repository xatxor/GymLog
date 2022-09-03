//
//  CreateViewController.swift
//  GymLog
//
//  Created by Вика on 8/23/22.
//

import UIKit

class NameSetterViewController: UIViewController {
    
    // TODO: в placeholder писать значение старого имени для случаев, когда этот vc используется для обновления имени а не для его установки
    
    private var keyboardHeight = CGFloat()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        view.backgroundColor = .white
        
        setup()
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
            //заново настраиваем границы view уже опираясь на обновленный keyboardHeight
            viewDidLayoutSubviews()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //half screen presentation
        self.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - (keyboardHeight + 190), width: self.view.bounds.width, height: keyboardHeight + 190)
                        self.view.layer.cornerRadius = 20
                        self.view.layer.masksToBounds = true
    }
    
    private let textfield: UITextField = {
        let tf = UITextField()
        tf.font = .systemFont(ofSize: 18, weight: .bold)
        tf.textAlignment = .center
        
        tf.placeholder = "Enter name"
        
        // отступ от границ слева
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 15.0, height: 2.0))
        tf.leftView = leftView
        tf.leftViewMode = .always
        
        // отступ от границ справа
        let rightView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 15.0, height: 2.0))
        tf.rightView = leftView
        tf.rightViewMode = .always
        
        tf.layer.cornerRadius = 15
        tf.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let closeButton: UIButton = {
        let btn = UIButton()
        
        let icon = UIImage(systemName: "xmark")
        btn.setImage(icon, for: .normal)
        
        btn.tintColor = .black
        btn.setTitleColor(.black, for: .normal)
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let doneButton: UIButton = {
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
    
    public var completion: ((String?) -> Void)?
    @objc func doneButtonTapped(){
        completion?(textfield.text?.trimmingCharacters(in: .whitespacesAndNewlines))
        self.dismiss(animated: true)
    }
    
    //если пользователь ничего не ввел, вернуть имя невозможно
    @objc func textFieldDidChange(){
        if textfield.text != "" { doneButton.isEnabled = true }
        else { doneButton.isEnabled = false }
    }

    private func setup(){
        
        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        view.addSubview(doneButton)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        doneButton.isEnabled = false
        
        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])

        view.addSubview(textfield)
        
        textfield.delegate = self
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
extension NameSetterViewController: UITextFieldDelegate {
    //ограничиваем количество символов в имени в 28 
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let textFieldText = textfield.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 28
    }
}
