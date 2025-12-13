//
//  HabitTrackerView.swift
//  HabitTracker
//
//  Created by Danylo Onosov on 20.11.2025.
//

import SnapKit
import UIKit
import CoreData


class HabitTrackerView: UIViewController
{
    let viewModel: HabitListViewModel
    var curFilterType: HabitFilter = .newest
    lazy var tableView: UITableView =
    {
        let tableView = UITableView()
        tableView.register(HabitRow.self, forCellReuseIdentifier: "HabitRow")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    init(viewModel: HabitListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        viewModel.load(filterType: curFilterType)
        tableView.reloadData()
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    func setupNavigation()
    {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapAdd)
        )
        updateFilterMenu()
    }
    
    func updateFilterMenu()
    {
        let filterMenu = UIMenu(title: "Filter by", children: [
            UIAction(title: "The newest", image: UIImage(systemName: "calendar"), state: curFilterType == .newest ? .on : .off)
            {
                [weak self] _ in
                self?.applyFilter(.newest)
            },
            UIAction(title: "Name", image: UIImage(systemName: "textformat"), state: curFilterType == .alpha ? .on : .off)
            {
                [weak self] _ in
                self?.applyFilter(.alpha)
            },
            UIAction(title: "The longest streak", image: UIImage(systemName: "flame"), state: curFilterType == .streak ? .on : .off)
            {
                [weak self] _ in
                self?.applyFilter(.streak)
            }
        ])
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: nil,
            image: UIImage(systemName: "arrow.up.arrow.down.circle"),
            primaryAction: nil,
            menu: filterMenu
        )
    }

    func setupUI()
    {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
    }

    func setupConstraints()
    {
        tableView.snp.makeConstraints
        {
            make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func applyFilter(_ type: HabitFilter)
    {
        curFilterType = type
        viewModel.load(filterType: type)
        tableView.reloadData()
        updateFilterMenu()
    }
    
    @objc func didTapAdd()
    {
        let createVM = CreateHabitViewModel(context: viewModel.context)
        let createVC = CreateHabitView(viewModel: createVM)
        navigationController?.pushViewController(createVC, animated: true)
    }
}

extension HabitTrackerView: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return viewModel.habits.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if var cell = tableView.dequeueReusableCell(withIdentifier: "HabitRow", for: indexPath) as? HabitRow
        {
            let habit = viewModel.habits[indexPath.row]
            cell.setup(with: habit)
            return cell
            
        }
        else
        {
            fatalError("Some error occured.")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        var selHabit = viewModel.habits[indexPath.row]
        var detailsVM = HabitDetailsViewModel(context: viewModel.context)
        var detailsVC = HabitDetailsView(viewModel: detailsVM, habitID: selHabit.id!)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            let delHabit = viewModel.habits[indexPath.row]
            viewModel.delete(delHabit)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
