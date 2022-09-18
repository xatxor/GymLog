//
//  EditSetsViewController.swift
//  GymLog
//
//  Created by Вика on 8/17/22.
//

import UIKit

class EditSetsViewController: UIViewController {
    
    public var workout: Workout?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        setupTitle()
        setupDoneButton()
        setupLabels()
        setupTableView()
        setupCreateButton()
    }
    
    // при нажатии на view клавиатура закрывается
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    public var completion: (() -> Void)?
    
    override func viewWillDisappear(_ animated: Bool) {
        completion?()
    }
    
    // MARK: Title
    
    private let titleLabel: UILabel = {
        let label = UILabel()

        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func setupTitle(){
        view.addSubview(titleLabel)
        
        titleLabel.sizeToFit()
        
        titleLabel.text = workout?.exercise?.name
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70)
        ])
    }
    
    // MARK: Done button
    
    private let doneButton: UIButton = {
        let btn = UIButton()
        
        let icon = UIImage(systemName: "checkmark")
        btn.setImage(icon, for: .normal)
        
        btn.tintColor = .black
        btn.setTitleColor(.black, for: .normal)
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    @objc func doneButtonTapped(){
        self.dismiss(animated: true)
    }

    private func setupDoneButton(){
        view.addSubview(doneButton)
        
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    // MARK: Weight/Reps labels
    
    private let weightLabel: UILabel = {
        let tf = UILabel()
        
        tf.text = "weight"
        tf.tintColor = .black
        tf.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        tf.font = .systemFont(ofSize: 16, weight: .regular)
        tf.textAlignment = .center
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let repsLabel: UILabel = {
        let tf = UILabel()
        
        tf.text = "reps"
        tf.tintColor = .black
        tf.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        tf.font = .systemFont(ofSize: 16, weight: .regular)
        tf.textAlignment = .center
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private func setupLabels(){
        view.addSubview(weightLabel)
        view.addSubview(repsLabel)
        
        NSLayoutConstraint.activate([
            weightLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25),
            weightLabel.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor, constant: -75)
        ])
        
        NSLayoutConstraint.activate([
            repsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25),
            repsLabel.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor, constant: 75)
        ])
    }
    
    // MARK: TableView
    
    private var setsWorkout: [WorkoutSet]?
    
    private var tableViewHeightConstraint: NSLayoutConstraint!
    
    private func getSets(){
        if workout != nil {
            setsWorkout = CoreDataManager.shared.fetchWorkoutSets(workout: workout!)
            tableViewHeightConstraint.constant = 50*CGFloat(setsWorkout?.count ?? 0)
            tableView.layoutIfNeeded()
            tableView.reloadData()
        }
    }
    
    private let tableView: UITableView = {
        let tv = UITableView()
        
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private func setupTableView(){
        
        view.addSubview(tableView)
        
        tableView.register(SetCell.self, forCellReuseIdentifier: "setcell")
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.clipsToBounds = true
        
        tableView.layoutIfNeeded()
        
        tableViewHeightConstraint = NSLayoutConstraint(item: tableView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)
        tableView.addConstraint(tableViewHeightConstraint)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: weightLabel.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        
        getSets()
    }
    
    //MARK: CreateButton
    
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
        view.addSubview(createButton)
        
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            createButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20),
            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            createButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    @objc func createButtonTapped(){
        if workout != nil {
            CoreDataManager.shared.addWorkoutSet(workout: workout!, weight: setsWorkout?.last?.weight ?? 0, reps: setsWorkout?.last?.reps ?? 0)
            getSets()
        }
    }
    
    private func handleDelete(setw: WorkoutSet?){
        if setw != nil{ CoreDataManager.shared.delete(obj: setw!) }
        getSets()
    }
}

extension EditSetsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // максимум 8 подходов может быть
        return setsWorkout?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "setcell", for: indexPath) as! SetCell
    
        cell.selectionStyle = .none
        
        cell.turnOnEditing()
        
        cell.setWorkout = setsWorkout?[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete"){ [weak self] (action, view, completionHandler) in
            self?.handleDelete(setw: self?.setsWorkout?[indexPath.row])
            completionHandler(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
}
