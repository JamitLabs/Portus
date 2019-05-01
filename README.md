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

Portus is based on three protocols, namely  `Enterable`, `Leavable` and  `Switchable` that inherit from the `Routable` protocol.
Individual objects of an application can conform to these protocols to state their routing capabilities and to define how individual nodes are entered, left or switched to:


Nodes within Portus are uniquely identified by a `RoutingEntry` that consists of a `RoutingId` combined with a `RoutingContext`. The context is necessary, sinceFor instance, it matters whether a detail screen that is capable of  to a detail page 

```
protocol Routable: AnyObject {
    var entry: RoutingEntry { get }
}

protocol Enterable: Routable {
    func enterNode(with entry: RoutingEntry, animated: Bool, completion: @escaping ((Bool) -> Void))
}

protocol Leavable: Routable {
    func leaveNode(with entry: RoutingEntry, animated: Bool, completion: @escaping (Bool) -> Void)
    func canLeaveNode(with entry: RoutingEntry) -> Bool
}

protocol Switchable: Routable {
    func switchToNode(with entry: RoutingEntry, animated: Bool, completion: @escaping ((Bool) -> Void))
}
```

## Usage

---
#### Features Overview

- [Short Section](#short-section)
- Sections Group
- [SubSection1](#subsection1)
- [SubSection2](#subsection2)

---

## Installation

// TODO

### Short Section

TODO: Add some usage information here.

### Sections Group

TODO: Summarize the section here.

#### SubSection1

TODO: Add some usage information here.

#### SubSection2

TODO: Add some usage information here.


## Contributing

See the file [CONTRIBUTING.md](https://github.com/JamitLabs/MungoHealer/blob/stable/CONTRIBUTING.md).


## License
This library is released under the [MIT License](http://opensource.org/licenses/MIT). See LICENSE for details.
