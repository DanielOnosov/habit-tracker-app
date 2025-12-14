//
//  HabitDetailsView.swift
//  HabitTracker
//
//  Created by Danylo Onosov on 20.11.2025.
//

import SnapKit
import UIKit
import CoreData


class HabitDetailsView: UIViewController
{
    
    private let viewModel: HabitDetailsViewModel
    private let habitID: UUID
    var contentView: UIView = UIView()
    var streakContainer = UIView()
    
    init(viewModel: HabitDetailsViewModel, habitID: UUID) {
        self.viewModel = viewModel
        self.habitID = habitID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    var scrollView: UIScrollView =
    {
        let sv = UIScrollView()
        sv.backgroundColor = .systemBackground
        sv.alwaysBounceVertical = true
        return sv
    }()
    
    var stackView: UIStackView =
    {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 24
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 40, trailing: 20)
        return stack
    }()
    
    let titleLabel: UILabel =
    {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    let streakLabel: UILabel =
    {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    let coefficientLabel: UILabel =
    {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    let heatmapContainer: UIView =
    {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 12
        return view
    }()
    
    let heatmapTitle: UILabel =
    {
        let label = UILabel()
        label.text = "Activity for last 91 days"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .secondaryLabel
        return label
    }()
    
    let heatmapGrid: UIStackView =
    {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .fillEqually
        return stack
    }()
    
    let completionsLabel: UILabel =
    {
        let label = UILabel()
        label.text = "History"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    let completionsTextView: UITextView =
    {
        let tv = UITextView()
        tv.isEditable = false
        tv.isScrollEnabled = false
        tv.font = .systemFont(ofSize: 15, weight: .regular)
        tv.layer.cornerRadius = 12
        tv.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        loadHabitDetails()
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func setupUI()
    {
        view.backgroundColor = .systemBackground
        title = "Details"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(didTapEdit))
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        let statsStack = UIStackView(arrangedSubviews: [streakLabel, coefficientLabel])
        statsStack.axis = .vertical
        statsStack.spacing = 6
        stackView.addArrangedSubview(statsStack)
        let heatmapWrap = UIStackView(arrangedSubviews: [heatmapTitle, heatmapContainer])
        heatmapWrap.axis = .vertical
        heatmapWrap.spacing = 10
        stackView.addArrangedSubview(heatmapWrap)
        heatmapContainer.addSubview(heatmapGrid)
        stackView.setCustomSpacing(30, after: heatmapWrap)
        stackView.addArrangedSubview(completionsLabel)
        stackView.addArrangedSubview(completionsTextView)
    }
    
    func setupConstraints()
    {
        scrollView.snp.makeConstraints
        {
            make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints
        {
            make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        stackView.snp.makeConstraints
        {
            make in
            make.edges.equalToSuperview()
        }
        
        heatmapContainer.snp.makeConstraints
        {
            make in
            make.height.greaterThanOrEqualTo(100)
        }
        
        heatmapGrid.snp.makeConstraints
        {
            make in
            make.edges.equalToSuperview().inset(15)
        }
    }
    
    func loadHabitDetails()
    {
        guard let details = viewModel.findOneById(id: habitID)
        else
        {
            return
        }
        
        titleLabel.text = details.title
        titleLabel.textColor = colorFromHex(details.color)
        streakLabel.text = "Current streak: \(details.streakDays) days"
        let percentage = Int(details.coefficient * 100)
        coefficientLabel.text = "Consistency: \(percentage)%"
        
        let lastCompletions = details.completions.suffix(10).reversed()
        let historyText = lastCompletions
            .map { formatDate($0, format: "d MMM yyyy, HH:mm") }
            .joined(separator: "\n\n")
        
        completionsTextView.text = historyText.isEmpty ? "No completions yet." : historyText
        drawHeatmap(completions: details.heatMap, color: colorFromHex(details.color))
    }
    
    func drawHeatmap(completions: [Date: Bool], color: UIColor)
    {
        heatmapGrid.arrangedSubviews.forEach { $0.removeFromSuperview() }
        var colsCount = 13
        var rowsCount = 7
        let calendar = Calendar.current
        
        var totalDays = colsCount * rowsCount
        guard let startDate = calendar.date(byAdding: .day, value: -(totalDays - 1), to: Date())
        else
        {
            return
            
        }
        
        var _: [UIStackView] = []
        
        heatmapGrid.axis = .horizontal
        heatmapGrid.spacing = 4
        heatmapGrid.distribution = .fillEqually
        
        var curDate = startDate
        
        for _ in 0..<colsCount
        {
            var colsStack = UIStackView()
            colsStack.axis = .vertical
            colsStack.spacing = 4
            colsStack.distribution = .fillEqually
            
            for _ in 0..<rowsCount
            {
                var dayView = UIView()
                dayView.layer.cornerRadius = 2
                
                var dayStart = calendar.startOfDay(for: curDate)
                let isCompl = completions[dayStart] ?? false

                if isCompl
                {
                    dayView.backgroundColor = color
                }
                else
                {
                    dayView.backgroundColor = .systemGray
                }

                if curDate > Date()
                {
                    dayView.backgroundColor = .clear
                }

                
                if curDate > Date()
                {
                    dayView.backgroundColor = .clear
                }
                
                dayView.snp.makeConstraints
                {
                    make in
                    make.width.height.equalTo(16)
                }
                
                colsStack.addArrangedSubview(dayView)
                
                curDate = calendar.date(byAdding: .day, value: 1, to: curDate)!
            }
            heatmapGrid.addArrangedSubview(colsStack)
        }
    }
    
    func colorFromHex(_ hex: String) -> UIColor
    {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        return UIColor(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: 1.0
        )
    }
    
    func formatDate(_ date: Date, format: String) -> String
    {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    @objc func didTapEdit()
    {
        let editVM = CreateHabitViewModel(context: viewModel.context)
        let editVC = CreateHabitView(viewModel: editVM, habit: habitById(habitID, context: viewModel.context))
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    
    func habitById(_ id: UUID, context: NSManagedObjectContext) -> Habit? {
        let request: NSFetchRequest<Habit> = Habit.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        
        do {
            return try context.fetch(request).first
        } catch {
            print("Error fetching habit: \(error)")
            return nil
        }
    }

}

#Preview("Habit Details") {
    let context = CoreDataStack.shared.context
    let habitID = UUID()
    
    let viewModel = HabitDetailsViewModel(context: context)
    
    UINavigationController(
        rootViewController: HabitDetailsView(
            viewModel: viewModel,
            habitID: habitID
        )
    )
}

