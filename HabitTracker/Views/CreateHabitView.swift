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

    private let reminderTimePickerText: UILabel = {
        let label = UILabel()
        label.text = "Reminder Date"

        return label
    }()
    
    private let reminderSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = false
        return toggle
    }()

    private let colorButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Color", for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray.cgColor
        button.layer.cornerRadius = 8
        button.backgroundColor = .clear
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    private let chooseDaysLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose Days"

        return label
    }()

    private let daysStack = UIStackView()
    private var dayButtons: [UIButton] = []
    private let daysOfWeek = ["S", "M", "T", "W", "T", "F", "S"]
    private var selectedDays: [Bool] = Array(repeating: false, count: 7)

    private func setupDayButtons() {
        daysStack.axis = .horizontal
        daysStack.distribution = .fillEqually
        daysStack.spacing = 8

        for i in 0..<daysOfWeek.count {
            let button = UIButton(type: .system)
            button.setTitle(daysOfWeek[i], for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = .clear
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.systemGray.cgColor
            button.layer.cornerRadius = 20
            button.tag = i
            button.addTarget(
                self,
                action: #selector(dayButtonTapped(_:)),
                for: .touchUpInside
            )

            dayButtons.append(button)
            daysStack.addArrangedSubview(button)
        }
    }

    private func setupDaysStack() {
        daysStack.axis = .horizontal
        daysStack.distribution = .fillEqually
        daysStack.spacing = 8

        for button in dayButtons {
            daysStack.addArrangedSubview(button)
        }
    }

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
        view.addSubview(reminderTimePickerText)
        view.addSubview(colorButton)
        view.addSubview(chooseDaysLabel)
        view.addSubview(reminderSwitch)


        setupDayButtons()
        view.addSubview(daysStack)

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

        colorButton.addTarget(
            self,
            action: #selector(showColorPicker),
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
            make.top.equalTo(dismissAddingButton.snp.bottom).offset(100)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(50)
        }

        titleText.snp.makeConstraints { make in
            make.bottom.equalTo(titleTextField.snp.top).offset(-5)
            make.left.right.equalTo(titleTextField)
        }

        reminderTimePickerText.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(25)
               make.left.equalTo(colorButton)
        }
        
        reminderSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(reminderTimePickerText)
                make.right.equalTo(titleTextField)
        }
        
        reminderTimePicker.snp.makeConstraints { make in
            make.top.equalTo(reminderTimePickerText.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
        }

        chooseDaysLabel.snp.makeConstraints { make in
            make.bottom.equalTo(daysStack.snp.top).offset(-5)
            make.left.right.equalTo(daysStack)
        }

        daysStack.snp.makeConstraints { make in
            make.top.equalTo(reminderTimePickerText.snp.bottom).offset(110)
            make.left.right.equalTo(colorButton)
            make.height.equalTo(40)
        }

        colorButton.snp.makeConstraints { make in
            make.top.equalTo(daysStack.snp.bottom).offset(40)
            make.left.right.equalTo(titleTextField)
            make.height.equalTo(50)
        }

    }

    @objc private func addTapped() {
        print("add tapped")
    }

    @objc private func dismissTapped() {
        print("dismiss tapped")
    }

    @objc private func showColorPicker() {
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        colorPicker.selectedColor = .black
        present(colorPicker, animated: true)
    }

    @objc private func dayButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        selectedDays[index].toggle()

        if selectedDays[index] {
            sender.backgroundColor = .systemGreen
            sender.setTitleColor(.white, for: .normal)
        } else {
            sender.backgroundColor = .clear
            sender.setTitleColor(.black, for: .normal)
        }
    }



}

extension CreateHabitView: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(
        _ viewController: UIColorPickerViewController
    ) {
        let selectedColor = viewController.selectedColor
        colorButton.backgroundColor = selectedColor

        if selectedColor.isDarkColor {
            colorButton.setTitleColor(.white, for: .normal)
        } else {
            colorButton.setTitleColor(.black, for: .normal)
        }
    }
}

extension UIColor {
    var isDarkColor: Bool {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        let luminance = 0.299 * red + 0.587 * green + 0.114 * blue
        return luminance < 0.5
    }
}

#Preview("Page 1") {
    let context = CoreDataStack.shared.context
    let viewModel = CreateHabitViewModel(context: context)

    UINavigationController(
        rootViewController: CreateHabitView(viewModel: viewModel)
    )
}
