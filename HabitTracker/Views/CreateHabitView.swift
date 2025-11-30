//
//  View1.swift
//  HabitTracker
//
//  Created by Danylo Onosov on 20.11.2025.
//

import SnapKit
import UIKit


class CreateHabitView: UIViewController {
    private let viewModel: CreateHabitViewModel
    
    init(viewModel: CreateHabitViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private var label: UILabel = {
        let label = UILabel()
        label.text = "Create Habit"
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        view.addSubview(label)
    }
    
    private func setupConstraints() {
        label.snp.makeConstraints{ item in
            item.center.equalToSuperview()
        }
    }
}

#Preview("Page 1") {
    let context = CoreDataStack.shared.context
    let viewModel = CreateHabitViewModel(context: context)
    
    UINavigationController(rootViewController: CreateHabitView(viewModel: viewModel))
}
