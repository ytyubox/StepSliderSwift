//
//  Copyright © 2020 Essential Developer. All rights reserved.
//

import UIKit

extension UIView {
    func snapshot(for configuration: SnapshotConfiguration) -> UIImage {
        let root = UIViewController()
        root.view = self
        return SnapshotWindow(configuration: configuration, root: root).snapshot()
    }
}
