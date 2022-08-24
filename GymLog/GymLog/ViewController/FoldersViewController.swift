//
//  DataViewController.swift
//  GymLog
//
//  Created by Вика on 8/17/22.
//

import UIKit

class FoldersViewController: UIViewController {
    
    // TODO: добавить кнопку добавления exercise -> добавить доп вид в NameSetterViewController для выбора папки
    
    public var isSelectionEnable = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupLabels()
        setupTableView()
        setupAddButton()
    }
    
    //MARK: Labels
    
    var countOfTypes = Int64()
    var countOfExercises = Int64()
    var countOfWorkouts = Int64()
    
    let typesLabel: UILabel = {
        let label = UILabel()
        label.text = "------------------9 folders------------------"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let exerciseLabel: UILabel = {
        let label = UILabel()
        label.text = "----------------16 exercises----------------"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupLabels(){
        view.addSubview(typesLabel)
        view.addSubview(exerciseLabel)
        
        NSLayoutConstraint.activate([
            typesLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            typesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            typesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            typesLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        NSLayoutConstraint.activate([
            exerciseLabel.topAnchor.constraint(equalTo: typesLabel.bottomAnchor, constant: 10),
            exerciseLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            exerciseLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            exerciseLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    //MARK: AddButton
    
    let createButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("create new folder", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        
        button.backgroundColor = .clear
        button.layer.cornerRadius = 7
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.darkGray.cgColor
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func setupAddButton(){
        view.addSubview(createButton)
        
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            createButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 0),
            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    // Add Folder
    @objc func createButtonTapped(){
        let vc = NameSetterViewController()
        
        navigationController?.present(vc, animated: true)
    }
    
    //MARK: TableView
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    func setupTableView(){
        view.addSubview(tableView)
        
        tableView.register(FolderCell.self, forCellReuseIdentifier: "typeofexcell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.clipsToBounds = true
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: exerciseLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -90)
        ])
    }
}
extension FoldersViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "typeofexcell", for: indexPath) as! FolderCell
        
        //cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ExercisesViewController()
        vc.title = "Database"
        if isSelectionEnable { vc.isSelectionEnable = true}
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleDelete() {
        let vc = DeleteConfirmationViewController()
        navigationController?.present(vc, animated: true)
    }
    
    private func handleEdit() {
        let vc = NameSetterViewController()
        navigationController?.present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if !isSelectionEnable {
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete"){ [weak self] (action, view, completionHandler) in
                self?.handleDelete()
                completionHandler(true)
            }
            
            let editAction = UIContextualAction(style: .normal, title: "Edit"){ [weak self] (action, view, completionHandler) in
                self?.handleEdit()
                completionHandler(true)
            }
            editAction.backgroundColor = #colorLiteral(red: 0.659389317, green: 0.8405041099, blue: 1, alpha: 1)
            
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
            configuration.performsFirstActionWithFullSwipe = false
            
            return configuration
        }
        else { return nil }
    }
}
