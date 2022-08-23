//
//  WorkoutCell.swift
//  GymLog
//
//  Created by Вика on 8/15/22.
//

import Foundation
import UIKit

class WorkoutCell: UITableViewCell{
    
    public var isSelectionEnable = false
    
    var countOfSets = Int64()
    
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
        tableView.rowHeight = UITableView.automaticDimension
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "setcell", for: indexPath)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
