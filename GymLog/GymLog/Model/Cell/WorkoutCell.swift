//
//  WorkoutCell.swift
//  GymLog
//
//  Created by Вика on 8/15/22.
//

import Foundation
import UIKit

// protocol to connect cell with viewcontroller and present another viewcontroller
protocol EditSetCellProtocol {
    func setsTableViewTapped(workout: Workout?)
}

class WorkoutCell: UITableViewCell{
    
    var delegate: EditSetCellProtocol!
    
    public var isSelectionEnable = false
    
    public var exercise: Exercise? {
        didSet{
            updateTitle()
        }
    }
    
    public var workout: Workout?{
        didSet{
            getSets()
        }
    }
    
    private var setsWorkout: [WorkoutSet]?
    
    private func getSets(){
        if workout != nil {
            setsWorkout = CoreDataManager.shared.fetchWorkoutSets(workout: workout!)
            tableView.layoutIfNeeded()
            tableView.reloadData()
            checkCreateButtonVisibility()
        }
    }
    
    private func updateTitle(){
        title.text = exercise?.name ?? "def"
    }
    
    private let createButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("+ set", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), for: .normal)
        
        button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        button.layer.cornerRadius = 10
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private func setupCreateButton(){
        contentView.addSubview(createButton)
        
        createButton.isHidden = true

        contentView.clipsToBounds = true
        
        //let tap = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        createButton.addTarget(self, action: #selector(tableViewTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            createButton.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 0),
            createButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            createButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            createButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func checkCreateButtonVisibility(){
        if setsWorkout?.count == 0 {
            createButton.isHidden = false
        } else {
            createButton.isHidden = true
        }
        createButton.layoutIfNeeded()
    }
    
    //TODO: добавить возможность многострочного ввода
    let title: UILabel = {
        let label = UILabel()
        label.text = "Test title of workout"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.clipsToBounds = true
        return tv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        tintColor = .black
        
        let v = UIView()
        v.backgroundColor = .white
        selectedBackgroundView = v
        
        contentView.addSubview(title)
        contentView.addSubview(tableView)
        
        setupCreateButton()
        
        setupTableView()
        
        setConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SetCell.self, forCellReuseIdentifier: "setcell")
        tableView.rowHeight = UITableView.automaticDimension
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        tableView.addGestureRecognizer(tap)

        title.text = String(setsWorkout?.count ?? 0)
    }
    
    @objc func tableViewTapped(){
        self.delegate.setsTableViewTapped(workout: self.workout)
    }
    
    private func setConstrains(){
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            title.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        ])

        title.text = String(setsWorkout?.count ?? 0)
    }
    
    let checkmark: UIView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        v.layer.cornerRadius = 10
        
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if isSelectionEnable{
            super.setSelected(selected, animated: animated)
            accessoryType = selected ? .checkmark : .none
        }
    }
}

extension WorkoutCell: UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setsWorkout?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row > (setsWorkout?.count ?? 0) - 1 {
            return UITableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "setcell", for: indexPath) as! SetCell
            cell.selectionStyle = .none
            cell.setWorkout = setsWorkout?[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
