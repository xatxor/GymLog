//
//  ExercisesViewController.swift
//  GymLog
//
//  Created by Вика on 8/21/22.
//

import UIKit

class ExercisesViewController: UIViewController {
    
    public var folder: Folder? {
        didSet{
            getExercises()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backButtonTitle = ""
        
        view.backgroundColor = .white
        
        if isSelectionEnable{ setupSelectionLabel() }
        
        setupAddButton()
        setupDoneButton()
        setupTableView()
        
        selectRows()
    }
    
    public var completion: (([Exercise]) -> Void)?
    
    override func viewWillDisappear(_ animated: Bool) {
        completion?(selectedExercises)
    }
    
    // MARK: Selection Mode
    
    public var selectedExercises = [Exercise]()
    
    public var selectedDate = Date()
    
    public var isSelectionEnable = false
    
    private let selectionLabel: UILabel = {
        let label = UILabel()

        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .medium)
        
        label.layer.cornerRadius = 7
        label.layer.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func updateSelectionLabel(){
        selectionLabel.text = "Selected: " + String(selectedExercises.count)
    }
    
    private func setupSelectionLabel(){
        NSLayoutConstraint.activate([
            selectionLabel.widthAnchor.constraint(equalToConstant: 110),
            selectionLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        updateSelectionLabel()
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: selectionLabel)]
    }
    
    private func checkIfDoneButtonVisible(){
        if selectedExercises.count > 0{
            doneButton.isEnabled = true
        } else {
            doneButton.isEnabled = false
        }
        doneButton.layoutIfNeeded()
    }
    
    private let doneButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Done", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.setTitleColor(.lightGray, for: .disabled)
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        
        btn.layer.cornerRadius = 10
        btn.layer.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private func setupDoneButton(){
        view.addSubview(doneButton)
        
        let titleForBtn = isSelectionEnable ? "Done" : ""
        doneButton.setTitle(titleForBtn, for: .normal)
        
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            doneButton.bottomAnchor.constraint(equalTo: createButton.topAnchor, constant: -10),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.heightAnchor.constraint(equalToConstant: isSelectionEnable ? 40 : 0)
        ])
        
        checkIfDoneButtonVisible()
    }
    
    @objc func doneButtonTapped(){
        CoreDataManager.shared.addWorkouts(exercises: selectedExercises, date: selectedDate)
        NotificationCenter.default.post(name: NSNotification.Name("reloadWorkouts"), object: nil)
        navigationController?.popToRootViewController(animated: true)
    }
    
    // для корректного отображения NavigationBar
    private let space: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    //MARK: CreateButton
    
    private let createButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("create new exercise", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        
        button.backgroundColor = .clear
        button.layer.cornerRadius = 7
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.darkGray.cgColor
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private func setupAddButton(){
        view.addSubview(createButton)
        
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            createButton.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -90),
            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    // Add Folder
    @objc func createButtonTapped(){
        let vc = NameSetterViewController()
        vc.completion = { [weak self] name in
            DispatchQueue.main.async {
                if self?.folder != nil {
                    CoreDataManager.shared.addExercise(name: name ?? "Default name", folder: (self?.folder)!)
                    self?.getExercises()
                }
            }
        }
        navigationController?.present(vc, animated: true)
    }
    
    //MARK: TableView
    
    private var exercises = [Exercise]()
    
    private func getExercises(){
        if folder != nil {
            exercises = CoreDataManager.shared.fetchExercises(folder: self.folder!)
            tableView.reloadData()
        }
    }
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private func setupTableView(){
        view.addSubview(space)
        
        NSLayoutConstraint.activate([
            space.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            space.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            space.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            space.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        view.addSubview(tableView)
        
        tableView.register(WorkoutCell.self, forCellReuseIdentifier: "workoutcell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.clipsToBounds = true

        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.allowsMultipleSelection = true
        tableView.allowsMultipleSelectionDuringEditing = true
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: space.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            tableView.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: 0)
        ])
    }
    
    private func selectRows(){
        for item in selectedExercises{
            if item.folder == self.folder {
                tableView.selectRow(at: IndexPath(row: exercises.firstIndex(of: item)!, section: 0), animated: true, scrollPosition: .bottom)
            }
        }
    }
}
extension ExercisesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workoutcell", for: indexPath) as! WorkoutCell
        if isSelectionEnable { cell.isSelectionEnable = true }
        
        cell.exercise = exercises[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ex = exercises[indexPath.row]
        
        if !isSelectionEnable{
            let vc = StatisticsViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
        else {
            selectedExercises.append(ex)
            checkIfDoneButtonVisible()
            updateSelectionLabel()
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if isSelectionEnable {
            let ex = exercises[indexPath.row]
            selectedExercises.remove(at: selectedExercises.firstIndex(of: ex)!)
            checkIfDoneButtonVisible()
            updateSelectionLabel()
        }
    }
    
    private func handleStatistics(exercise: Exercise?) {
        let vc = StatisticsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleDelete(exercise: Exercise?) {
        let vc = DeleteConfirmationViewController()
        vc.completion = { [weak self] isOkay in
            DispatchQueue.main.async {
                if isOkay && exercise != nil {
                    let workots = CoreDataManager.shared.fetchWorkouts(exercise: exercise!)
                    for w in workots{
                        CoreDataManager.shared.deleteSetsWithWorkout(workout: w)
                    }
                    CoreDataManager.shared.delete(array: workots)
                    CoreDataManager.shared.delete(obj: exercise!)
                    self?.getExercises()
                    NotificationCenter.default.post(name: NSNotification.Name("reloadWorkouts"), object: nil)
                }
            }
        }
        navigationController?.present(vc, animated: true)
    }
    
    private func handleEdit(exercise: Exercise?) {
        let vc = NameSetterViewController()
        vc.completion = { [weak self] name in
            DispatchQueue.main.async {
                if exercise != nil{
                    CoreDataManager.shared.updateExercise(ex: exercise!, newname: name ?? "Default name")
                    self?.getExercises()
                    NotificationCenter.default.post(name: NSNotification.Name("reloadWorkouts"), object: nil)
                }
            }
        }
        navigationController?.present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if !isSelectionEnable {
            let statisticsAction = UIContextualAction(style: .normal, title: "Statistics"){ [weak self] (action, view, completionHandler) in
                self?.handleStatistics(exercise: self?.exercises[indexPath.row])
                completionHandler(true)
            }
            statisticsAction.backgroundColor = #colorLiteral(red: 0.834133327, green: 0.834133327, blue: 0.834133327, alpha: 1)
            
            return UISwipeActionsConfiguration(actions: [statisticsAction])
        }
        else { return nil }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if !isSelectionEnable {
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete"){ [weak self] (action, view, completionHandler) in
                self?.handleDelete(exercise: self?.exercises[indexPath.row])
                completionHandler(true)
            }
            
            let editAction = UIContextualAction(style: .normal, title: "Edit"){ [weak self] (action, view, completionHandler) in
                self?.handleEdit(exercise: self?.exercises[indexPath.row])
                completionHandler(true)
            }
            editAction.backgroundColor = #colorLiteral(red: 0.659389317, green: 0.8405041099, blue: 1, alpha: 1)
            
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
            configuration.performsFirstActionWithFullSwipe = false
            
            return configuration
        }
        else { return nil }
    }
}
