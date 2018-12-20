//
//  Created by Cihat Gündüz on 20.12.18.
//  Copyright © 2018 Jamit Labs. All rights reserved.
//

import UIKit

extension UIViewController: PortKeyLeavable {
    func leave(animated: Bool, completion: @escaping () -> Void) {
        if let navigationStackIndex = navigationController?.viewControllers.firstIndex(of: self), navigationStackIndex > 0 {
            let previousViewCtrl = navigationController!.viewControllers[navigationStackIndex - 1]
            navigationController?.popToViewController(previousViewCtrl, animated: animated)

            let delay: DispatchTimeInterval = animated ? .milliseconds(300) : .milliseconds(50)
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { completion() }
        } else {
            dismiss(animated: animated, completion: completion)
        }
    }
}
