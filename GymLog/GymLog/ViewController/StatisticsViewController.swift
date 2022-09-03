//
//  StatisticsViewController.swift
//  GymLog
//
//  Created by Вика on 8/23/22.
//

import UIKit

class StatisticsViewController: UIViewController {
    
    public var exercise: Exercise? {
        didSet {
            title = exercise?.name
            getWorkouts()
        }
    }
    
    public var workouts: [Workout]?
    
    private func getWorkouts(){
        workouts = CoreDataManager.shared.fetchWorkoutsSorted(exercise: exercise!)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setup()
    }
    
    // для корректного отображения NavigationBar
    private let space: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private func setup(){
        view.addSubview(space)
        
        NSLayoutConstraint.activate([
            space.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            space.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            space.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            space.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(StatisticsCell.self, forCellReuseIdentifier: "cell")
        
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: space.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }
}

extension StatisticsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let countOfSets = workouts?[indexPath.row].sets?.count ?? 0
        return CGFloat(30*countOfSets + 20)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StatisticsCell
        
        cell.workout = workouts?[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }
}
