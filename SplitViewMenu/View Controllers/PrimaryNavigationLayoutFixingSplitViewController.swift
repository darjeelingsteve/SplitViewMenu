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
        
            guard viewController.view.frame.maxX > 0 else {
        primaryColumnSafeAreaInsetsKVOToken = viewController.view.observe(\.safeAreaInsets) { [weak self, weak viewController] (_, _) in
            guard let self = self, !self.isCollapsed, let viewController = viewController else { return }
                /// The primary column view controller's view is not visible, so
                /// we do not need to make any adjustments.
                return
            }
            
            let expectedLeftSafeAreaInset: CGFloat = -viewController.view.frame.origin.x
            if viewController.view.safeAreaInsets.left != expectedLeftSafeAreaInset {
                /// Constrain to a minimum additional left inset of 0 to prevent
                /// incorrect layouts when the split view transitions from
                /// compact to regular width.
                viewController.additionalSafeAreaInsets.left = max(0, expectedLeftSafeAreaInset - viewController.view.safeAreaInsets.left)
            }
            if let childNavigationController = viewController.children.first as? UINavigationController {
                /// Mark the navigation bar as needing layout to ensure that a
                /// fresh layout pass occurs, which makes sure that
                /// `displayModeButtonItem` is visible.
                childNavigationController.navigationBar.setNeedsLayout()
            }
        }
    }
}
