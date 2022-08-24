//
//  ViewController.swift
//  GymLog
//
//  Created by Вика on 8/14/22.
//

import UIKit
import FSCalendar

class MainViewController: UIViewController {
    
    // TODO: добавить под календарем view с оценкой своей тренировки по цветной пятибальной шкале,
    // потом на календаре отмечать дни цветов соответствующим оценке
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .black
        navigationItem.backButtonTitle = ""
        
        view.backgroundColor = .white
        
        title = setTitle()
        
        getWorkouts()
        setupButtons()
        setupCalendar()
        setupTableView()
        setupContainer()
        setupAddButton()
    }
    
    //MARK: DataButton
    
    let dataButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white

        let icon = UIImage(systemName: "book")
        button.setImage(icon, for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let settingsButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        
        let icon = UIImage(systemName: "wrench")
        button.setImage(icon, for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    func setupButtons(){
        dataButton.addTarget(self, action: #selector(dataButtonTapped), for: .touchUpInside)
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        
        navigationItem.rightBarButtonItems =
            [UIBarButtonItem(customView: settingsButton),
             UIBarButtonItem(customView: dataButton)]
    }
    
    @objc func dataButtonTapped(){
        let vc = FoldersViewController()
        vc.title = "Database"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func settingsButtonTapped(){
        let vc = SettingsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Calendar
    
    //выбранная на календаре дата
    var selectedDate = Date()
    
    func setTitle()->String{
        
        if Calendar.current.isDateInToday(selectedDate) { return "Today" }
        if Calendar.current.isDateInYesterday(selectedDate) { return "Yesterday" }
        if Calendar.current.isDateInTomorrow(selectedDate) { return "Tomorrow" }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM"
        let str = dateFormatter.string(from: selectedDate)
        
        return str
    }
    
    let showHideButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("open", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        
        button.backgroundColor = .clear
        button.layer.cornerRadius = 7
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.darkGray.cgColor
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func changeShowHideButtonTitle(){
        // TODO: добавить анимацию
        if showHideButton.titleLabel?.text == "open"{
            showHideButton.setTitle("hide", for: .normal)
        } else {
            showHideButton.setTitle("open", for: .normal)
        }
    }
    
    //меняем режим отображения календаря (на месяц/на неделю) с помощью кнопки
    @objc func showHideButtonTapped(){
        if calendar.scope == .week{
            calendar.setScope(.month, animated: true)
            changeShowHideButtonTitle()
        } else {
            calendar.setScope(.week, animated: true)
            changeShowHideButtonTitle()
        }
    }
    
    //обнаруживаем свайп вниз/вверх
    func swipeAction(){
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeUp.direction = .up
        calendar.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeDown.direction = .down
        calendar.addGestureRecognizer(swipeDown)
    }
    
    //меняем режим отображения календаря (на месяц/на неделю) с помощью свайпа вниз/вверх
    @objc func handleSwipe(gesture: UISwipeGestureRecognizer){
        switch gesture.direction {
        case .up:
            calendar.setScope(.week, animated: true)
            changeShowHideButtonTitle()
        case .down:
            calendar.setScope(.month, animated: true)
            changeShowHideButtonTitle()
        default:
            break
        }
    }
    
    private var calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.translatesAutoresizingMaskIntoConstraints = false
        return calendar
    }()
    
    var calendarHeightConstraint: NSLayoutConstraint!

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
            calendar.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            calendar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            calendar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        
        view.addSubview(showHideButton)
        
        showHideButton.addTarget(self, action: #selector(showHideButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            showHideButton.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 2),
            showHideButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            showHideButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    //MARK: Container for TableView and AddButton
    
    let container: UIView = {
        let view = UIView()
        
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    func setupContainer(){
        view.addSubview(container)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: showHideButton.bottomAnchor, constant: 0),
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            container.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }

    //MARK: AddButton
    
    let addButton: UIButton = {
        let button = UIButton()

        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.tintColor = .black
        
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 2
        button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        let icon = UIImage(systemName: "plus")
        button.setImage(icon, for: .normal)

        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    func setupAddButton(){
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)

        container.addSubview(addButton)

        NSLayoutConstraint.activate([
            addButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -60),
            addButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -50),
            addButton.heightAnchor.constraint(equalToConstant: 55),
            addButton.widthAnchor.constraint(equalToConstant: 55)
        ])
    }
    
    @objc func addButtonTapped(){
        let vc = FoldersViewController()
        vc.title = "New workout"
        vc.isSelectionEnable = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK: Workouts TableView
    
    var workouts: [Workout]?
    
    //выбранная ячейка
    var selectedIndex: IndexPath = IndexPath(row: -1, section: -1)
    
    let tableView: UITableView = {
        let tb = UITableView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        return tb
    }()
    
    func getWorkouts(){
        //
    }
    
    func setupTableView(){
        container.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.clipsToBounds = true
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.register(WorkoutCell.self, forCellReuseIdentifier: "workoutcell")
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -30)
        ])
    }
}

extension MainViewController: FSCalendarDataSource, FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeightConstraint.constant = bounds.height
        view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        title = setTitle()
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //если ячейка выбрана, увеличиваем ее высоту
        if selectedIndex == indexPath
        {
            let height = 60 + 3*50 + 10 + 10
            return CGFloat(height)
        }
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.workouts?.count ?? 0
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workoutcell", for: indexPath) as! WorkoutCell
        
        cell.selectionStyle = .none
        //cell.title.text = self.workouts![indexPath.row].exercise?.name
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
        //обновляем выбранную ячейку для того чтобы обновилась высота
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
    }
    
    private func handleDelete() {
    }
    
    private func handleStatistics() {
        let vc = StatisticsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        //при свайпе скрываем раскрытую ячейку для хорошего отображения анимации
        if indexPath == selectedIndex {
            selectedIndex = IndexPath(row: -1, section: -1)
            //обновляем выбранную ячейку для того чтобы обновилась высота
            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
        
        let statisticsAction = UIContextualAction(style: .normal, title: "Statistics"){ [weak self] (action, view, completionHandler) in
            self?.handleStatistics()
            completionHandler(true)
        }
        statisticsAction.backgroundColor = #colorLiteral(red: 0.834133327, green: 0.834133327, blue: 0.834133327, alpha: 1)
        
        let configuration = UISwipeActionsConfiguration(actions: [statisticsAction])
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        //при свайпе скрываем раскрытую ячейку для хорошего отображения анимации
        if indexPath == selectedIndex {
            selectedIndex = IndexPath(row: -1, section: -1)
            //обновляем выбранную ячейку для того чтобы обновилась высота
            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete"){ [weak self] (action, view, completionHandler) in
            self?.handleDelete()
            completionHandler(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
}
