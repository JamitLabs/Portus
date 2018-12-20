//
//  Created by Cihat Gündüz on 19.11.18.
//  Copyright © 2018 Jamit Labs. All rights reserved.
//

@testable import Portus
import XCTest

class PortusTests: XCTestCase {
    override func tearDown() {
        super.tearDown()

        MaraudersMap.shared.currentPath.forEach { MaraudersMap.shared.didLeave($0) }
    }

    func testEnteringAndLeaving() {
        XCTAssertEqual(MaraudersMap.shared.currentPath.count, 0)

        let enteredRoute = linearlyEnterIssueDetails()
        XCTAssertEqual(MaraudersMap.shared.currentPath.count, enteredRoute.count)

        enteredRoute.forEach { MaraudersMap.shared.didLeave($0) }
        XCTAssertEqual(MaraudersMap.shared.currentPath.count, 0)
    }

    func testLinearlyFirstLevelPortKeyRoutingAlwaysFromRoot() {
        let enteredRoute: [PortKeyLeavable] = linearlyEnterIssueDetails()

        let (routeToLeave, routeToEnter) = Portus.pathToDestination(portKey: EverydayEmptyObject.repositories, routingStrategy: .alwaysFromRoot)
        XCTAssertEqual(routeToLeave.map { $0 as! UIViewController }, enteredRoute.map { $0 as! UIViewController })
        XCTAssertEqual(routeToEnter.map { $0.routingId }, [RepositoriesViewController.routingId])
    }

    func testLinearlyLastLevelPortKeyRoutingAlwaysFromRoot() {
        let enteredRoute: [PortKeyLeavable] = linearlyEnterIssueDetails()

        let (routeToLeave, routeToEnter) = Portus.pathToDestination(portKey: EverydayEmptyObject.newComment, routingStrategy: .alwaysFromRoot)
        XCTAssertEqual(routeToLeave.map { $0 as! UIViewController }, enteredRoute.map { $0 as! UIViewController })
        XCTAssertEqual(routeToEnter.map { $0.routingId }, enteredRoute.map { type(of: ($0 as! PortKeyEnterable)).routingId })
    }

    func testLinearlyFirstLevelPortKeyRoutingMaxReusageFromRoot() {
        let enteredRoute: [PortKeyLeavable] = linearlyEnterIssueDetails()

        let (routeToLeave, routeToEnter) = Portus.pathToDestination(portKey: EverydayEmptyObject.repositories, routingStrategy: .maxReusageFromRoot)
        XCTAssertEqual(routeToLeave.map { $0 as! UIViewController }, enteredRoute.dropFirst().map { $0 as! UIViewController })
        XCTAssertEqual(routeToEnter.map { $0.routingId }, [])
    }

    func testLinearlyLastLevelPortKeyRoutingMaxReusageFromRoot() {
        linearlyEnterIssueDetails()

        let (routeToLeave, routeToEnter) = Portus.pathToDestination(portKey: EverydayEmptyObject.newComment, routingStrategy: .maxReusageFromRoot)
        XCTAssertEqual(routeToLeave.map { $0 as! UIViewController }, [])
        XCTAssertEqual(routeToEnter.map { $0.routingId }, [])
    }

    func testLinearlyFirstLevelPortKeyRoutingMinRouteToLeaf() {
        let enteredRoute: [PortKeyLeavable] = linearlyEnterIssueDetails()

        let (routeToLeave, routeToEnter) = Portus.pathToDestination(portKey: EverydayEmptyObject.repositories, routingStrategy: .minRouteToLeaf)
        XCTAssertEqual(routeToLeave.map { $0 as! UIViewController }, enteredRoute.dropFirst().map { $0 as! UIViewController })
        XCTAssertEqual(routeToEnter.map { $0.routingId }, [])
    }

    func testLinearlyLastLevelPortKeyRoutingMinRouteToLeaf() {
        linearlyEnterIssueDetails()

        let (routeToLeave, routeToEnter) = Portus.pathToDestination(portKey: EverydayEmptyObject.newComment, routingStrategy: .minRouteToLeaf)
        XCTAssertEqual(routeToLeave.map { $0 as! UIViewController }, [])
        XCTAssertEqual(routeToEnter.map { $0.routingId }, [])
    }

    func testRoundaboutWayFirstLevelPortKeyRoutingAlwaysFromRoot() {
        let enteredRoute: [PortKeyLeavable] = roundaboutWayEnterIssueDetails()

        let (routeToLeave, routeToEnter) = Portus.pathToDestination(portKey: EverydayEmptyObject.repositories, routingStrategy: .alwaysFromRoot)
        XCTAssertEqual(routeToLeave.map { $0 as! UIViewController }, enteredRoute.map { $0 as! UIViewController })
        XCTAssertEqual(routeToEnter.map { $0.routingId }, [RepositoriesViewController.routingId])
    }

    func testRoundaboutWayLastLevelPortKeyRoutingAlwaysFromRoot() {
        let enteredRoute: [PortKeyLeavable] = roundaboutWayEnterIssueDetails()

        let (routeToLeave, routeToEnter) = Portus.pathToDestination(portKey: EverydayEmptyObject.newComment, routingStrategy: .alwaysFromRoot)
        XCTAssertEqual(routeToLeave.map { $0 as! UIViewController }, enteredRoute.map { $0 as! UIViewController })
        XCTAssertEqual(routeToEnter.map { $0.routingId }, EverydayEmptyObject.newComment.route.map { $0.routingId })
    }

    func testRoundaboutWayFirstLevelPortKeyRoutingMaxReusageFromRoot() {
        let enteredRoute: [PortKeyLeavable] = roundaboutWayEnterIssueDetails()

        let (routeToLeave, routeToEnter) = Portus.pathToDestination(portKey: EverydayEmptyObject.repositories, routingStrategy: .maxReusageFromRoot)
        XCTAssertEqual(routeToLeave.map { $0 as! UIViewController }, enteredRoute.dropFirst().map { $0 as! UIViewController })
        XCTAssertEqual(routeToEnter.map { $0.routingId }, [])
    }

    func testRoundaboutWayLastLevelPortKeyRoutingMaxReusageFromRoot() {
        let enteredRoute: [PortKeyLeavable] = roundaboutWayEnterIssueDetails()

        let (routeToLeave, routeToEnter) = Portus.pathToDestination(portKey: EverydayEmptyObject.newComment, routingStrategy: .maxReusageFromRoot)
        XCTAssertEqual(routeToLeave.map { $0 as! UIViewController }, enteredRoute.dropFirst().map { $0 as! UIViewController })
        XCTAssertEqual(routeToEnter.map { $0.routingId }, EverydayEmptyObject.newComment.route.dropFirst().map { $0.routingId })
    }

    func testRoundaboutWayFirstLevelPortKeyRoutingMinRouteToLeaf() {
        let enteredRoute: [PortKeyLeavable] = roundaboutWayEnterIssueDetails()

        let (routeToLeave, routeToEnter) = Portus.pathToDestination(portKey: EverydayEmptyObject.repositories, routingStrategy: .minRouteToLeaf)
        XCTAssertEqual(routeToLeave.map { $0 as! UIViewController }, enteredRoute.dropFirst().map { $0 as! UIViewController })
        XCTAssertEqual(routeToEnter.map { $0.routingId }, [])
    }

    func testRoundaboutWayLastLevelPortKeyRoutingMinRouteToLeaf() {
        roundaboutWayEnterIssueDetails()

        let (routeToLeave, routeToEnter) = Portus.pathToDestination(portKey: EverydayEmptyObject.newComment, routingStrategy: .minRouteToLeaf)
        XCTAssertEqual(routeToLeave.map { $0 as! UIViewController }, [])
        XCTAssertEqual(routeToEnter.map { $0.routingId }, [])
    }

    func testRoundaboutWayMiddleLevelPortKeyRoutingAlwaysFromRoot() {
        let enteredRoute: [PortKeyLeavable] = roundaboutWayEnterIssueDetails()

        let (routeToLeave, routeToEnter) = Portus.pathToDestination(portKey: EverydayEmptyObject.repository, routingStrategy: .alwaysFromRoot)
        XCTAssertEqual(routeToLeave.map { $0 as! UIViewController }, enteredRoute.map { $0 as! UIViewController })
        XCTAssertEqual(routeToEnter.map { $0.routingId }, EverydayEmptyObject.repository.route.map { $0.routingId })
    }

    func testRoundaboutWayMiddleLevelPortKeyRoutingMaxReusageFromRoot() {
        let enteredRoute: [PortKeyLeavable] = roundaboutWayEnterIssueDetails()

        let (routeToLeave, routeToEnter) = Portus.pathToDestination(portKey: EverydayEmptyObject.repository, routingStrategy: .maxReusageFromRoot)
        XCTAssertEqual(routeToLeave.map { $0 as! UIViewController }, enteredRoute.dropFirst().map { $0 as! UIViewController })
        XCTAssertEqual(routeToEnter.map { $0.routingId }, EverydayEmptyObject.repository.route.dropFirst().map { $0.routingId })
    }

    func testRoundaboutWayMiddleLevelPortKeyRoutingMinRouteToLeaf() {
        let enteredRoute: [PortKeyLeavable] = roundaboutWayEnterIssueDetails()

        let (routeToLeave, routeToEnter) = Portus.pathToDestination(portKey: EverydayEmptyObject.repository, routingStrategy: .minRouteToLeaf)
        XCTAssertEqual(routeToLeave.map { $0 as! UIViewController }, enteredRoute.dropFirst(3).map { $0 as! UIViewController })
        XCTAssertEqual(routeToEnter.map { $0.routingId }, [])
    }

    @discardableResult
    private func linearlyEnterIssueDetails() -> [PortKeyLeavable] {
        let pathToEnter = [RepositoriesViewController(), RepositoryDetailViewController(), IssuesViewController(), IssueDetailViewController()]
        pathToEnter.forEach { MaraudersMap.shared.didEnter($0) }
        return pathToEnter
    }

    @discardableResult
    private func roundaboutWayEnterIssueDetails() -> [PortKeyLeavable] {
        let pathToEnter = [RepositoriesViewController(), IssuesViewController(), RepositoryDetailViewController(), IssueDetailViewController()]
        pathToEnter.forEach { MaraudersMap.shared.didEnter($0) }
        return pathToEnter
    }
}

// MARK: - Test Types
enum EverydayEmptyObject: PortKey {
    case repositories
    case repository
    case newComment

    var route: Route {
        switch self {
        case .repositories:
            return [(RepositoriesViewController.routingId, nil)]

        case .repository:
            return [
                (RepositoriesViewController.routingId, nil),
                (RepositoryDetailViewController.routingId, nil)
            ]

        case .newComment:
            return [
                (RepositoriesViewController.routingId, nil),
                (RepositoryDetailViewController.routingId, nil),
                (IssuesViewController.routingId, nil),
                (IssueDetailViewController.routingId, nil)
            ]
        }
    }
}

enum EverydayObject: PortKey {
    case repositories
    case repository(name: String)
    case newComment(repositoryName: String, issueNum: Int, commentId: String)

    var route: Route {
        switch self {
        case .repositories:
            return [(RepositoriesViewController.routingId, nil)]

        case let .repository(name):
            return [
                (RepositoriesViewController.routingId, nil),
                (RepositoryDetailViewController.routingId, name)
            ]

        case let .newComment(repositoryName, issueNum, commentId):
            return [
                (RepositoriesViewController.routingId, nil),
                (RepositoryDetailViewController.routingId, repositoryName),
                (IssuesViewController.routingId, issueNum),
                (IssueDetailViewController.routingId, commentId)
            ]
        }
    }
}

class RepositoriesViewController: UIViewController, PortKeyEnterable {
    static func enter(from presentingViewController: UIViewController, info: Any?, animated: Bool, completion: @escaping () -> Void) {
        let navigationCtrl = UINavigationController(rootViewController: RepositoriesViewController())
        presentingViewController.present(navigationCtrl, animated: animated, completion: completion)
    }
}

class RepositoryDetailViewController: UIViewController, PortKeyEnterable {
    static func enter(from presentingViewController: UIViewController, info: Any?, animated: Bool, completion: @escaping () -> Void) {
        presentingViewController.navigationController?.pushViewController(RepositoryDetailViewController(), animated: animated)

        let delay: DispatchTimeInterval = animated ? .milliseconds(300) : .milliseconds(50)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { completion() }
    }
}

class IssuesViewController: UIViewController, PortKeyEnterable {
    static func enter(from presentingViewController: UIViewController, info: Any?, animated: Bool, completion: @escaping () -> Void) {
        let navigationCtrl = UINavigationController(rootViewController: IssuesViewController())
        presentingViewController.present(navigationCtrl, animated: animated, completion: completion)
    }
}

class IssueDetailViewController: UIViewController, PortKeyEnterable {
    static func enter(from presentingViewController: UIViewController, info: Any?, animated: Bool, completion: @escaping () -> Void) {
        presentingViewController.navigationController?.pushViewController(IssueDetailViewController(), animated: animated)

        let delay: DispatchTimeInterval = animated ? .milliseconds(300) : .milliseconds(50)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { completion() }
    }
}
