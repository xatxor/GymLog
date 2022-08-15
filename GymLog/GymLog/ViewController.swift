//
//  ViewController.swift
//  GymLog
//
//  Created by Вика on 8/14/22.
//

import UIKit
import FSCalendar

class ViewController: UIViewController {
    
    var selectedDate = Date()
    
    var selectedIndex: IndexPath = IndexPath(row: -1, section: -1)
    
    private var calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.translatesAutoresizingMaskIntoConstraints = false
        return calendar
    }()
    
    var calendarHeightConstraint: NSLayoutConstraint!
    
    let showHideButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("open", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let tableView: UITableView = {
        let tb = UITableView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        return tb
    }()
    
    func setTitle()->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM"
        let str = dateFormatter.string(from: selectedDate)
        
        return str
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = setTitle()
        showHideButton.setTitle(setTitle(), for: .normal)
        
        setupCalendar()
        
        setupTableView()
    }
    
    func setupCalendar(){
        swipeAction()
        
        view.addSubview(calendar)
        
        calendar.dataSource = self
        calendar.delegate = self
        
        calendar.scope = .week
        calendar.appearance.headerTitleColor = UIColor.black
        calendar.appearance.weekdayTextColor = UIColor.black
        calendar.appearance.todaySelectionColor = UIColor.darkGray
        calendar.appearance.todayColor = UIColor.darkGray
        calendar.appearance.selectionColor = UIColor.gray
        calendar.appearance.weekdayFont = UIFont.systemFont(ofSize: 16)
        calendar.appearance.titleFont = UIFont.boldSystemFont(ofSize: 20)
        calendar.headerHeight = 0
        
        calendarHeightConstraint = NSLayoutConstraint(item: calendar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 400)
        calendar.addConstraint(calendarHeightConstraint)
        
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: view.topAnchor, constant: 90),
            calendar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            calendar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        
        view.addSubview(showHideButton)
        
        showHideButton.backgroundColor = .clear
        showHideButton.layer.cornerRadius = 7
        showHideButton.layer.borderWidth = 2
        showHideButton.layer.borderColor = UIColor.darkGray.cgColor
        
        showHideButton.addTarget(self, action: #selector(showHideButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            showHideButton.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 2),
            showHideButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            showHideButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc func showHideButtonTapped(){
        if calendar.scope == .week{
            calendar.setScope(.month, animated: true)
        } else {
            calendar.setScope(.week, animated: true)
        }
    }
    
    func swipeAction(){
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeUp.direction = .up
        calendar.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeDown.direction = .down
        calendar.addGestureRecognizer(swipeDown)
    }
    
    @objc func handleSwipe(gesture: UISwipeGestureRecognizer){
        switch gesture.direction {
        case .up:
            calendar.setScope(.week, animated: true)
        case .down:
            calendar.setScope(.month, animated: true)
        default:
            break
        }
    }
    
    func setupTableView(){
        
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.clipsToBounds = true
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.register(WorkoutCell.self, forCellReuseIdentifier: "workoutcell")
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: showHideButton.bottomAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}

extension ViewController: FSCalendarDataSource, FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeightConstraint.constant = bounds.height
        view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        showHideButton.setTitle(setTitle(), for: .normal)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedIndex == indexPath { return 200 }
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workoutcell", for: indexPath) as! WorkoutCell
        cell.selectionStyle = .none
        cell.animate()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath == selectedIndex {
            selectedIndex = IndexPath(row: -1, section: -1)
        }
        else{
            selectedIndex = indexPath
        }
        
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
    }
}
