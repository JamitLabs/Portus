//
//  Created by Cihat Gündüz on 19.11.18.
//  Copyright © 2018 Jamit Labs. All rights reserved.
//

@testable import Portus
import XCTest

class PortusTests: XCTestCase {
    override static func setUp() {
        super.setUp()

        Map.shared.didEnter(RootViewController())
    }

    override func tearDown() {
        super.tearDown()

        Map.shared.currentPathWithoutRoot.forEach { Map.shared.didLeave($0) }
    }

    func testEnteringAndLeaving() {
        XCTAssertEqual(Map.shared.currentPathWithoutRoot.count, 0)

        let enteredRoute = linearlyEnterIssueDetails()
        XCTAssertEqual(Map.shared.currentPathWithoutRoot.count, enteredRoute.count)

        enteredRoute.forEach { Map.shared.didLeave($0) }
        XCTAssertEqual(Map.shared.currentPathWithoutRoot.count, 0)
    }

    func testLinearlyFirstLevelPortKeyRoutingAlwaysFromRoot() {
        let enteredRoute: [Routable] = linearlyEnterIssueDetails()

        let (routeToLeave, routeToEnter) = Router.pathToDestination(targetContext: EverydayObject.repositories, routingStrategy: .alwaysFromRoot)
        XCTAssertEqual(routeToLeave.map { $0 as! UIViewController }, enteredRoute.map { $0 as! UIViewController })
        XCTAssertEqual(routeToEnter, [RoutingIdentifiers.repositories])
    }

    func testLinearlyLastLevelPortKeyRoutingAlwaysFromRoot() {
        let enteredRoute: [Routable] = linearlyEnterIssueDetails()

        let (routeToLeave, routeToEnter) = Router.pathToDestination(targetContext: EverydayObject.newComment, routingStrategy: .alwaysFromRoot)
        XCTAssertEqual(routeToLeave.map { $0 as! UIViewController }, enteredRoute.map { $0 as! UIViewController })
        XCTAssertEqual(routeToEnter, enteredRoute.map { type(of: ($0)).routingId })
    }

    func testLinearlyFirstLevelPortKeyRoutingMaxReusageFromRoot() {
        let enteredRoute: [Routable] = linearlyEnterIssueDetails()

        let (routeToLeave, routeToEnter) = Router.pathToDestination(targetContext: EverydayObject.repositories, routingStrategy: .maxReusageFromRoot)
        XCTAssertEqual(routeToLeave.map { $0 as! UIViewController }, enteredRoute.dropFirst().map { $0 as! UIViewController })
        XCTAssertEqual(routeToEnter, [])
    }

    func testLinearlyLastLevelPortKeyRoutingMaxReusageFromRoot() {
        linearlyEnterIssueDetails()

        let (routeToLeave, routeToEnter) = Router.pathToDestination(targetContext: EverydayObject.newComment, routingStrategy: .maxReusageFromRoot)
        XCTAssertEqual(routeToLeave.map { $0 as! UIViewController }, [])
        XCTAssertEqual(routeToEnter, [])
    }

    func testLinearlyFirstLevelPortKeyRoutingMinRouteToLeaf() {
        let enteredRoute: [Routable] = linearlyEnterIssueDetails()

        let (routeToLeave, routeToEnter) = Router.pathToDestination(targetContext: EverydayObject.repositories, routingStrategy: .minRouteToLeaf)
        XCTAssertEqual(routeToLeave.map { $0 as! UIViewController }, enteredRoute.dropFirst().map { $0 as! UIViewController })
        XCTAssertEqual(routeToEnter, [])
    }

    func testLinearlyLastLevelPortKeyRoutingMinRouteToLeaf() {
        linearlyEnterIssueDetails()

        let (routeToLeave, routeToEnter) = Router.pathToDestination(targetContext: EverydayObject.newComment, routingStrategy: .minRouteToLeaf)
        XCTAssertEqual(routeToLeave.map { $0 as! UIViewController }, [])
        XCTAssertEqual(routeToEnter, [])
    }

    func testRoundaboutWayFirstLevelPortKeyRoutingAlwaysFromRoot() {
        let enteredRoute: [Routable] = roundaboutWayEnterIssueDetails()

        let (routeToLeave, routeToEnter) = Router.pathToDestination(targetContext: EverydayObject.repositories, routingStrategy: .alwaysFromRoot)
        XCTAssertEqual(routeToLeave.map { $0 as! UIViewController }, enteredRoute.map { $0 as! UIViewController })
        XCTAssertEqual(routeToEnter, [RoutingIdentifiers.repositories])
    }

    func testRoundaboutWayLastLevelPortKeyRoutingAlwaysFromRoot() {
        let enteredRoute: [Routable] = roundaboutWayEnterIssueDetails()

        let (routeToLeave, routeToEnter) = Router.pathToDestination(targetContext: EverydayObject.newComment, routingStrategy: .alwaysFromRoot)
        XCTAssertEqual(routeToLeave.map { $0 as! UIViewController }, enteredRoute.map { $0 as! UIViewController })
        XCTAssertEqual(routeToEnter, Array<RoutingIdentifier>(EverydayObject.newComment.dropFirst()))
    }

    func testRoundaboutWayFirstLevelPortKeyRoutingMaxReusageFromRoot() {
        let enteredRoute: [Routable] = roundaboutWayEnterIssueDetails()

        let (routeToLeave, routeToEnter) = Router.pathToDestination(targetContext: EverydayObject.repositories, routingStrategy: .maxReusageFromRoot)
        XCTAssertEqual(routeToLeave.map { $0 as! UIViewController }, enteredRoute.dropFirst().map { $0 as! UIViewController })
        XCTAssertEqual(routeToEnter, [])
    }

    func testRoundaboutWayLastLevelPortKeyRoutingMaxReusageFromRoot() {
        let enteredRoute: [Routable] = roundaboutWayEnterIssueDetails()

        let (routeToLeave, routeToEnter) = Router.pathToDestination(targetContext: EverydayObject.newComment, routingStrategy: .maxReusageFromRoot)
        XCTAssertEqual(routeToLeave.map { $0 as! UIViewController }, enteredRoute.dropFirst().map { $0 as! UIViewController })
        XCTAssertEqual(routeToEnter, [RoutingIdentifiers.repositoryDetail, RoutingIdentifiers.issues, RoutingIdentifiers.issuesDetail])
    }

    func testRoundaboutWayFirstLevelPortKeyRoutingMinRouteToLeaf() {
        let enteredRoute: [Routable] = roundaboutWayEnterIssueDetails()

        let (routeToLeave, routeToEnter) = Router.pathToDestination(targetContext: EverydayObject.repositories, routingStrategy: .minRouteToLeaf)
        XCTAssertEqual(routeToLeave.map { $0 as! UIViewController }, enteredRoute.dropFirst().map { $0 as! UIViewController })
        XCTAssertEqual(routeToEnter, [])
    }

    func testRoundaboutWayLastLevelPortKeyRoutingMinRouteToLeaf() {
        roundaboutWayEnterIssueDetails()

        let (routeToLeave, routeToEnter) = Router.pathToDestination(targetContext: EverydayObject.newComment, routingStrategy: .minRouteToLeaf)
        XCTAssertEqual(routeToLeave.map { $0 as! UIViewController }, [])
        XCTAssertEqual(routeToEnter, [])
    }

    func testRoundaboutWayMiddleLevelPortKeyRoutingAlwaysFromRoot() {
        let enteredRoute: [Routable] = roundaboutWayEnterIssueDetails()

        let (routeToLeave, routeToEnter) = Router.pathToDestination(targetContext: EverydayObject.repository, routingStrategy: .alwaysFromRoot)
        XCTAssertEqual(routeToLeave.map { $0 as! UIViewController }, enteredRoute.map { $0 as! UIViewController })
        XCTAssertEqual(routeToEnter, Array<RoutingIdentifier>(EverydayObject.repository.dropFirst()))
    }

    func testRoundaboutWayMiddleLevelPortKeyRoutingMaxReusageFromRoot() {
        let enteredRoute: [Routable] = roundaboutWayEnterIssueDetails()

        let (routeToLeave, routeToEnter) = Router.pathToDestination(targetContext: EverydayObject.repository, routingStrategy: .maxReusageFromRoot)
        XCTAssertEqual(routeToLeave.map { $0 as! UIViewController }, enteredRoute.dropFirst().map { $0 as! UIViewController })
        XCTAssertEqual(routeToEnter, [RoutingIdentifiers.repositoryDetail])
    }

    func testRoundaboutWayMiddleLevelPortKeyRoutingMinRouteToLeaf() {
        let enteredRoute: [Routable] = roundaboutWayEnterIssueDetails()

        let (routeToLeave, routeToEnter) = Router.pathToDestination(targetContext: EverydayObject.repository, routingStrategy: .minRouteToLeaf)
        XCTAssertEqual(routeToLeave.map { $0 as! UIViewController }, enteredRoute.dropFirst(3).map { $0 as! UIViewController })
        XCTAssertEqual(routeToEnter, [])
    }

    @discardableResult
    private func linearlyEnterIssueDetails() -> [Routable] {
        let pathToEnter: [Routable] = [RepositoriesViewController(), RepositoryDetailViewController(), IssuesViewController(), IssueDetailViewController()]
        pathToEnter.forEach { Map.shared.didEnter($0) }
        return pathToEnter
    }

    @discardableResult
    private func roundaboutWayEnterIssueDetails() -> [Routable] {
        let pathToEnter: [Routable] = [RepositoriesViewController(), IssuesViewController(), RepositoryDetailViewController(), IssueDetailViewController()]
        pathToEnter.forEach { Map.shared.didEnter($0) }
        return pathToEnter
    }
}

// MARK: - Test Types
enum EverydayObject {
    static let repositories: Context = [
        RoutingIdentifiers.root,
        RoutingIdentifiers.repositories
    ]
    static let repository: Context = [
        RoutingIdentifiers.root,
        RoutingIdentifiers.repositories,
        RoutingIdentifiers.repositoryDetail
    ]
    static let newComment: Context = [
        RoutingIdentifiers.root,
        RoutingIdentifiers.repositories,
        RoutingIdentifiers.repositoryDetail,
        RoutingIdentifiers.issues,
        RoutingIdentifiers.issuesDetail
    ]
}

extension RoutingIdentifiers {
    static let root: RoutingIdentifier = "Root"
    static let repositories: RoutingIdentifier = "Repositories"
    static let repositoryDetail: RoutingIdentifier = "RepositoryDetail"
    static let issues: RoutingIdentifier = "Issues"
    static let issuesDetail: RoutingIdentifier = "IssueDetail"
}

class RootViewController: UIViewController, Routable {
    static var routingId: RoutingIdentifier { return "Root" }

    func enter(routingIdentifier: RoutingIdentifier, info: Any?, animated: Bool, completion: @escaping (Routable) -> Void) {
        switch routingIdentifier {
        case RoutingIdentifiers.repositories:
            let repositoryViewCtrl = RepositoriesViewController()
            let navigationCtrl = UINavigationController(rootViewController: repositoryViewCtrl)
            present(navigationCtrl, animated: animated) {
                completion(repositoryViewCtrl)
            }

        default:
            return
        }
    }

    func leave(animated: Bool, completion: @escaping () -> Void) {
        fatalError("Root Node")
    }
}

class RepositoriesViewController: UIViewController, Routable {
    static var routingId: RoutingIdentifier { return "Repositories" }

    func enter(routingIdentifier: RoutingIdentifier, info: Any?, animated: Bool, completion: @escaping (Routable) -> Void) {
        switch routingIdentifier {
        case RoutingIdentifiers.repositoryDetail:
            let repositoryDetailViewCtrl = RepositoryDetailViewController()
            let delay: DispatchTimeInterval = animated ? .milliseconds(300) : .milliseconds(50)

            navigationController?.pushViewController(repositoryDetailViewCtrl, animated: animated)
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { completion(repositoryDetailViewCtrl) }

        default:
            return
        }
    }

    func leave(animated: Bool, completion: @escaping () -> Void) {
        dismiss(animated: animated, completion: completion)
    }
}

class RepositoryDetailViewController: UIViewController, Routable {
    static var routingId: RoutingIdentifier { return "RepositoryDetail" }

    func enter(routingIdentifier: RoutingIdentifier, info: Any?, animated: Bool, completion: @escaping (Routable) -> Void) {
        switch routingIdentifier {
        case RoutingIdentifiers.issues:
            let issuesViewCtrl = IssuesViewController()
            let navCtrl = UINavigationController(rootViewController: issuesViewCtrl)
            present(navCtrl, animated: animated) {
                completion(issuesViewCtrl)
            }

        default:
            return
        }
    }

    func leave(animated: Bool, completion: @escaping () -> Void) {
        guard let presentingViewCtrl = presentingViewController else { return completion() }
        navigationController?.popToViewController(presentingViewCtrl, animated: animated)

        let delay: DispatchTimeInterval = animated ? .milliseconds(300) : .milliseconds(50)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { completion() }
    }
}

class IssuesViewController: UIViewController, Routable {
    static var routingId: RoutingIdentifier { return "Issues" }

    func enter(routingIdentifier: RoutingIdentifier, info: Any?, animated: Bool, completion: @escaping (Routable) -> Void) {
        switch routingIdentifier {
        case RoutingIdentifiers.issuesDetail:
            let issueDetailViewCtrl = IssueDetailViewController()
            navigationController?.pushViewController(issueDetailViewCtrl, animated: animated)

            let delay: DispatchTimeInterval = animated ? .milliseconds(300) : .milliseconds(50)
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { completion(issueDetailViewCtrl) }

        default:
            return
        }
    }

    func leave(animated: Bool, completion: @escaping () -> Void) {
        dismiss(animated: animated, completion: completion)
    }
}

class IssueDetailViewController: UIViewController, Routable {
    static var routingId: RoutingIdentifier { return "IssueDetail" }

    func enter(routingIdentifier: RoutingIdentifier, info: Any?, animated: Bool, completion: @escaping (Routable) -> Void) {
        return
    }

    func leave(animated: Bool, completion: @escaping () -> Void) {
        guard let presentingViewCtrl = presentingViewController else { return completion() }
        navigationController?.popToViewController(presentingViewCtrl, animated: animated)

        let delay: DispatchTimeInterval = animated ? .milliseconds(300) : .milliseconds(50)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { completion() }
    }
}
