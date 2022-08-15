//
//  WorkoutCell.swift
//  GymLog
//
//  Created by Вика on 8/15/22.
//

import Foundation
import UIKit

class WorkoutCell: UITableViewCell{
    
    let title: UILabel = {
        let label = UILabel()
        label.text = "Test title of workout"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let container: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.clipsToBounds = true
        v.layer.cornerRadius = 7
        return v
    }()
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.clipsToBounds = true
        return tv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(container)
        container.addSubview(tableView)
        container.addSubview(title)
        
        setupTableView()
        
        setConstrains()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animate(){
        UIView.animate(withDuration: 0.5, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.contentView.layoutIfNeeded()
        })
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SetCell.self, forCellReuseIdentifier: "setcell")
    }
    
    private func setConstrains(){
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: container.topAnchor, constant: 0),
            title.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0),
            title.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0),
            title.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10)
        ])
    }
}

extension WorkoutCell: UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "setcell", for: indexPath)
        cell.selectionStyle = .none
        return cell
    }
}
