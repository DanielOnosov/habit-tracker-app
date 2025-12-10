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
        label.text = "Create a Habit"

        return label
    }()

    private let addHabitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.black, for: .normal)

        return button
    }()

    private let dismissAddingButton: UIButton = {
        let button = UIButton()
        button.setTitle("Dismiss", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemRed.cgColor

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    private func setupUI() {
        view.addSubview(label)
        view.addSubview(addHabitButton)
        view.addSubview(dismissAddingButton)

        addHabitButton.addTarget(
            self,
            action: #selector(addTapped),
            for: .touchUpInside
        )
        dismissAddingButton.addTarget(
            self,
            action: #selector(dismissTapped),
            for: .touchUpInside
        )

    }

    private func setupConstraints() {
        label.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(-25)
            make.centerX.equalToSuperview()
        }

        dismissAddingButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.left.equalToSuperview().offset(16)
        }

        addHabitButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.right.equalToSuperview().inset(16)
        }
    }

    @objc private func addTapped() {
        print("add tapped")
    }

    @objc private func dismissTapped() {
        print("dismiss tapped")
    }

}

#Preview("Page 1") {
    let context = CoreDataStack.shared.context
    let viewModel = CreateHabitViewModel(context: context)

    UINavigationController(
        rootViewController: CreateHabitView(viewModel: viewModel)
    )
}
