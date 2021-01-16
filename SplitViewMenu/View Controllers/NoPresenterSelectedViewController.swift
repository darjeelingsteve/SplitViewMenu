//
//  NoPresenterSelectedViewController.swift
//  SplitViewMenu
//
//  Created by Stephen Anthony on 16/01/2021.
//

import UIKit

/// The view controller used as a placeholder when no presenter has been
/// selected yet.
final class NoPresenterSelectedViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        
        let labelsWrapperView = self.labelsWrapperView()
        view.addSubview(labelsWrapperView)
        NSLayoutConstraint.activate([
            labelsWrapperView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            labelsWrapperView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            labelsWrapperView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func labelsWrapperView() -> UIView {
        let titleLabel = UILabel(text: "No presenter selected", textStyle: .title3, alignment: .center, numberOfLines: 1)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let subtitleLabel = UILabel(text: "Select a presenter from the menu.", colour: .secondaryLabel, alignment: .center, numberOfLines: 0)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let labelsWrapperView = UIView()
        labelsWrapperView.translatesAutoresizingMaskIntoConstraints = false
        labelsWrapperView.addSubview(titleLabel)
        labelsWrapperView.addSubview(subtitleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: labelsWrapperView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: labelsWrapperView.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: labelsWrapperView.topAnchor)
        ])
        NSLayoutConstraint.activate([
            subtitleLabel.leadingAnchor.constraint(equalTo: labelsWrapperView.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: labelsWrapperView.trailingAnchor),
            subtitleLabel.firstBaselineAnchor.constraint(equalToSystemSpacingBelow: titleLabel.lastBaselineAnchor, multiplier: 1.0),
            subtitleLabel.bottomAnchor.constraint(equalTo: labelsWrapperView.bottomAnchor)
        ])
        return labelsWrapperView
    }
}
