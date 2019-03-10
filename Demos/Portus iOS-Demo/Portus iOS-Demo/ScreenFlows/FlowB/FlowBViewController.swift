//
//  FlowBViewController.swift
//  Portus iOS-Demo
//
//  Created by Andreas Link on 04.11.18.
//  Copyright © 2018 Jamit Labs. All rights reserved.
//

import UIKit
import Portus

class FlowBViewController: UIViewController {
    weak var flowDelegate: FlowBFlowDelegate?

    @IBOutlet private var animationExtentSegmentedControl: UISegmentedControl!
    @IBOutlet private var routingStrategySegmentedControl: UISegmentedControl!
    @IBOutlet private var currentPathLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        animationExtentSegmentedControl.selectedSegmentIndex = Globals.animated ? 0 : 1
        routingStrategySegmentedControl.selectedSegmentIndex = Globals.routingStrategy.rawValue
        currentPathLabel.text = RoutingTree.shared.description
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        routingStrategySegmentedControl.selectedSegmentIndex = Globals.routingStrategy.rawValue
    }

    @IBAction private func animationExtentValueChanged() {
        Globals.animated = animationExtentSegmentedControl.selectedSegmentIndex == 0
    }

    @IBAction private func routingStrategyValueChanged() {
        Globals.routingStrategy = RoutingStrategy(rawValue: routingStrategySegmentedControl.selectedSegmentIndex)!
    }

    @IBAction private func didTriggerButton(_ button: UIButton!) {
        let destination: Path = {
            switch button.titleLabel?.text {
            case "A"?:
                return RoutingTable.Static.a

            case "B"?:
                return RoutingTable.Static.a

            case "C"?:
                return RoutingTable.Static.a

            case "AA"?:
                return RoutingTable.Static.a

            case "AB"?:
                return RoutingTable.Static.a

            case "AC"?:
                return RoutingTable.Static.a

            case "BA"?:
                return RoutingTable.Static.a

            case "BB"?:
                return RoutingTable.Static.a

            case "BC"?:
                return RoutingTable.Static.a

            case "CA"?:
                return RoutingTable.Static.a

            case "CB"?:
                return RoutingTable.Static.a

            case "CC"?:
                return RoutingTable.Static.a

            case "AAA"?:
                return RoutingTable.Static.aaa

            case "AAB"?:
                return RoutingTable.Static.aab

            case "AAC"?:
                return RoutingTable.Static.aac

            case "ABA"?:
                return RoutingTable.Static.aba

            case "ABB"?:
                return RoutingTable.Static.abb

            case "ABC"?:
                return RoutingTable.Static.abc

            case "ACA"?:
                return RoutingTable.Static.aca

            case "ACB"?:
                return RoutingTable.Static.acb

            case "ACC"?:
                return RoutingTable.Static.acc

            case "BAA"?:
                return RoutingTable.Static.baa

            case "BAB"?:
                return RoutingTable.Static.bab

            case "BAC"?:
                return RoutingTable.Static.bac

            case "BBA"?:
                return RoutingTable.Static.bba

            case "BBB"?:
                return RoutingTable.Static.bbb

            case "BBC"?:
                return RoutingTable.Static.bbc

            case "BCA"?:
                return RoutingTable.Static.bca

            case "BCB"?:
                return RoutingTable.Static.bcb

            case "BCC"?:
                return RoutingTable.Static.bcc

            case "CAA"?:
                return RoutingTable.Static.caa

            case "CAB"?:
                return RoutingTable.Static.cab

            case "CAC"?:
                return RoutingTable.Static.cac

            case "CBA"?:
                return RoutingTable.Static.cba

            case "CBB"?:
                return RoutingTable.Static.cbb

            case "CBC"?:
                return RoutingTable.Static.cbc

            case "CCA"?:
                return RoutingTable.Static.cca

            case "CCB"?:
                return RoutingTable.Static.ccb

            case "CCC"?:
                return RoutingTable.Static.ccc

            default:
                return RoutingTable.Static.a
            }
        }()

        flowDelegate?.routeTo(destination: destination)
    }

    @IBAction func modalFlowA() {
        flowDelegate?.enterA()
    }

    @IBAction func modalFlowB() {
        flowDelegate?.enterB()
    }

    @IBAction func modalFlowC() {
        flowDelegate?.enterC()
    }

    @IBAction private func didTriggerColorButton(_ button: UIButton!) {
        flowDelegate?.routeTo(
            destination: RoutingTable.Static.colorDetail(withHexString: button.titleLabel!.text!)
        )
    }
}
