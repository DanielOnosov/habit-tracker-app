//
//  HabitRow.swift
//  HabitTracker
//
//  Created by Danylo Onosov on 22.11.2025.
//

import Foundation
import UIKit
import SnapKit

final class HabitRow: UITableViewCell {
    // add elements such as color, ttitle, text, circle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier ?? "HabitRow")
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // init positions
    }
    
    func setup(with: Habit) {
        // init data here
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

