//
//  EditSetsViewController.swift
//  GymLog
//
//  Created by Вика on 8/17/22.
//

import UIKit

class EditSetsViewController: UIViewController {

    var isFullScreenView: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        setupButtons()
        setupTableView()
        setupCreateButton()
    }
    
    // при нажатии на view клавиатура закрывается
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
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
    
    @objc func doneButtonTapped(){
        self.dismiss(animated: true)
    }

    func setupButtons(){
        
        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        view.addSubview(doneButton)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    let tableView: UITableView = {
        let tv = UITableView()
        
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    func setupTableView(){
        view.addSubview(tableView)
        
        tableView.register(SetCell.self, forCellReuseIdentifier: "setcell")
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.clipsToBounds = true
        
        tableView.layoutIfNeeded()
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 65),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tableView.heightAnchor.constraint(equalToConstant: 50*3)
        ])
    }
    
    //MARK: CreateButton
    
    let createButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("+ set", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), for: .normal)
        
        button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        button.layer.cornerRadius = 10
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func setupCreateButton(){
        view.addSubview(createButton)
        
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            createButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20),
            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            createButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    @objc func createButtonTapped(){
        
    }
    
    func handleDelete(){
        
    }
}

extension EditSetsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // максимум 8 подходов может быть
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "setcell", for: indexPath) as! SetCell
    
        cell.selectionStyle = .none
        
        cell.turnOnEditing()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete"){ [weak self] (action, view, completionHandler) in
            self?.handleDelete()
            completionHandler(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
}
