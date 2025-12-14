//
//  View1.swift
//  HabitTracker
//
//  Created by Danylo Onosov on 20.11.2025.
//

import SnapKit
import UIKit

class EditHabitView: UIViewController {
    private let viewModel: EditHabitViewModel
    
    init(viewModel: EditHabitViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private var label: UILabel = {
        let label = UILabel()
        label.text = "Edit a Habbit"
        label.font = UIFont(name: "ChalkboardSE-Bold", size: 30)
        
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
    let viewModel = EditHabitViewModel(context: context, habitID: UUID())
    
    UINavigationController(rootViewController: EditHabitView(viewModel: viewModel))
}
