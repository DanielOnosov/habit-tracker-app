//
//  HabitDetailsView.swift
//  HabitTracker
//
//  Created by Danylo Onosov on 20.11.2025.
//

import SnapKit
import UIKit


class HabitDetailsView: UIViewController {
    private let viewModel: HabitDetailsViewModel
    
    init(viewModel: HabitDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private var label: UILabel = {
        let label = UILabel()
        label.text = "Habit Details Screen"
        
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
    let viewModel = HabitDetailsViewModel(context: context)
    
    UINavigationController(rootViewController: HabitDetailsView(viewModel: viewModel))
}
