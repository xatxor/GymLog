//
//  ExercisesViewController.swift
//  GymLog
//
//  Created by Вика on 8/21/22.
//

import UIKit

class ExercisesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupTableView()
        setupAddButton()
    }
    
    public var isSelectionEnable = false
    
    // для корректного отображения NavigationBar
    private let space: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    //MARK: CreateButton
    
    private let createButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("create new exercise", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        
        button.backgroundColor = .clear
        button.layer.cornerRadius = 7
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.darkGray.cgColor
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private func setupAddButton(){
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
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private func setupTableView(){
        view.addSubview(space)
        
        NSLayoutConstraint.activate([
            space.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            space.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            space.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            space.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        view.addSubview(tableView)
        
        tableView.register(WorkoutCell.self, forCellReuseIdentifier: "workoutcell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.clipsToBounds = true

        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.allowsMultipleSelection = true
        tableView.allowsMultipleSelectionDuringEditing = true
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: space.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -90)
        ])
    }
}
extension ExercisesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workoutcell", for: indexPath) as! WorkoutCell
        if isSelectionEnable { cell.isSelectionEnable = true }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isSelectionEnable{
            let vc = StatisticsViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func handleStatistics() {
        let vc = StatisticsViewController()
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
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if !isSelectionEnable {
            let statisticsAction = UIContextualAction(style: .normal, title: "Statistics"){ [weak self] (action, view, completionHandler) in
                self?.handleStatistics()
                completionHandler(true)
            }
            statisticsAction.backgroundColor = #colorLiteral(red: 0.834133327, green: 0.834133327, blue: 0.834133327, alpha: 1)
            
            return UISwipeActionsConfiguration(actions: [statisticsAction])
        }
        else { return nil }
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
