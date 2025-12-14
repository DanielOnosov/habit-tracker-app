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
    private let habitToEdit: Habit?

    init(viewModel: CreateHabitViewModel, habit: Habit? = nil) {
        self.viewModel = viewModel
        self.habitToEdit = habit
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    private var label: UILabel = {
        let label = UILabel()
        label.text = "Create a Habit"
        label.font = UIFont(name: "ChalkboardSE-Bold", size: 30)

        return label
    }()

    private let addHabitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = false
        button.contentEdgeInsets = UIEdgeInsets(
            top: 10,
            left: 20,
            bottom: 10,
            right: 20
        )
        button.addTarget(
            nil,
            action: #selector(buttonTouchedDown(_:)),
            for: .touchDown
        )
        button.addTarget(
            nil,
            action: #selector(buttonTouchedUp(_:)),
            for: .touchUpInside
        )
        button.addTarget(
            nil,
            action: #selector(buttonTouchedUp(_:)),
            for: .touchUpOutside
        )

        return button
    }()

    private let dismissAddingButton: UIButton = {
        let button = UIButton()
        button.setTitle("Dismiss", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemRed.cgColor
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = false
        button.contentEdgeInsets = UIEdgeInsets(
            top: 10,
            left: 20,
            bottom: 10,
            right: 20
        )
        button.addTarget(
            nil,
            action: #selector(buttonTouchedDown(_:)),
            for: .touchDown
        )
        button.addTarget(
            nil,
            action: #selector(buttonTouchedUp(_:)),
            for: .touchUpInside
        )
        button.addTarget(
            nil,
            action: #selector(buttonTouchedUp(_:)),
            for: .touchUpOutside
        )

        return button
    }()

    private let titleTextField: UITextField = {
        let textField = UITextField()
//        textField.placeholder = "Enter habit name"
        textField.text = "New Habit"
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
        picker.datePickerMode = .time
        return picker
    }()

    private let reminderTimePickerText: UILabel = {
        let label = UILabel()
        label.text = "Reminder Time"

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
        button.layer.borderWidth = 0
        button.layer.cornerRadius = 8
        button.backgroundColor = .clear
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.contentHorizontalAlignment = .left

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

    private let colourCircle: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray.cgColor
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        populateIfEditing()
    }
    
    private func populateIfEditing() {
        guard let habit = habitToEdit else { return }

        titleTextField.text = habit.title ?? ""

        if let hex = habit.color, let color = UIColor(hex: hex) {
            colourCircle.backgroundColor = color
        }

        if let time = habit.reminderTime {
            reminderSwitch.isOn = true
            reminderTimePicker.isHidden = false
            reminderTimePicker.date = time
        }

        if let schedule = habit.schedule as? [NSNumber] {
            selectedDays = Array(repeating: false, count: 7)
            for day in schedule.compactMap({ $0.intValue }) {
                if day >= 0 && day < 7 {
                    selectedDays[day] = true
                    let button = dayButtons[day]
                    button.backgroundColor = .systemGreen
                    button.setTitleColor(.white, for: .normal)
                }
            }
        }

        label.text = "Edit Habit"
        addHabitButton.setTitle("Save", for: .normal)
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
        view.addSubview(colourCircle)

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

        reminderSwitch.addTarget(
            self,
            action: #selector(reminderSwitchChanged(_:)),
            for: .valueChanged
        )

    }

    private func setupConstraints() {
        label.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(-25)
            make.centerX.equalToSuperview()
        }

        dismissAddingButton.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(620)
            make.left.equalToSuperview().offset(50)
            make.width.equalTo(110)
        }

        addHabitButton.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(620)
            make.right.equalToSuperview().inset(50)
            make.width.equalTo(110)
        }

        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(100)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(50)
        }

        titleText.snp.makeConstraints { make in
            make.bottom.equalTo(titleTextField.snp.top).offset(-5)
            make.left.right.equalTo(titleTextField)
        }

        reminderTimePickerText.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(50)
            make.left.equalTo(titleTextField)
            make.centerY.equalTo(reminderSwitch)
        }

        reminderSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(reminderTimePickerText)
            make.right.equalTo(titleTextField)
        }

        reminderTimePicker.snp.makeConstraints { make in
            make.centerY.equalTo(reminderTimePickerText)
            make.left.equalTo(reminderTimePickerText.snp.right).offset(20)
        }

        reminderTimePicker.isHidden = true

        chooseDaysLabel.snp.makeConstraints { make in
            make.bottom.equalTo(daysStack.snp.top).offset(-5)
            make.left.right.equalTo(daysStack)
        }

        daysStack.snp.makeConstraints { make in
            make.top.equalTo(reminderTimePickerText.snp.bottom).offset(70)
            make.left.right.equalTo(colorButton)
            make.height.equalTo(40)
        }

        colorButton.snp.makeConstraints { make in
            make.top.equalTo(daysStack.snp.bottom).offset(50)
            make.left.right.equalTo(titleTextField)
            make.height.equalTo(40)
        }

        colourCircle.snp.makeConstraints { make in
            make.centerY.equalTo(colorButton)
            make.left.equalTo(colorButton.snp.left).inset(115)
            make.width.height.equalTo(40)
        }

    }

    @objc private func addTapped() {
        let payload = HabitPayload(
            title: titleTextField.text ?? "",
            reminderTime: reminderSwitch.isOn ? reminderTimePicker.date : nil,
            color: colourCircle.backgroundColor?.toHexString() ?? "#00FF00",
            schedule: selectedDays.enumerated()
                .compactMap { $1 ? $0 : nil }
        )

//        viewModel.add(payload)
        if let habit = habitToEdit {
                viewModel.update(habit, with: payload)
            } else {
                viewModel.add(payload)
            }
        print("add tapped")
        
        let createVM = HabitListViewModel(context: viewModel.context)
        let createVC = HabitTrackerView(viewModel: createVM)
        navigationController?.pushViewController(createVC, animated: true)
        
        //this screen closes -- all habits opens
        
    }

    @objc private func dismissTapped() {
        print("dismiss tapped")
        //this screen closes -- all habits opens
        
        let createVM = HabitListViewModel(context: viewModel.context)
        let createVC = HabitTrackerView(viewModel: createVM)
        navigationController?.pushViewController(createVC, animated: true)
        
    }

    @objc private func buttonTouchedDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.alpha = 0.7
            sender.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }
    }

    @objc private func buttonTouchedUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.15) {
            sender.alpha = 1.0
            sender.transform = .identity
        }
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

    @objc private func reminderSwitchChanged(_ sender: UISwitch) {
        print("remind")
        reminderTimePicker.isHidden = !sender.isOn
    }

}

extension CreateHabitView: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(
        _ viewController: UIColorPickerViewController
    ) {
        let selectedColor = viewController.selectedColor
        colourCircle.backgroundColor = selectedColor
    }
}

#Preview("Page 1") {
    let context = CoreDataStack.shared.context
    let viewModel = CreateHabitViewModel(context: context)

    UINavigationController(
        rootViewController: CreateHabitView(viewModel: viewModel)
    )
}
