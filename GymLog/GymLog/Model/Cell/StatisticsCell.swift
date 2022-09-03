//
//  StatisticsCell.swift
//  GymLog
//
//  Created by Вика on 9/3/22.
//

import UIKit

class StatisticsCell: UITableViewCell {
    
    public var workout: Workout? {
        didSet{
            getSets()
            setDateTitle()
        }
    }
    
    private var setsWorkout: [WorkoutSet]?
    
    private func getSets(){
        if workout != nil {
            setsWorkout = CoreDataManager.shared.fetchWorkoutSets(workout: workout!)
            tableViewHeightConstraint.constant = 30*CGFloat(setsWorkout?.count ?? 0)
            tableView.layoutIfNeeded()
            tableView.reloadData()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        tintColor = .black
        
        let v = UIView()
        v.backgroundColor = .white
        selectedBackgroundView = v
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let dateTitle: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func setDateTitle(){
        let cal = Calendar.current
        let date = workout?.date
        var str: String
        if date != nil {
            if cal.isDateInToday(date!) { str = "Today" }
            else if cal.isDateInYesterday(date!) { str = "Yesterday" }
            else {
                let dateFormatter = DateFormatter()
                var format = "dd.MM"

                if !cal.isDate(date!, equalTo: Date(), toGranularity: .year){
                    format += ".YY"
                }
                
                dateFormatter.dateFormat = format
                str = dateFormatter.string(from: date!)
            }
            dateTitle.text = str
        }
    }
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.clipsToBounds = true
        return tv
    }()
    
    var tableViewHeightConstraint: NSLayoutConstraint!
    
    private func setup(){
        contentView.addSubview(dateTitle)
        
        NSLayoutConstraint.activate([
            dateTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            dateTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30)
        ])
        
        contentView.addSubview(tableView)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(StatisticsSetCell.self, forCellReuseIdentifier: "setcell")
        tableView.separatorStyle = .none
        
        tableViewHeightConstraint = NSLayoutConstraint(item: tableView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)
        tableView.addConstraint(tableViewHeightConstraint)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 200),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
}
extension StatisticsCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setsWorkout?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "setcell", for: indexPath) as! StatisticsSetCell
        
        cell.setWorkout = setsWorkout?[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }
}
