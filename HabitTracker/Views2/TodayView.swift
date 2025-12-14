//
//  TodayView.swift
//  HabitTracker
//
//  Created by Dasha on 13.12.2025.
//

import UIKit
import SnapKit

class TodayView: UIViewController {

    let viewModel: TodayViewModel
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(HabitRow.self, forCellReuseIdentifier: "HabitRow")
        tv.tableFooterView = UIView()
        tv.dataSource = self
        tv.delegate = self
        return tv
    }()
    
    let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "No habits for today."
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    init(viewModel: TodayViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        loadData()
    }
    
    func loadData() {
        viewModel.load()
        updateDateHeader()
        tableView.reloadData()
        emptyStateLabel.isHidden = !viewModel.todayHabits.isEmpty
    }
    
    func updateDateHeader() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "EEEE, d MMM"
        self.title = formatter.string(from: Date()).capitalized
    }
    
    func setupUI() {
        view.addSubview(tableView)
        view.addSubview(emptyStateLabel)
    }
    
    func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        emptyStateLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

extension TodayView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.todayHabits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HabitRow", for: indexPath) as? HabitRow else {
            return UITableViewCell()
        }
        
        let habit = viewModel.todayHabits[indexPath.row]
        let isDone = viewModel.isCompleted(habit: habit)
        let streak = viewModel.getStreak(habit: habit)
        
        cell.configure(with: habit, isCompleted: isDone, streak: streak)
        
        cell.onCheckCompletion = { [weak self] in
            guard let self = self else { return }
            
            self.viewModel.toggleHabitCompletion(habit)
            self.loadData()
            
            if !isDone {
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let habit = viewModel.todayHabits[indexPath.row]
        let detailsVM = HabitDetailsViewModel(context: CoreDataStack.shared.context)
        let detailsVC = HabitDetailsView(viewModel: detailsVM, habitID: habit.id!)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completion) in
            self?.viewModel.deleteHabit(indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self?.loadData()
            completion(true)
        }
        delAction.image = UIImage(systemName: "trash")
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (_, _, completion) in
            guard let self = self else { return }
            let habit = self.viewModel.todayHabits[indexPath.row]
            
            guard let habitID = habit.id else {
                completion(false)
                return
            }
            
            let editVM = EditHabitViewModel(context: CoreDataStack.shared.context, habitID: habitID)
            let editVC = EditHabitView(viewModel: editVM)
            self.navigationController?.pushViewController(editVC, animated: true)
            completion(true)
        }
        editAction.backgroundColor = .systemBlue
        editAction.image = UIImage(systemName: "pencil")
        
        return UISwipeActionsConfiguration(actions: [delAction, editAction])
    }
}

#Preview("Today") {
    let context = CoreDataStack.shared.context
    let viewModel = TodayViewModel(context: context)

    UINavigationController(
        rootViewController: TodayView(viewModel: viewModel)
    )
}
