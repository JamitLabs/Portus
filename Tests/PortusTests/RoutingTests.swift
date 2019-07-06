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
        static let staticDestination4: StaticRoutingDestination = [.switchNode1, .node1, .node6, .node11].entries
        static let staticDestination5: StaticRoutingDestination = [.switchNode1, .node2, .switchNode3, .node13].entries
    }
}

class RoutingTests: XCTestCase {
    private let expectedRoutingInstructions1: RoutingInstructions = [
        .switchTo(entry: RoutingEntry(identifier: .node2), switchNodeEntry: RoutingEntry(identifier: .switchNode1)),
        .enter(entry: RoutingEntry(identifier: .switchNode3)),
        .switchTo(entry: RoutingEntry(identifier: .node12), switchNodeEntry: RoutingEntry(identifier: .switchNode3))
    ]

    private let expectedRoutingInstructions2: RoutingInstructions = [
        .leave(entry: RoutingEntry(identifier: .switchNode3)),
        .switchTo(entry: RoutingEntry(identifier: .node1), switchNodeEntry: RoutingEntry(identifier: .switchNode1)),
        .enter(entry: RoutingEntry(identifier: .node5)),
        .enter(entry: RoutingEntry(identifier: .node8))
    ]

    private let expectedRoutingInstructions3: RoutingInstructions = [
        .leave(entry: RoutingEntry(identifier: .node8)),
        .leave(entry: RoutingEntry(identifier: .node5)),
        .switchTo(entry: RoutingEntry(identifier: .switchNode2), switchNodeEntry: RoutingEntry(identifier: .switchNode1)),
        .switchTo(entry: RoutingEntry(identifier: .node4), switchNodeEntry: RoutingEntry(identifier: .switchNode2))
    ]

    private let expectedRoutingInstructions4: RoutingInstructions = [
        .switchTo(entry: RoutingEntry(identifier: .node1), switchNodeEntry: RoutingEntry(identifier: .switchNode1)),
        .enter(entry: RoutingEntry(identifier: .node6)),
        .enter(entry: RoutingEntry(identifier: .node11))
    ]

    private let expectedRoutingInstructions5: RoutingInstructions = [
        .leave(entry: RoutingEntry(identifier: .node11)),
        .leave(entry: RoutingEntry(identifier: .node6)),
        .switchTo(entry: RoutingEntry(identifier: .node2), switchNodeEntry: RoutingEntry(identifier: .switchNode1)),
        .enter(entry: RoutingEntry(identifier: .switchNode3))
    ]

    override static func setUp() {
        super.setUp()

        RoutingTree.default.root = nil
    }

    override static func tearDown() {
        super.tearDown()

        RoutingTree.default.root = nil
    }

    func testRouteToStaticDestinations() {
        let root = SwitchNode1()
        root.startIfNeeded()

        let exp = expectation(description: "Expect routing to succeed.")

        routeTo(
            staticDestination: RoutingTable.StaticEntries.staticDestination1,
            expectedRoutingInstructions: expectedRoutingInstructions1
        ) { [unowned self] success in
            XCTAssert(success)
            self.routeTo(
                staticDestination: RoutingTable.StaticEntries.staticDestination2,
                expectedRoutingInstructions: self.expectedRoutingInstructions2
            ) { [unowned self] success in
                XCTAssert(success)
                self.routeTo(
                    staticDestination: RoutingTable.StaticEntries.staticDestination3,
                    expectedRoutingInstructions: self.expectedRoutingInstructions3
                ) { success in
                    XCTAssert(success)
                    self.routeTo(
                        staticDestination: RoutingTable.StaticEntries.staticDestination4,
                        expectedRoutingInstructions: self.expectedRoutingInstructions4
                    ) { success in
                        XCTAssert(success)
                        self.routeTo(
                            staticDestination: RoutingTable.StaticEntries.staticDestination5,
                            expectedRoutingInstructions: self.expectedRoutingInstructions5
                        ) { success in
                            XCTAssert(success)
                            exp.fulfill()
                        }
                    }
                }
            }
        }

        waitForExpectations(timeout: 1, handler: nil)
    }
}

// MARK: - Helper
extension RoutingTests {
    private func routeTo(
        staticDestination: StaticRoutingDestination,
        expectedRoutingInstructions: RoutingInstructions,
        completion: @escaping (Bool) -> Void
    ) {
        Router.default.routeTo(
            staticDestination: staticDestination,
            animated: false
        ) { result in
            switch result {
            case let .success(executedInstructions):
                XCTAssertEqual(executedInstructions, expectedRoutingInstructions)
                completion(true)

            case .failure:
                completion(false)
            }
        }
    }
}
