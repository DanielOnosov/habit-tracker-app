//
//  View1.swift
//  HabitTracker
//
//  Created by Danylo Onosov on 20.11.2025.
//

import SnapKit
import UIKit


class HabitTrackerView: UIViewController {
    private var label: UILabel = {
        let label = UILabel()
        label.text = "Main Screen"
        
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
    UINavigationController(rootViewController: HabitTrackerView())
}
