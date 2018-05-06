/**
 * Copyright (c) 2018 Ivan Magda
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

// MARK: RootNavigationManager

final class RootNavigationManager {

    // MARK: Instance Variables

    private let splitDelegate = SplitViewControllerDelegate()

    // weak refs to avoid cycles
    weak private var rootViewController: UISplitViewController?

    weak private var detailNavigationController: UINavigationController?

    init(with window: UIWindow?) {
        guard let rootViewController = window?.rootViewController as? UISplitViewController else {
            fatalError("RootViewController should be UISplitViewController")
        }

        self.rootViewController = rootViewController
        rootViewController.delegate = splitDelegate
        rootViewController.preferredDisplayMode = .allVisible

        self.tabBarController?.tabBar.tintColor = Styles.Colors.Blue.medium.color
        self.tabBarController?.tabBar.unselectedItemTintColor = Styles.Colors.Gray.light.color

        self.detailNavigationController = rootViewController.viewControllers.last as? UINavigationController
        detailNavigationController?.topViewController?.navigationItem.leftBarButtonItem = rootViewController.displayModeButtonItem
    }

    // MARK: Public API

    public func resetRootViewController() {
        tabBarController?.viewControllers = [
            newSearchRootViewController(),
            newFavoriteRootViewController()
        ]
    }

    // MARK: Private API

    private var rootNavigationController: UINavigationController? {
        return tabBarController?.selectedViewController as? UINavigationController
    }

    private var tabBarController: TabBarController? {
        return rootViewController?.viewControllers.first as? TabBarController
    }

    private func newSearchRootViewController() -> UIViewController {
        let controller = SearchViewController()
        
        let nav = UINavigationController(rootViewController: controller)
        nav.navigationBar.prefersLargeTitles = true
        nav.tabBarItem = UITabBarItem(
            tabBarSystemItem: .search,
            tag: TabBarController.Tab.search.rawValue
        )

        return nav
    }

    private func newFavoriteRootViewController() -> UIViewController {
        let controller = FavoriteViewController()

        let nav = UINavigationController(rootViewController: controller)
        nav.navigationBar.prefersLargeTitles = true
        nav.tabBarItem = UITabBarItem(
            tabBarSystemItem: .favorites,
            tag: TabBarController.Tab.favorite.rawValue
        )

        return nav
    }
    
}