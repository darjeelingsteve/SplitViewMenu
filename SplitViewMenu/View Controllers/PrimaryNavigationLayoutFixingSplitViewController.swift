//
//  PrimaryNavigationLayoutFixingSplitViewController.swift
//  SplitViewMenu
//
//  Created by Stephen Anthony on 16/01/2021.
//

import UIKit

/// A `UISplitViewController` subclass that fixes the layout of primary-column
/// child view controllers in which the primary column view controller manages
/// its own child `UINavigationController`.
final class PrimaryNavigationLayoutFixingSplitViewController: UISplitViewController {
    private var primaryColumnSafeAreaInsetsKVOToken: NSKeyValueObservation?
    
    override func setViewController(_ vc: UIViewController?, for column: UISplitViewController.Column) {
        super.setViewController(vc, for: column)
        guard column == .primary, let viewController = vc else { return }
        
        primaryColumnSafeAreaInsetsKVOToken = viewController.view.observe(\.safeAreaInsets) { [weak self, weak viewController] (_, _) in
            guard let self = self, !self.isCollapsed, let viewController = viewController else { return }
            guard self.view.bounds.intersects(viewController.view.frame) else {
                /// The primary column view controller's view is not visible, so
                /// we do not need to make any adjustments.
                return
            }
            
            self.applyAdditionalSafeAreaInsets(to: viewController)
            if let childNavigationController = viewController.children.first as? UINavigationController {
                /// Mark the navigation bar as needing layout to ensure that a
                /// fresh layout pass occurs, which makes sure that
                /// `displayModeButtonItem` is visible.
                childNavigationController.navigationBar.setNeedsLayout()
            }
        }
    }
    
    private func applyAdditionalSafeAreaInsets(to viewController: UIViewController) {
        switch viewController.traitCollection.layoutDirection {
        case .leftToRight, .unspecified:
            let expectedLeftSafeAreaInset: CGFloat = -viewController.view.frame.origin.x
            if viewController.view.safeAreaInsets.left != expectedLeftSafeAreaInset, expectedLeftSafeAreaInset > 0 {
                viewController.additionalSafeAreaInsets.left = expectedLeftSafeAreaInset - viewController.view.safeAreaInsets.left
            }
        case .rightToLeft:
            let expectedRightSafeAreaInset: CGFloat = view.convert(viewController.view.bounds, from: viewController.view).maxX - view.bounds.maxX
            if viewController.view.safeAreaInsets.right != expectedRightSafeAreaInset, expectedRightSafeAreaInset > 0 {
                viewController.additionalSafeAreaInsets.right = expectedRightSafeAreaInset - viewController.view.safeAreaInsets.right
            }
        @unknown default:
            fatalError("Unsupported layout direction")
        }
    }
}
