//
//  FlowAViewController.swift
//  Portus iOS-Demo
//
//  Created by Andreas Link on 04.11.18.
//  Copyright © 2018 Jamit Labs. All rights reserved.
//

import UIKit
import Portus

class FlowAViewController: UIViewController {
    @IBOutlet private var animationExtentSegmentedControl: UISegmentedControl!
    @IBOutlet private var routingStrategySegmentedControl: UISegmentedControl!
    @IBOutlet private var currentPathLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        routingStrategySegmentedControl.selectedSegmentIndex = Globals.routingStrategy.rawValue
        currentPathLabel.text = Map.shared.currentPathDescription
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        routingStrategySegmentedControl.selectedSegmentIndex = Globals.routingStrategy.rawValue
    }

    @IBAction private func routingStrategyValueChanged() {
        Globals.routingStrategy = Router.RoutingStrategy(rawValue: routingStrategySegmentedControl.selectedSegmentIndex)!
    }

    @IBAction private func usePortKeyToFlowA() {
        Router.changeContext(RoutingTable.A, routingStrategy: Globals.routingStrategy)
    }

    @IBAction private func usePortKeyToFlowB() {
        Router.changeContext(RoutingTable.B, routingStrategy: Globals.routingStrategy)
    }

    @IBAction private func usePortKeyToFlowAB() {
        Router.changeContext(RoutingTable.AB, routingStrategy: Globals.routingStrategy)
    }

    @IBAction private func usePortKeyToFlowBA() {
        Router.changeContext(RoutingTable.BA, routingStrategy: Globals.routingStrategy)
    }

    @IBAction func modalFlowA() {
        FlowAFlowController().start(from: self)
    }

    @IBAction func modalFlowB() {
        FlowBFlowController().start(from: self)
    }
}
