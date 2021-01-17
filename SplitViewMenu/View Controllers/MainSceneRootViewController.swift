//
//  MainSceneRootViewController.swift
//  SplitViewMenu
//
//  Created by Stephen Anthony on 16/01/2021.
//

import UIKit

/// The view controller responsible for managing the user interface presented in
/// the application's main scene.
final class MainSceneRootViewController: UIViewController {
    private let childSplitViewController: UISplitViewController = {
        let childSplitViewController = PrimaryNavigationLayoutFixingSplitViewController(style: .doubleColumn)
        childSplitViewController.preferredDisplayMode = .oneBesideSecondary
        childSplitViewController.preferredSplitBehavior = .tile
        return childSplitViewController
    }()
    
    private let secondaryColumnNavigationController = UINavigationController(rootViewController: NoPresenterSelectedViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(childSplitViewController)
        view.addSubview(childSplitViewController.view)
        childSplitViewController.didMove(toParent: self)
        
        let presentersMenuViewController = PresentersMenuViewController()
        presentersMenuViewController.delegate = self
        childSplitViewController.setViewController(presentersMenuViewController, for: .primary)
        childSplitViewController.setViewController(secondaryColumnNavigationController, for: .secondary)
        childSplitViewController.setViewController(UINavigationController(rootViewController: NoPresenterSelectedViewController()), for: .compact)
    }
}

// MARK: - PresentersMenuViewControllerDelegate
extension MainSceneRootViewController: PresentersMenuViewControllerDelegate {
    func presentersMenuViewController(_ presentersMenuViewController: PresentersMenuViewController, didSelectPresenter presenter: Presenter) {
        secondaryColumnNavigationController.setViewControllers([PresenterDetailsViewController(presenter: presenter)], animated: false)
    }
}
