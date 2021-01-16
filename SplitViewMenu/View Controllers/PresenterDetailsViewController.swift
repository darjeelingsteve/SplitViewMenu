//
//  PresenterDetailsViewController.swift
//  SplitViewMenu
//
//  Created by Stephen Anthony on 16/01/2021.
//

import UIKit

/// The view controller used to show the details for a presenter.
final class PresenterDetailsViewController: UIViewController {
    private let presenter: Presenter
    
    init(presenter: Presenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        
        let photoView = PresenterPhotoView(presenter: presenter)
        photoView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(photoView)
        NSLayoutConstraint.activate([
            photoView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            photoView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 60)
        ])
        
        let nameLabel = UILabel(text: presenter.name, textStyle: .title2)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            nameLabel.firstBaselineAnchor.constraint(equalToSystemSpacingBelow: photoView.bottomAnchor, multiplier: 2.0)
        ])
        
        let biographyLabel = UILabel(text: presenter.biography, colour: .secondaryLabel, numberOfLines: 0)
        biographyLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(biographyLabel)
        NSLayoutConstraint.activate([
            biographyLabel.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            biographyLabel.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            biographyLabel.firstBaselineAnchor.constraint(equalToSystemSpacingBelow: nameLabel.lastBaselineAnchor, multiplier: 1.0)
        ])
    }
}

/// The view used to display a presenter's photo.
private final class PresenterPhotoView: UIView {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemBackground
        return imageView
    }()
    
    init(presenter: Presenter) {
        super.init(frame: .zero)
        imageView.image = UIImage(named: presenter.name)
        addSubview(imageView)
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 200),
            heightAnchor.constraint(equalTo: widthAnchor)
        ])
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = bounds.width / 2
        layer.shadowRadius = bounds.width / 10
        layer.shadowOffset = CGSize(width: 0, height: layer.shadowRadius / 2)
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: imageView.layer.cornerRadius).cgPath
    }
}
