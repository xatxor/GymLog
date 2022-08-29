//
//  DataViewController.swift
//  GymLog
//
//  Created by Вика on 8/17/22.
//

import UIKit

class FoldersViewController: UIViewController {
    
    // TODO: добавить кнопку добавления exercise -> добавить доп вид в NameSetterViewController для выбора папки
    
    public var isSelectionEnable = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        drawDottedLines()
        
        updateLabels()
        setupLabels()
        setupTableView()
        setupCreateButton()
        
        getFolders()
    }
    
    //MARK: Dotted Lines
    
    private func drawDottedLines() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        shapeLayer.lineWidth = 2

        let path = CGMutablePath()
        //первая линия
        path.addLines(between: [CGPoint(x: 20, y: 160 + 15), CGPoint(x: view.frame.width - 20, y: 160 + 15)])
        shapeLayer.path = path
        view.layer.addSublayer(shapeLayer)
        //вторая линия
        path.addLines(between: [CGPoint(x: 20, y: 160 + 30 + 10 + 15), CGPoint(x: view.frame.width - 20, y: 160 + 30 + 10 + 15)])
        shapeLayer.path = path
        view.layer.addSublayer(shapeLayer)
    }
    
    //MARK: Labels
    
    private var countOfFolders: Int? {
        didSet{
            updateLabels()
        }
    }
    private var countOfExercises: Int? {
        didSet{
            updateLabels()
        }
    }
    
    private let foldersLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        label.backgroundColor = .white
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let exerciseLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        label.backgroundColor = .white
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func updateLabels(){
        foldersLabel.text = String(countOfFolders ?? 0) + " folders"
        exerciseLabel.text = String(countOfExercises ?? 0) + " exercises"
    }
    
    private func setupLabels(){
        view.addSubview(foldersLabel)
        view.addSubview(exerciseLabel)
        
        NSLayoutConstraint.activate([
            foldersLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            foldersLabel.heightAnchor.constraint(equalToConstant: 30),
            foldersLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        NSLayoutConstraint.activate([
            exerciseLabel.topAnchor.constraint(equalTo: foldersLabel.bottomAnchor, constant: 10),
            exerciseLabel.heightAnchor.constraint(equalToConstant: 30),
            exerciseLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    //MARK: CreateButton
    
    private let createButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("create new folder", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        
        button.backgroundColor = .clear
        button.layer.cornerRadius = 7
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.darkGray.cgColor
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private func setupCreateButton(){
        view.addSubview(createButton)
        
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            createButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 0),
            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    // Create Folder
    @objc func createButtonTapped(){
        let vc = NameSetterViewController()
        vc.completion = { [weak self] name in
            DispatchQueue.main.async {
                CoreDataManager.shared.addFolder(name: name ?? "Default name")
                self?.getFolders()
            }
        }
        navigationController?.present(vc, animated: true)
    }
    
    //MARK: TableView
    
    private var folders = [Folder]()
    
    private func getFolders(){
        folders = CoreDataManager.shared.fetchFolders()
        countOfFolders = folders.count
        tableView.reloadData()
    }
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private func setupTableView(){
        view.addSubview(tableView)
        
        tableView.register(FolderCell.self, forCellReuseIdentifier: "typeofexcell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.clipsToBounds = true
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: exerciseLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -90)
        ])
    }
}
extension FoldersViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "typeofexcell", for: indexPath) as! FolderCell
        
        cell.folder = folders[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ExercisesViewController()
        vc.title = "Database"
        if isSelectionEnable { vc.isSelectionEnable = true}
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleDelete(folder: Folder?) {
        let vc = DeleteConfirmationViewController()
        vc.completion = { [weak self] isOkay in
            DispatchQueue.main.async {
                if isOkay && folder != nil {
                    CoreDataManager.shared.delete(obj: folder!)
                    self?.getFolders()
                }
            }
        }
        navigationController?.present(vc, animated: true)
    }
    
    private func handleEdit(folder: Folder?) {
        let vc = NameSetterViewController()
        vc.completion = { [weak self] name in
            DispatchQueue.main.async {
                if folder != nil{
                    CoreDataManager.shared.updateFolder(folder: folder!, newname: name ?? "Default name")
                    self?.getFolders()
                }
            }
        }
        navigationController?.present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if !isSelectionEnable {
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete"){ [weak self] (action, view, completionHandler) in
                self?.handleDelete(folder: self?.folders[indexPath.row])
                completionHandler(true)
            }
            
            let editAction = UIContextualAction(style: .normal, title: "Edit"){ [weak self] (action, view, completionHandler) in
                self?.handleEdit(folder: self?.folders[indexPath.row])
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
