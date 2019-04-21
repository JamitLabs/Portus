//
//  Created by Cihat Gündüz on 19.11.18.
//  Copyright © 2018 Jamit Labs. All rights reserved.
//

@testable import Portus
import XCTest

enum RoutingTable {
    enum StaticEntries {
        static let staticDestination1: StaticRoutingDestination = [.switchNode1, .node2, .switchNode3, .node12].entries
        static let staticDestination2: StaticRoutingDestination = [.switchNode1, .node1, .node5, .node8].entries
        static let staticDestination3: StaticRoutingDestination = [.switchNode1, .switchNode2, .node4].entries
    }
}

class PortusTests: XCTestCase {
    override static func setUp() {
        super.setUp()

        RoutingTree.default.root = nil
    }

    override static func tearDown() {
        super.tearDown()

        RoutingTree.default.root = nil
    }

    // swiftlint:disable:next function_body_length
    func testRouteToStaticDestinations() {
        RoutingTree.default.root = nil

        let root = SwitchNode1()
        root.startIfNeeded()
        let exp1 = expectation(description: "Routed successfully to destination 1")
        let exp2 = expectation(description: "Routed successfully to destination 2")
        let exp3 = expectation(description: "Routed successfully to destination 3")

        let expectedRoutingInstructions1: RoutingInstructions = [
            .switchTo(
                entry: RoutingEntry(identifier: .node2),
                switchNodeEntry: RoutingEntry(identifier: .switchNode1)
            ),
            .enter(entry: RoutingEntry(identifier: .switchNode3)),
            .switchTo(
                entry: RoutingEntry(identifier: .node12),
                switchNodeEntry: RoutingEntry(identifier: .switchNode3)
            )
        ]

        let expectedRoutingInstructions2: RoutingInstructions = [
            .leave(entry: RoutingEntry(identifier: .switchNode3)),
            .switchTo(
                entry: RoutingEntry(identifier: .node1),
                switchNodeEntry: RoutingEntry(identifier: .switchNode1)
            ),
            .enter(entry: RoutingEntry(identifier: .node5)),
            .enter(entry: RoutingEntry(identifier: .node8))
        ]

        let expectedRoutingInstructions3: RoutingInstructions = [
            .leave(entry: RoutingEntry(identifier: .node8)),
            .leave(entry: RoutingEntry(identifier: .node5)),
            .switchTo(
                entry: RoutingEntry(identifier: .switchNode2),
                switchNodeEntry: RoutingEntry(identifier: .switchNode1)
            ),
            .switchTo(
                entry: RoutingEntry(identifier: .node4),
                switchNodeEntry: RoutingEntry(identifier: .switchNode2)
            )
        ]

        Router.default.routeTo(
            staticDestination: RoutingTable.StaticEntries.staticDestination1,
            animated: false
        ) { result in
            switch result {
            case let .success(executedInstructions):
                XCTAssertEqual(executedInstructions, expectedRoutingInstructions1)
                exp1.fulfill()

                Router.default.routeTo(
                    staticDestination: RoutingTable.StaticEntries.staticDestination2,
                    animated: false
                ) { result in
                    switch result {
                    case let .success(executedInstructions):
                        XCTAssertEqual(executedInstructions, expectedRoutingInstructions2)
                        exp2.fulfill()

                        Router.default.routeTo(
                            staticDestination: RoutingTable.StaticEntries.staticDestination3,
                            animated: false
                        ) { result in
                            switch result {
                            case let .success(executedInstructions):
                                XCTAssertEqual(executedInstructions, expectedRoutingInstructions3)
                                exp3.fulfill()

                            case .failure:
                                XCTFail("Routing should have succeeded.")
                            }
                        }

                    case .failure:
                        XCTFail("Routing should have succeeded.")
                    }
                }

            case .failure:
                XCTFail("Routing should have succeeded.")
            }
        }

        waitForExpectations(timeout: 1, handler: nil)
    }
}
