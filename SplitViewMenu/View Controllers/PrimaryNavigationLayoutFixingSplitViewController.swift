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
    private var primaryColumnFrameKVOToken: NSKeyValueObservation?
    private var primaryColumnSafeAreaInsetsKVOToken: NSKeyValueObservation?
    
    override func setViewController(_ vc: UIViewController?, for column: UISplitViewController.Column) {
        super.setViewController(vc, for: column)
        guard column == .primary, let viewController = vc else { return }
        
        primaryColumnFrameKVOToken = viewController.view.observe(\.frame) { [weak self, weak viewController] (_, _) in
            guard let viewController = viewController else { return }
            self?.applyCorrectLayoutIfNeeded(toPrimaryColumnViewController: viewController)
        }
        primaryColumnSafeAreaInsetsKVOToken = viewController.view.observe(\.safeAreaInsets) { [weak self, weak viewController] (_, _) in
            guard let viewController = viewController else { return }
            guard viewController.view.safeAreaInsets.left == 0, viewController.view.safeAreaInsets.right == 0 else { return }
            self?.applyCorrectLayoutIfNeeded(toPrimaryColumnViewController: viewController)
        }
    }
    
    private func applyCorrectLayoutIfNeeded(toPrimaryColumnViewController primaryColumnViewController: UIViewController) {
        guard !isCollapsed, view.bounds.intersects(primaryColumnViewController.view.frame) else {
            /// The primary column view controller's view is not visible, so
            /// we do not need to make any adjustments.
            return
        }
        
        applyCorrectSafeAreaInsets(to: primaryColumnViewController)
        if let childNavigationController = primaryColumnViewController.children.first as? UINavigationController {
            /// Mark the navigation bar as needing layout to ensure that a
            /// fresh layout pass occurs, which makes sure that
            /// `displayModeButtonItem` is visible.
            childNavigationController.navigationBar.setNeedsLayout()
        }
    }
    
    private func applyCorrectSafeAreaInsets(to viewController: UIViewController) {
        let correctHorizontalSafeAreaInsets = self.correctHorizontalSafeAreaInsets(forPrimaryColumnView: viewController.view)
        
        if viewController.view.safeAreaInsets.left != correctHorizontalSafeAreaInsets.left {
            viewController.additionalSafeAreaInsets.left = 0
            viewController.additionalSafeAreaInsets.left = correctHorizontalSafeAreaInsets.left - viewController.view.safeAreaInsets.left
        } else if viewController.view.safeAreaInsets.right != correctHorizontalSafeAreaInsets.right {
            viewController.additionalSafeAreaInsets.right = 0
            viewController.additionalSafeAreaInsets.right = correctHorizontalSafeAreaInsets.right - viewController.view.safeAreaInsets.right
        }
    }
    
    private func correctHorizontalSafeAreaInsets(forPrimaryColumnView primaryColumnView: UIView) -> UIEdgeInsets {
        let requiredHorizontalSafeAreaInset = primaryColumnView.bounds.width - primaryColumnWidth
        
        /// Create the `primaryColumnView` frame in the split view's coordinate
        /// space.
        let convertedPrimaryColumnViewFrame = view.convert(primaryColumnView.bounds, from: primaryColumnView)
        
        if convertedPrimaryColumnViewFrame.origin.x < 0 {
            /// The primary column view is positioned to the left of the split
            /// view, so we need to adjust its left safe area inset to
            /// compensate.
            return UIEdgeInsets(top: 0, left: requiredHorizontalSafeAreaInset, bottom: 0, right: 0)
        } else if convertedPrimaryColumnViewFrame.maxX > view.bounds.maxX {
            /// The primary column view is positioned to the right of the split
            /// view, so we need to adjust its right safe area inset to
            /// compensate.
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: requiredHorizontalSafeAreaInset)
        }
        return .zero
    }
}
