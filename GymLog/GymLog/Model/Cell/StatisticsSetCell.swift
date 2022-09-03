//
//  StatisticsSetCell.swift
//  GymLog
//
//  Created by Вика on 9/3/22.
//

import UIKit

class StatisticsSetCell: UITableViewCell {

    public var setWorkout: WorkoutSet? {
        didSet {
            weightLabel.text = String(setWorkout?.weight ?? 0)
            repsLabel.text = String(setWorkout?.reps ?? 0)
        }
    }
    
    private let weightLabel: UILabel = {
        let tf = UILabel()
        tf.tintColor = .black
        tf.textColor = .black
        tf.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        tf.textAlignment = .center
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let repsLabel: UILabel = {
        let tf = UILabel()
        tf.tintColor = .black
        tf.textColor = .black
        tf.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        tf.textAlignment = .center
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let xLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "x"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(weightLabel)
        contentView.addSubview(repsLabel)
        
        contentView.addSubview(xLabel)

        setConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstrains(){
        NSLayoutConstraint.activate([
            xLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            weightLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            weightLabel.centerXAnchor.constraint(equalTo: xLabel.leadingAnchor, constant: -40),
        ])
        
        NSLayoutConstraint.activate([
            repsLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            repsLabel.centerXAnchor.constraint(equalTo: xLabel.trailingAnchor, constant: 40),
        ])
    }
}
