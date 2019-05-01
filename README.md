<p align="center">
    <img src="https://raw.githubusercontent.com/JamitLabs/Portus/stable/Logo.png"
      width=600>
</p>

<p align="center">
    <a href="https://app.bitrise.io/app/7f97045d305e8481">
        <img src="https://app.bitrise.io/app/7f97045d305e8481/status.svg?token=jW4_Lgs5ezNb-OlbhaE11Q&branch=stable"
             alt="Build Status">
    </a>
    <a href="https://github.com/JamitLabs/Portus/releases">
        <img src="https://img.shields.io/badge/Version-0.1.0-blue.svg"
             alt="Version: 0.1.0">
    </a>
    <img src="https://img.shields.io/badge/Swift-4.2-FFAC45.svg"
         alt="Swift: 4.2">
    <img src="https://img.shields.io/badge/Platforms-iOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20watchOS-FF69B4.svg"
        alt="Platforms: iOS | macOS | tvOS | watchOS">
    <a href="https://github.com/JamitLabs/Portus/blob/stable/LICENSE.md">
        <img src="https://img.shields.io/badge/License-MIT-lightgrey.svg"
              alt="License: MIT">
    </a>
</p>

<p align="center">
    <a href="#installation">Installation</a>
  • <a href="#usage">Usage</a>
  • <a href="https://github.com/JamitLabs/Portus/issues">Issues</a>
  • <a href="#contributing">Contributing</a>
  • <a href="#license">License</a>
</p>

# Portus

Portus is an UIKit- and architecture independent routing framework that easily integrates with your iOS apps. Usage enables enhanced features like in-app navigation or deeplinks.

## Motivation

Managing screenflow within iOS apps is complex, especially when dealing with advanced requirements like in-app navigation or deeplinks. Even though trivial solutions establish connections among screens, dealing with hard-coded links suffers from insufficient context information and scalabilty issues. *Portus* mitigate these issues and offers a defined framework for handling screenflow in a standardized way.

Screens within iOS apps are arranged on a stack or presented in succession to provide different level of information. Combined with user interface components, like *sliding menus*, *navigation-* or *tab bars*, paths are established that form the app's navigation tree. Each node in the tree either corresponds to a screen within the application or a branch node that is respondible for managing individual nodes.

## Goals and Requirements

Development of this framework was driven by the following requirements:

### UIKit-Independent:

First, the framework is designed to be independent of UIKit. This ensures that Portus does neither need to know about your app's view hierarchy nor about the relationship among view controllers. Rather the framework relies on a tree-based structure that consists of routing nodes, where each node states its routing capabilities by conforming to the `Enterable`, `Leavable` or `Switchable` protocol. Note that being independent of UIKit is crucial to meet the second requirement to be architectural independent.

### Architectute-Independent:

Second, Portus does not enforce an architectural pattern. Due to limitations of the *MVC* architecture, the community has come up with several alternatives, like *FlowControllers*, *Coordinators*, *MVVM*, *MVVM+RxSwift*. To seamlessly integrate with these architectures, we designed Portus to be architectural independent.

### Context-Driven:

Finally, nodes are entered in different contexts. For instance, the background color of a screen can differ depending on the value that is provided to the node. Hence, even though the requested node might already be open it might be necessary to reenter the node when the color value differs. With the combination of  `RoutingIdentifier` and `RoutingContext` nodes are uniquely identified.

## Structure

Portus uses three protocols, namely  `Enterable`, `Leavable` and  `Switchable` that inherit from the `Routable` protocol.
Nodes can conform to these protocols and state their routing capabilities as well as whether they manage additional nodes.

### Protocols

#### `Routable`

Conforming to the `Routable` protocol is required to specify a node's structure. The protocol requires a `RoutingEntry` that consists of the `RoutingIdentifier` as well as the `RoutingContext` and whether additional nodes are managed by the node. The latter requires to also specify an `activeEntry` that represents the managed node that is currently active. Below you find the definition of the `Routable` protocol:

```swift
protocol Routable: AnyObject {
    var entry: RoutingEntry { get }
}
```

#### `Enterable`

In addition to `Routable`, nodes can state whether they can enter additional nodes using the `Enterable` protocol:

```swift
protocol Enterable: Routable {
    func enterNode(
        with entry: RoutingEntry, 
        animated: Bool, 
        completion: @escaping ((Bool) -> Void)
    )
}
```

Enterables will receive the entry identifying the node to enter as well as wheter the entrance should be animated or not. Finally the node can indicate whether the entrance succeeded or failed by calling the completion. Note that calling the completion is mandatory.

#### `Leavable`

 `Leavable` represents an additional routing capability. Routables conforming to this protocol can leave a node for a given entry. Similar to `Enterable` calling the completion is mandatory and notifies the routing framework whether the operation succeeded.
 In addition, leavables can be asked whether they can leave a node for a given entry:

```swift
protocol Leavable: Routable {
    func leaveNode(
        with entry: RoutingEntry, 
        animated: Bool, 
        completion: @escaping (Bool) -> Void
    )
    func canLeaveNode(with entry: RoutingEntry) -> Bool
}
```

#### `Switchable`

Finally, nodes conforming to the `Switchable` protocol can determine one of their manage nodes to become active. Hence, nodes conforming to `Switchable` have to manage additional nodes.

```swift
protocol Switchable: Routable {
    func switchToNode(
        with entry: RoutingEntry, 
        animated: Bool, 
        completion: @escaping ((Bool) -> Void)
    )
}
```

Using above-stated protocols, nodes can be entered, left or become (in)active in a standardised way. Still, routing requires knowledge about the current state and hence requires a tree-based structure to keep track of the current screenflow. 

### `RoutingTree`

The `RoutingTree` is used by the `RoutingAlgorithm` to compute `RoutingInstructions` to either static or dynamic destinations. Note that the tree consists of individual nodes, where each  `RoutingNode` may contain children. Still only one of a node's children can be active at the same time. This characteristic is crucial to compute an `activePath` that corresponds to the origin any routing request will start from.

The following operations can be performed on the `RoutingTree` and allow applications to provide information about when they enter, leave or switch to one of their managed nodes. This information is required by the `RoutingAlgorithm` to compute appropriate instructions to predefined destinations.

```swift
public func didEnterNode(withEntry entry: RoutingEntry)
public func didLeaveNode(with entry: RoutingEntry)
public func switchNode(
    withEntry entry: RoutingEntry, 
    didSwitchToNodeWithEntry targetEntry: RoutingEntry
)
```

### `Router`

The `Router` represents the main component of Portus and is used by applications to either request a route to a `StaticRoutingDestination`, i.e., a destination that is predefined in the `RoutingTable`, or to enter a `DynamicRoutingDestination`, i.e., a destination that does not depend on the current context and can be entered from everywhere. While *dynamic destinations* only consist of a single node, *static destinations* are represented by a list of nodes, where each list starts with the application's *root node*. Below you can find the signature of the operations as offered by the `Router`:

```swift
public func routeTo(
    staticDestination: StaticRoutingDestination,
    animated: Bool = true,
    executedInstructions: RoutingInstructions = [],
    completion: ((Result<RoutingInstructions, RoutingError>) -> Void)? = nil
) {
    ...
}
```

```swift
public func enter(
    dynamicDestination entry: RoutingEntry, 
    animated: Bool = true, 
    completion: ((Bool) -> Void)? = nil
) {
    ...
}
```
Note that both static- and dynamic destinations need to be predefined in the RoutingTable:

```swift
extension RoutingTable.StaticEntries {
    ...
}
```

```swift
extension RoutingTable.DynamicEntries {
    ...
}
```

## Installation

Installing via [Carthage](https://github.com/Carthage/Carthage#carthage) & [CocoaPods](https://guides.cocoapods.org/using/getting-started.html) are both supported.

## Contributing

See the file [CONTRIBUTING.md](https://github.com/JamitLabs/MungoHealer/blob/stable/CONTRIBUTING.md).


## License
This library is released under the [MIT License](http://opensource.org/licenses/MIT). See LICENSE for details.
