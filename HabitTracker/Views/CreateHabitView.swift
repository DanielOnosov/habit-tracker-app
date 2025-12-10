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
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter habit name"
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private var titleText: UILabel = {
        let label = UILabel()
        label.text = "Habit Name"

        return label
    }()
    
    private let reminderTimePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        return picker
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
        view.addSubview(titleTextField)
        view.addSubview(titleText)
        view.addSubview(reminderTimePicker)

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
                make.top.equalTo(label.snp.bottom).offset(20)
                make.left.equalToSuperview().offset(25)
            }

            addHabitButton.snp.makeConstraints { make in
                make.top.equalTo(label.snp.bottom).offset(20)
                make.right.equalToSuperview().inset(25)
            }
            
            titleTextField.snp.makeConstraints { make in
                make.top.equalTo(dismissAddingButton.snp.bottom).offset(60)
                make.left.right.equalToSuperview().inset(30)
                make.height.equalTo(50)
            }
        
        titleText.snp.makeConstraints { make in
            make.bottom.equalTo(titleTextField.snp.top).offset(-5)
                make.left.right.equalTo(titleTextField)
        }
        
        reminderTimePicker.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(20)
            make.left.right.equalTo(titleTextField)
            make.height.equalTo(100)
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
