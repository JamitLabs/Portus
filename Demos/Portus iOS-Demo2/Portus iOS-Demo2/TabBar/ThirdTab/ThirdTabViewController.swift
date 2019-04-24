//
//  ThirdTabViewController.swift
//  Portus iOS-Demo2
//
//  Created by Andreas Link on 22.04.19.
//  Copyright © 2019 Andreas Link. All rights reserved.
//

import Portus
import UIKit

extension RoutingIdentifier {
    static let thirdTab = RoutingIdentifier(rawValue: "thirdTab")
}

class ThirdTabViewController: UIPageViewController {
    private lazy var firstPageViewController: PageAViewController = {
        let vcA = UIStoryboard(name: "PageAViewController", bundle: nil)
            .instantiateViewController(withIdentifier: "PageAViewController") as! PageAViewController
        vcA.view.backgroundColor = .brown
        return vcA
    }()

    private lazy var secondPageViewController: PageBViewController = {
        let vcB = UIStoryboard(name: "PageBViewController", bundle: nil)
            .instantiateViewController(withIdentifier: "PageBViewController") as! PageBViewController
        vcB.view.backgroundColor = .brown
        return vcB
    }()

    private lazy var thirdPageViewController: PageCViewController = {
        let vcC = UIStoryboard(name: "PageCViewController", bundle: nil)
            .instantiateViewController(withIdentifier: "PageCViewController") as! PageCViewController
        vcC.view.backgroundColor = .brown
        return vcC
    }()

    private lazy var pages: [UIViewController] = [
        firstPageViewController,
        secondPageViewController,
        thirdPageViewController
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        setViewControllers([pages[0]], direction: .forward, animated: false)
        RoutingTree.default.didEnterNode(withEntry: entry)
    }
}

// MARK: - UIPageViewControllerDataSource
extension ThirdTabViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard
            let index = pages.firstIndex(of: viewController),
            pages.indices.contains(index - 1)
        else {
            return nil
        }

        return pages[index - 1]
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard
            let index = pages.firstIndex(of: viewController),
            pages.indices.contains(index + 1)
        else {
            return nil
        }

        return pages[index + 1]
    }
}

// MARK: - UIPageViewControllerDelegate
extension ThirdTabViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        if let viewControllers = pageViewController.viewControllers {
            RoutingTree.default.switchNode(
                withEntry: self.entry,
                didSwitchToNodeWithEntry: (viewControllers[0] as! Routable).entry
            )
        }
    }
}

// MARK: - Routable
extension ThirdTabViewController: Routable {
    var entry: RoutingEntry {
        return RoutingEntry(
            identifier: .thirdTab,
            routable: self,
            managedEntries: RoutingEntry.ManagedEntries(
                entries: pages.map { ($0 as! Routable).entry },
                activeEntry: (pages[0] as! Routable).entry
            )
        )
    }
}

// MARK: - Switchable
extension ThirdTabViewController: Switchable {
    func switchToNode(with entry: RoutingEntry, animated: Bool, completion: @escaping ((Bool) -> Void)) {
        switch entry.identifier {
        case .pageA:
            setViewControllers([firstPageViewController], direction: .forward, animated: false)
            RoutingTree.default.switchNode(
                withEntry: self.entry,
                didSwitchToNodeWithEntry: firstPageViewController.entry
            )
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { completion(true) }

        case .pageB:
            setViewControllers([secondPageViewController], direction: .forward, animated: false)
            RoutingTree.default.switchNode(
                withEntry: self.entry,
                didSwitchToNodeWithEntry: secondPageViewController.entry
            )
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { completion(true) }

        case .pageC:
            setViewControllers([thirdPageViewController], direction: .forward, animated: false)
            RoutingTree.default.switchNode(
                withEntry: self.entry,
                didSwitchToNodeWithEntry: thirdPageViewController.entry
            )
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { completion(true) }

        default:
            completion(false)
        }
    }
}
