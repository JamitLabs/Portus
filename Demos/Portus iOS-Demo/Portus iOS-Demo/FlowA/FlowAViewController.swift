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

        currentPathLabel.text = MaraudersMap.shared.portKeyEnterablesPath
    }

    private var animationExtent: Portus.AnimationExtent {
        return Portus.AnimationExtent.allCases[animationExtentSegmentedControl.selectedSegmentIndex]
    }

    private var routingStrategy: Portus.RoutingStrategy {
        return Portus.RoutingStrategy.allCases[routingStrategySegmentedControl.selectedSegmentIndex]
    }

    @IBAction private func usePortKeyToFlowA() {
        Portus.use(portKey: Router.flowA, animationExtent: animationExtent, routingStrategy: routingStrategy)
    }

    @IBAction private func usePortKeyToFlowB() {
        Portus.use(portKey: Router.flowB, animationExtent: animationExtent, routingStrategy: routingStrategy)
    }

    @IBAction private func usePortKeyToFlowAB() {
        Portus.use(portKey: Router.flowAB, animationExtent: animationExtent, routingStrategy: routingStrategy)
    }

    @IBAction private func usePortKeyToFlowBA() {
        Portus.use(portKey: Router.flowBA, animationExtent: animationExtent, routingStrategy: routingStrategy)
    }

    @IBAction func modalFlowA() {
        FlowAFlowController().start(from: self)
    }

    @IBAction func modalFlowB() {
        FlowBFlowController().start(from: self)
    }
}
