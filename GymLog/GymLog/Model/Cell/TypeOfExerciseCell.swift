//
//  TypeOfExerciseCell.swift
//  GymLog
//
//  Created by Вика on 8/21/22.
//

import Foundation
import UIKit

class TypeOfExerciseCell: UITableViewCell {

    let title: UILabel = {
        let label = UILabel()
        label.text = "Exercises type"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        tintColor = .black
        
        let v = UIView()
        v.backgroundColor = .white
        selectedBackgroundView = v
        
        accessoryType = .disclosureIndicator
        
        contentView.addSubview(title)
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 15),
            title.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
