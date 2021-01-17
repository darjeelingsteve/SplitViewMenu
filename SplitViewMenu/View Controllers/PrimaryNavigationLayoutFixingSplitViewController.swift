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
            
            self.applyCorrectSafeAreaInsets(to: viewController)
            if let childNavigationController = viewController.children.first as? UINavigationController {
                /// Mark the navigation bar as needing layout to ensure that a
                /// fresh layout pass occurs, which makes sure that
                /// `displayModeButtonItem` is visible.
                childNavigationController.navigationBar.setNeedsLayout()
            }
        }
    }
    
    private func applyCorrectSafeAreaInsets(to viewController: UIViewController) {
        let correctHorizontalSafeAreaInsets = self.correctHorizontalSafeAreaInsets(forMenuView: viewController.view)
        guard correctHorizontalSafeAreaInsets != .zero else { return }
        
        if viewController.view.safeAreaInsets.left != correctHorizontalSafeAreaInsets.left {
            viewController.additionalSafeAreaInsets.left = correctHorizontalSafeAreaInsets.left - viewController.view.safeAreaInsets.left
        } else if viewController.view.safeAreaInsets.right != correctHorizontalSafeAreaInsets.right {
            viewController.additionalSafeAreaInsets.right = correctHorizontalSafeAreaInsets.right - viewController.view.safeAreaInsets.right
        }
    }
    
    private func correctHorizontalSafeAreaInsets(forMenuView menuView: UIView) -> UIEdgeInsets {
        /// Create the `menuView` frame in the split view's coordinate space.
        let convertedMenuViewFrame = view.convert(menuView.bounds, from: menuView)
        
        /// The amount that `menuView` is offset beyond the split view's left
        /// bounds.
        let leftMenuOffset = view.bounds.origin.x - convertedMenuViewFrame.origin.x
        
        /// The amount that `menuView` is offset beyond the split view's right
        /// bounds.
        let rightOffset = convertedMenuViewFrame.maxX - view.bounds.maxX
        
        if leftMenuOffset > 0 {
            /// The menu view is positioned to the left of the split view, so we
            /// need to adjust its left safe area inset to compensate.
            return UIEdgeInsets(top: 0, left: leftMenuOffset, bottom: 0, right: 0)
        } else if rightOffset > 0 {
            /// The menu view is positioned to the right of the split view, so we
            /// need to adjust its right safe area inset to compensate.
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: rightOffset)
        }
        return .zero
    }
}
