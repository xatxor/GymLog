//
//  SettingsViewController.swift
//  GymLog
//
//  Created by Вика on 8/21/22.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // вкл/выкл оценивание тренировки от 1 до 5
    // настроить вид и цвета оценивания тренировок
    // удалить всю библиотеку тренировок
    // добавить дефолтные папки и упражнения
    // скрыть/отобразить кардио папку
    // настроить цвета тренировок
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setupTableView()
        
        view.backgroundColor = .white
        title = "Settings"
    }
    
    private func configure(){
        
    }
    
    private func deleteDB(){
        let vc = DeleteConfirmationViewController()
        vc.completion = { [weak self] isOkay in
            if isOkay {
                CoreDataManager.shared.deleteAll()
                CoreDataManager.shared.addDefaultData()
                NotificationCenter.default.post(name: NSNotification.Name("reloadWorkouts"), object: nil)
                self?.navigationController?.popToRootViewController(animated: true)
            }
        }
        navigationController?.present(vc, animated: true)
    }
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private func setupTableView(){
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.separatorStyle = .none
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }
}
extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = "Delete all folders and exercises"
        cell.textLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        deleteDB()
    }
}
