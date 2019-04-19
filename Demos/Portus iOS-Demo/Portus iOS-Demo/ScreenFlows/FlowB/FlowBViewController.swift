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
    @IBOutlet private var currentPathLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        animationExtentSegmentedControl.selectedSegmentIndex = Globals.animated ? 0 : 1
        currentPathLabel.text = RoutingTree.default.description
    }

    @IBAction private func animationExtentValueChanged() {
        Globals.animated = animationExtentSegmentedControl.selectedSegmentIndex == 0
    }

    @IBAction private func didTriggerButton(_ button: UIButton!) {
        let staticDestination: StaticRoutingDestination = {
            switch button.titleLabel?.text {
            case "A"?:
                return RoutingTable.StaticEntries.a

            case "B"?:
                return RoutingTable.StaticEntries.b

            case "C"?:
                return RoutingTable.StaticEntries.c

            case "AA"?:
                return RoutingTable.StaticEntries.aa

            case "AB"?:
                return RoutingTable.StaticEntries.ab

            case "AC"?:
                return RoutingTable.StaticEntries.ac

            case "BA"?:
                return RoutingTable.StaticEntries.ba

            case "BB"?:
                return RoutingTable.StaticEntries.bb

            case "BC"?:
                return RoutingTable.StaticEntries.bc

            case "CA"?:
                return RoutingTable.StaticEntries.ca

            case "CB"?:
                return RoutingTable.StaticEntries.cb

            case "CC"?:
                return RoutingTable.StaticEntries.cc

            case "AAA"?:
                return RoutingTable.StaticEntries.aaa

            case "AAB"?:
                return RoutingTable.StaticEntries.aab

            case "AAC"?:
                return RoutingTable.StaticEntries.aac

            case "ABA"?:
                return RoutingTable.StaticEntries.aba

            case "ABB"?:
                return RoutingTable.StaticEntries.abb

            case "ABC"?:
                return RoutingTable.StaticEntries.abc

            case "ACA"?:
                return RoutingTable.StaticEntries.aca

            case "ACB"?:
                return RoutingTable.StaticEntries.acb

            case "ACC"?:
                return RoutingTable.StaticEntries.acc

            case "BAA"?:
                return RoutingTable.StaticEntries.baa

            case "BAB"?:
                return RoutingTable.StaticEntries.bab

            case "BAC"?:
                return RoutingTable.StaticEntries.bac

            case "BBA"?:
                return RoutingTable.StaticEntries.bba

            case "BBB"?:
                return RoutingTable.StaticEntries.bbb

            case "BBC"?:
                return RoutingTable.StaticEntries.bbc

            case "BCA"?:
                return RoutingTable.StaticEntries.bca

            case "BCB"?:
                return RoutingTable.StaticEntries.bcb

            case "BCC"?:
                return RoutingTable.StaticEntries.bcc

            case "CAA"?:
                return RoutingTable.StaticEntries.caa

            case "CAB"?:
                return RoutingTable.StaticEntries.cab

            case "CAC"?:
                return RoutingTable.StaticEntries.cac

            case "CBA"?:
                return RoutingTable.StaticEntries.cba

            case "CBB"?:
                return RoutingTable.StaticEntries.cbb

            case "CBC"?:
                return RoutingTable.StaticEntries.cbc

            case "CCA"?:
                return RoutingTable.StaticEntries.cca

            case "CCB"?:
                return RoutingTable.StaticEntries.ccb

            case "CCC"?:
                return RoutingTable.StaticEntries.ccc

            default:
                return RoutingTable.StaticEntries.a
            }
        }()

        flowDelegate?.routeTo(staticDestination: staticDestination)
    }

    @IBAction func modalFlowA() {
        flowDelegate?.enter(dynamicDestination: RoutingTable.DynamicEntries.a)
    }

    @IBAction func modalFlowB() {
        flowDelegate?.enter(dynamicDestination: RoutingTable.DynamicEntries.b)
    }

    @IBAction func modalFlowC() {
        flowDelegate?.enter(dynamicDestination: RoutingTable.DynamicEntries.c)
    }

    @IBAction private func didTriggerColorButton(_ button: UIButton!) {
        flowDelegate?.routeTo(
            staticDestination: RoutingTable.StaticEntries.colorDetail(withHexString: button.titleLabel!.text!)
        )
    }
}
