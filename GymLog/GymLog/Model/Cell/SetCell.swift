//
//  WorkoutCell.swift
//  GymLog
//
//  Created by Вика on 8/15/22.
//

import Foundation
import UIKit

class SetCell: UITableViewCell{
    
    var weight: Int = 0
    var reps: Int = 15
    let space: String = "             x             "

    let container: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.clipsToBounds = true
        return v
    }()
    
    let weightAndRepsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 24)
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(container)
        container.addSubview(weightAndRepsLabel)
        
        weightAndRepsLabel.text = String(weight) + space + String(reps)

        setConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstrains(){
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            container.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            weightAndRepsLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            weightAndRepsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            weightAndRepsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
        ])
        
    }
}
