//
//  ViewController.swift
//  GymLog
//
//  Created by Вика on 8/14/22.
//

import UIKit
import FSCalendar

class MainViewController: UIViewController, EditSetCellProtocol {
    
    // TODO: добавить под календарем view с оценкой своей тренировки по цветной пятибальной шкале,
    // потом на календаре отмечать дни цветов соответствующим оценке
    
    // TODO: добавить программы тренировок
    
    // TODO: добавить анимации ко всем кнопкам
    
    // TODO: добавить картинки на фон при отсутствии данных
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadWorkouts), name: NSNotification.Name("reloadWorkouts"), object: nil)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .black
        navigationItem.backButtonTitle = ""
        
        view.backgroundColor = .white
        
        setTitle()
        
        getWorkouts()
        setupButtons()
        setupCalendar()
        setupTableView()
        setupContainer()
        setupAddButton()
    }
    
    //MARK: NavBar Buttons
    
    private let dataButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white

        let config = UIImage.SymbolConfiguration(
            pointSize: 20, weight: .regular, scale: .default)
        let icon = UIImage(systemName: "book", withConfiguration: config)
        button.setImage(icon, for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let settingsButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        
        let config = UIImage.SymbolConfiguration(
            pointSize: 20, weight: .regular, scale: .default)
        let icon = UIImage(systemName: "gear", withConfiguration: config)
        button.setImage(icon, for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private func setupButtons(){
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
    private var selectedDate = Date()
    
    private func setTitle(){
        
        let str: String
        
        if Calendar.current.isDateInToday(selectedDate) { str = "Today" }
        else if Calendar.current.isDateInYesterday(selectedDate) { str = "Yesterday" }
        else if Calendar.current.isDateInTomorrow(selectedDate) { str = "Tomorrow" }
        else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d MMMM"
            str = dateFormatter.string(from: selectedDate)
        }
        title = str
    }
    
    private let showHideButton: UIButton = {
        let button = UIButton()
        
        //button.setTitle("open", for: .normal)
        //button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        
        button.tintColor = .black
        button.setImage(UIImage(systemName: "chevron.compact.down"), for: .normal)
        
        button.backgroundColor = .clear
        button.layer.cornerRadius = 7
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.darkGray.cgColor
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private func changeShowHideButtonTitle(){
        // TODO: добавить анимацию
        if calendar.scope == .week {
            showHideButton.setImage(UIImage(systemName: "chevron.compact.down"), for: .normal)
        } else {
            showHideButton.setImage(UIImage(systemName: "chevron.compact.up"), for: .normal)
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
    private func swipeAction(){
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
    
    private var calendarHeightConstraint: NSLayoutConstraint!

    private func setupCalendar(){
        swipeAction()
        
        view.addSubview(calendar)
        
        calendar.dataSource = self
        calendar.delegate = self
        
        calendar.scope = .week
        calendar.appearance.eventOffset = CGPoint(x: 0, y: 3)
        calendar.appearance.eventDefaultColor = .darkGray
        calendar.appearance.eventSelectionColor = .black
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.weekdayTextColor = .black
        calendar.appearance.todaySelectionColor = .darkGray
        calendar.appearance.todayColor = .darkGray
        calendar.appearance.selectionColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        calendar.appearance.weekdayFont = .systemFont(ofSize: 16)
        calendar.appearance.titleFont = .boldSystemFont(ofSize: 20)
        calendar.headerHeight = 0
        calendar.firstWeekday = 2
        
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
            showHideButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            showHideButton.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    //MARK: Container for TableView and AddButton
    
    private let container: UIView = {
        let view = UIView()
        
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private func setupContainer(){
        view.addSubview(container)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: showHideButton.bottomAnchor, constant: 0),
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            container.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }

    //MARK: AddButton
    
    private let addButton: UIButton = {
        let button = UIButton()

        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.tintColor = .darkGray
        
        button.layer.cornerRadius = 30
        button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)

        let config = UIImage.SymbolConfiguration(
            pointSize: 22, weight: .medium, scale: .default)
        let icon = UIImage(systemName: "plus", withConfiguration: config)
        button.setImage(icon, for: .normal)

        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private func setupAddButton(){
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)

        container.addSubview(addButton)

        NSLayoutConstraint.activate([
            addButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -60),
            addButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -50),
            addButton.heightAnchor.constraint(equalToConstant: 60),
            addButton.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc func addButtonTapped(){
        let vc = FoldersViewController()
        vc.title = "New workout"
        vc.isSelectionEnable = true
        vc.selectedDate = self.selectedDate
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK: Workouts TableView
    
    private var workouts: [Workout]?
    
    //выбранная ячейка
    private var selectedIndex: IndexPath = IndexPath(row: -1, section: -1)
    
    private let tableView: UITableView = {
        let tb = UITableView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        return tb
    }()
    
    private func getWorkouts(){
        workouts = CoreDataManager.shared.fetchWorkouts(date: selectedDate)
        tableView.reloadData()
    }
    
    @objc func reloadWorkouts(){
        getWorkouts()
        calendar.reloadData()
    }
    
    private func setupTableView(){
        getWorkouts()
        
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
    // open editsets menu
    func setsTableViewTapped(workout: Workout?){
        let vc = EditSetsViewController()
        if workout != nil {
            vc.workout = workout
            vc.completion = {
                self.tableView.reloadData()
            }
            navigationController?.present(vc, animated: true)
        }
        // TODO: обработчик ошибки
        else {}
    }
}

extension MainViewController: FSCalendarDataSource, FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeightConstraint.constant = bounds.height
        view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        getWorkouts()
        setTitle()
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let ws = CoreDataManager.shared.fetchWorkouts(date: date)
        if ws.count == 0 { return 0 }
        else { return 1 }
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //если ячейка выбрана, увеличиваем ее высоту
        if selectedIndex == indexPath
        {
            let countOfSets = workouts?[indexPath.row].sets?.count ?? 0
            if countOfSets == 0 { return 65 + 40 }
            let height = 65 + 50 * Float16(countOfSets)
            return CGFloat(height)
        }
        return 65
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.workouts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workoutcell", for: indexPath) as! WorkoutCell
        
        cell.selectionStyle = .none
        cell.delegate = self
        
        cell.exercise = self.workouts?[indexPath.row].exercise
        cell.workout = self.workouts?[indexPath.row]
        
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
    
    private func handleDelete(workout: Workout?) {
        if workout != nil{
            CoreDataManager.shared.deleteSetsWithWorkout(workout: workout!)
            CoreDataManager.shared.delete(obj: workout!)
        }
        getWorkouts()
        calendar.reloadData()
    }
    
    private func handleStatistics(exercise: Exercise?) {
        if exercise != nil {
            let vc = StatisticsViewController()
            vc.exercise = exercise
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let statisticsAction = UIContextualAction(style: .normal, title: ""){ [weak self] (action, view, completionHandler) in
            self?.handleStatistics(exercise: self?.workouts?[indexPath.row].exercise)
            completionHandler(true)
        }
        statisticsAction.backgroundColor = #colorLiteral(red: 0.834133327, green: 0.834133327, blue: 0.834133327, alpha: 1)
        
        let config = UIImage.SymbolConfiguration(
            pointSize: 18, weight: .regular, scale: .default)
        let icon = UIImage(systemName: "chart.bar.fill", withConfiguration: config)
        
        statisticsAction.image = icon
        
        let configuration = UISwipeActionsConfiguration(actions: [statisticsAction])
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .destructive, title: ""){ [weak self] (action, view, completionHandler) in
            self?.handleDelete(workout: self?.workouts?[indexPath.row])
            completionHandler(true)
        }
        let config = UIImage.SymbolConfiguration(
            pointSize: 18, weight: .regular, scale: .default)
        let icon = UIImage(systemName: "trash", withConfiguration: config)
        
        deleteAction.image = icon
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
}
