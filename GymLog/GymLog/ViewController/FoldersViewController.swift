//
//  DataViewController.swift
//  GymLog
//
//  Created by Вика on 8/17/22.
//

import UIKit

class FoldersViewController: UIViewController {
    
    public var isSelectionEnable = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupLabels()
        setupTableView()
    }
    
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
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    func setupTableView(){
        view.addSubview(tableView)
        
        tableView.register(TypeOfExerciseCell.self, forCellReuseIdentifier: "typeofexcell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.clipsToBounds = true
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: exerciseLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)
        ])
    }
}
extension FoldersViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "typeofexcell", for: indexPath) as! TypeOfExerciseCell
        
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
}
