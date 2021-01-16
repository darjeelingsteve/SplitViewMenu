//
//  PresenterGroupsViewController.swift
//  SplitViewMenu
//
//  Created by Stephen Anthony on 16/01/2021.
//

import UIKit

/// The view controller responsible for showing a list of presenter groups.
final class PresenterGroupsViewController: UIViewController {
    
    /// The delegate of the receiver.
    weak var delegate: PresenterGroupsViewControllerDelegate?
    
    private let presenterGroups: [PresenterGroup]
    
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
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<String, PresenterGroup> = {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, PresenterGroup> { cell, indexPath, group in
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = group.name
            cell.contentConfiguration = contentConfiguration
            cell.accessories = [.disclosureIndicator()]
        }
        let dataSource = UICollectionViewDiffableDataSource<String, PresenterGroup>(collectionView: collectionView) { collectionView, indexPath, presenterGroup -> UICollectionViewCell in
           return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: presenterGroup)
        }
        return dataSource
    }()
    
    init(presenterGroups: [PresenterGroup]) {
        self.presenterGroups = presenterGroups
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        var snapshot = NSDiffableDataSourceSnapshot<String, PresenterGroup>()
        snapshot.appendSections(["Section"])
        snapshot.appendItems(presenterGroups)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - UICollectionViewDelegate
extension PresenterGroupsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        if let selectedGroup = dataSource.itemIdentifier(for: indexPath) {
            delegate?.presenterGroupsViewController(self, didSelectPresenterGroup: selectedGroup)
        }
    }
}

/// The protocol to conform to for delegates of
/// `PresenterGroupsViewController`.
protocol PresenterGroupsViewControllerDelegate: AnyObject {
    
    /// The message sent when the user selects a presenter group.
    /// - Parameters:
    ///   - presenterGroupsViewController: The controller sending the message.
    ///   - presenterGroup: The presenter group selected by the user.
    func presenterGroupsViewController(_ presenterGroupsViewController: PresenterGroupsViewController, didSelectPresenterGroup presenterGroup: PresenterGroup)
}
