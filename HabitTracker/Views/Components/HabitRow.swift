//
//  HabitRow.swift
//  HabitTracker
//
//  Created by Danylo Onosov on 22.11.2025.
//

import Foundation
import UIKit
import SnapKit

final class HabitRow: UITableViewCell
{
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier ?? "HabitRow")
        
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    var onCheckCompletion: (() -> Void)?
    
    func setup(with habit: Habit)
    {
        configure(with: habit, isCompleted: false, streak: 0)
        checkButton.isHidden = true
        streakLabel.isHidden = true
        titleLabel.snp.remakeConstraints
        {
            make in
            make.leading.equalTo(colorIndicator.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    
    let colorIndicator: UIView =
    {
        let view = UIView()
        view.layer.cornerRadius = 10
        return view
    }()
    
    let titleLabel: UILabel =
    {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    let streakLabel: UILabel =
    {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    lazy var checkButton: UIButton =
    {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleCheckButton), for: .touchUpInside)
        return button
    }()
    
    func setupUI()
    {
        contentView.addSubview(colorIndicator)
        contentView.addSubview(titleLabel)
        contentView.addSubview(streakLabel)
        contentView.addSubview(checkButton)
        
        colorIndicator.snp.makeConstraints
        {
            make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        checkButton.snp.makeConstraints
        {
            make in
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(44)
        }
        
        titleLabel.snp.makeConstraints
        {
            make in
            make.leading.equalTo(colorIndicator.snp.trailing).offset(12)
            make.top.equalToSuperview().offset(8)
            make.trailing.equalTo(checkButton.snp.leading).offset(-8)
        }
        
        streakLabel.snp.makeConstraints
        {
            make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.bottom.equalToSuperview().offset(-8)
        }
    }
    
    @objc func handleCheckButton()
    {
        onCheckCompletion?()
    }
    
    func configure(with habit: Habit, isCompleted: Bool, streak: Int)
    {
        titleLabel.text = habit.title
        streakLabel.text = "🔥 \(streak) days"
        streakLabel.isHidden = false
        
        if let colorHex = habit.color
        {
            colorIndicator.backgroundColor = colorFromHex(colorHex)
        }
        else
        {
            colorIndicator.backgroundColor = .gray
        }
        
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold)
        let imageString = isCompleted ? "checkmark.circle.fill" : "circle"
        let image = UIImage(systemName: imageString, withConfiguration: config)
        
        checkButton.setImage(image, for: .normal)
        checkButton.tintColor = isCompleted ? .systemGreen : .systemGray3
    }
    
    private func colorFromHex(_ hex: String) -> UIColor
    {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000FF) / 255.0
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}


//#if DEBUG
//
//import SwiftUI
//
//struct HabitRow_Preview: PreviewProvider {
//    
//    static func cellPreview() -> some View {
//        let cell = HabitRow()
//        
//        cell.setup(with: .init(
//            id: UUID(), title: "t", color: "#000", createdAt: Date.now, schedule: [], completions: []
//        ))
//        
//        cell.backgroundColor = .lightGray
//        
//        return ViewWrapper(view: cell)
//    }
//    
//    static var previews: some View {
//        Group {
//            cellPreview()
//            .frame(height: 90).previewDisplayName("default")
//        }
//    }
//    
//}
//
//#endif

