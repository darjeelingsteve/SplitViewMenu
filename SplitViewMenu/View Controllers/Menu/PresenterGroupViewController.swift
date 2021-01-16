//
//  PresenterGroupViewController.swift
//  SplitViewMenu
//
//  Created by Stephen Anthony on 16/01/2021.
//

import UIKit

/// The view controller responsible for showing the presenters in a presenter
/// group.
final class PresenterGroupViewController: UIViewController {
    
    /// The delegate of the receiver.
    weak var delegate: PresenterGroupViewControllerDelegate?
    
    private let presenterGroup: PresenterGroup
    
    init(presenterGroup: PresenterGroup) {
        self.presenterGroup = presenterGroup
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var collectionView: UICollectionView = { [weak self] in
        let collectionViewLayout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            return .list(using: configuration, layoutEnvironment: layoutEnvironment)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<String, Presenter> = {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Presenter> { cell, indexPath, presenter in
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = presenter.name
            cell.contentConfiguration = contentConfiguration
            cell.accessories = [.disclosureIndicator()]
        }
        let dataSource = UICollectionViewDiffableDataSource<String, Presenter>(collectionView: collectionView) { collectionView, indexPath, presenter -> UICollectionViewCell in
           return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: presenter)
        }
        return dataSource
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = presenterGroup.name
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        var snapshot = NSDiffableDataSourceSnapshot<String, Presenter>()
        snapshot.appendSections(["Section"])
        snapshot.appendItems(presenterGroup.presenters)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - UICollectionViewDelegate
extension PresenterGroupViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        if let selectedPresenter = dataSource.itemIdentifier(for: indexPath) {
            delegate?.presenterGroupViewController(self, didSelectPresenter: selectedPresenter)
        }
    }
}

/// The protocol to conform to for delegates of `PresenterGroupViewController`.
protocol PresenterGroupViewControllerDelegate: AnyObject {
    
    /// The message sent when the user selects a presenter.
    /// - Parameters:
    ///   - presenterGroupViewController: The controller sending the message.
    ///   - presenter: The presenter selected by the user.
    func presenterGroupViewController(_ presenterGroupViewController: PresenterGroupViewController, didSelectPresenter presenter: Presenter)
}
