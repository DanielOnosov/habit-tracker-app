//
//  View1.swift
//  HabitTracker
//
//  Created by Danylo Onosov on 20.11.2025.
//

import SnapKit
import UIKit
import CoreData


class HabitTrackerView: UIViewController {
    private let viewModel: HabitListViewModel
    
    init(viewModel: HabitListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private var label: UILabel = {
        let label = UILabel()
        label.text = "Main Screen"
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        
        viewModel.load()
        label.text = "habits count: \(viewModel.habits.count)"
    }
    
    private func setupUI() {
        view.addSubview(label)
    }
    
    private func setupConstraints() {
        label.snp.makeConstraints{ item in
            item.center.equalToSuperview()
        }
    }
    
//    @objc private func didTapAdd() {
//        let context = viewModel.context
//        
//        let createVM = CreateHabitViewModel(context: context)
//        
//        let createVC = CreateHabitView(viewModel: createVM)
//        
//        navigationController?.pushViewController(createVC, animated: true)
//    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedHabit = viewModel.habits[indexPath.row]
//        let context = viewModel.context
//        
//        let detailsVM = HabitDetailsViewModel(context: context)
//        let detailsVC = HabitDetailsView(viewModel: detailsVM)
//        
//        navigationController?.pushViewController(detailsVC, animated: true)
//    }
}

#Preview("Habit List") {
    let context = CoreDataStack.shared.context
    let listViewModel = HabitListViewModel(context: context)
    
    return UINavigationController(rootViewController: HabitTrackerView(viewModel: listViewModel))
}
