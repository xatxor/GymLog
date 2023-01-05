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
    // скрыть/отобразить кардио папку
    // настроить цвета тренировок
    
    // переделать settings потому что сделан криво
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setupTableView()
        
        view.backgroundColor = .white
        title = "Settings"
    }
    
    private var settings: [String]?
    
    private func configure(){
        settings = ["Delete all data and set defaults", "Delete all data"]
    }
    
    private func deleteDB(){
        let vc = DeleteConfirmationViewController()
        vc.completion = { [weak self] isOkay in
            if isOkay {
                CoreDataManager.shared.deleteAll()
                NotificationCenter.default.post(name: NSNotification.Name("reloadWorkouts"), object: nil)
                self?.navigationController?.popToRootViewController(animated: true)
            }
        }
        navigationController?.present(vc, animated: true)
    }
    
    private func resetDB(){
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
        return settings?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = settings?[indexPath.row]
        cell.textLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            resetDB()
        }
        else if indexPath.row == 1{
            deleteDB()
        }
    }
}
