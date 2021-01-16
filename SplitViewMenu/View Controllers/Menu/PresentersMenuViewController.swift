//
//  PresentersMenuViewController.swift
//  SplitViewMenu
//
//  Created by Stephen Anthony on 16/01/2021.
//

import UIKit

/// The view controller used to allow the user to select a presenter from the
/// available groups of presenters.
final class PresentersMenuViewController: UIViewController {
    
    /// The delegate of the receiver.
    weak var delegate: PresentersMenuViewControllerDelegate?
    
    private let presenterGroupsViewController: PresenterGroupsViewController = {
        let groupData = try! Data(contentsOf: Bundle.main.url(forResource: "MasterChefPresenterGroups", withExtension: "json")!)
        let presenterGroups = try! JSONDecoder().decode([PresenterGroup].self, from: groupData)
        return PresenterGroupsViewController(presenterGroups: presenterGroups)
    }()
    
    private let childNavigationController = UINavigationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        childNavigationController.viewControllers = [presenterGroupsViewController]
        addChild(childNavigationController)
        view.addSubview(childNavigationController.view)
        childNavigationController.view.frame = view.bounds
        childNavigationController.didMove(toParent: self)
        presenterGroupsViewController.navigationItem.title = "MasterChef Presenters"
        presenterGroupsViewController.delegate = self
    }
}

// MARK: - PresenterGroupsViewControllerDelegate
extension PresentersMenuViewController: PresenterGroupsViewControllerDelegate {
    func presenterGroupsViewController(_ presenterGroupsViewController: PresenterGroupsViewController, didSelectPresenterGroup presenterGroup: PresenterGroup) {
        let presenterGroupViewController = PresenterGroupViewController(presenterGroup: presenterGroup)
        presenterGroupViewController.delegate = self
        childNavigationController.show(presenterGroupViewController, sender: self)
    }
}

// MARK: - PresenterGroupViewControllerDelegate
extension PresentersMenuViewController: PresenterGroupViewControllerDelegate {
    func presenterGroupViewController(_ presenterGroupViewController: PresenterGroupViewController, didSelectPresenter presenter: Presenter) {
        delegate?.presentersMenuViewController(self, didSelectPresenter: presenter)
    }
}

/// The protocol to conform to for delegates of `PresentersMenuViewController`.
protocol PresentersMenuViewControllerDelegate: AnyObject {
    
    /// The message sent when the user selects a presenter.
    /// - Parameters:
    ///   - presentersMenuViewController: The controller sending the message.
    ///   - presenter: The presenter selected by the user.
    func presentersMenuViewController(_ presentersMenuViewController: PresentersMenuViewController, didSelectPresenter presenter: Presenter)
}
