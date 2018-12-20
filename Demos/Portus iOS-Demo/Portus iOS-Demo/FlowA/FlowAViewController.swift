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

        animationExtentSegmentedControl.selectedSegmentIndex = Globals.animationExtent.rawValue
        routingStrategySegmentedControl.selectedSegmentIndex = Globals.routingStrategy.rawValue
        currentPathLabel.text = MaraudersMap.shared.portKeyEnterablesPath
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        animationExtentSegmentedControl.selectedSegmentIndex = Globals.animationExtent.rawValue
        routingStrategySegmentedControl.selectedSegmentIndex = Globals.routingStrategy.rawValue
    }

    @IBAction private func animationExtentValueChanged() {
        Globals.animationExtent = Portus.AnimationExtent(rawValue: animationExtentSegmentedControl.selectedSegmentIndex)!
    }

    @IBAction private func routingStrategyValueChanged() {
        Globals.routingStrategy = Portus.RoutingStrategy(rawValue: routingStrategySegmentedControl.selectedSegmentIndex)!
    }

    @IBAction private func usePortKeyToFlowA() {
        Portus.use(portKey: Router.flowA, animationExtent: Globals.animationExtent, routingStrategy: Globals.routingStrategy)
    }

    @IBAction private func usePortKeyToFlowB() {
        Portus.use(portKey: Router.flowB, animationExtent: Globals.animationExtent, routingStrategy: Globals.routingStrategy)
    }

    @IBAction private func usePortKeyToFlowAB() {
        Portus.use(portKey: Router.flowAB, animationExtent: Globals.animationExtent, routingStrategy: Globals.routingStrategy)
    }

    @IBAction private func usePortKeyToFlowBA() {
        Portus.use(portKey: Router.flowBA, animationExtent: Globals.animationExtent, routingStrategy: Globals.routingStrategy)
    }

    @IBAction func modalFlowA() {
        FlowAFlowController().start(from: self)
    }

    @IBAction func modalFlowB() {
        FlowBFlowController().start(from: self)
    }
}
