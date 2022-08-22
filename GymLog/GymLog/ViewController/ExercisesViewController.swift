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
    }
    
    public var isSelectionEnable = false
    
    // для корректного отображения NavigationBar
    let space: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    func setupTableView(){
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
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)
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
        
    }
}
