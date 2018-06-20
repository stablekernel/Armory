//
//  UIImage+TestImages.swift
//  ArmoryTests
//
//  Created by Brian Palma on 6/20/18.
//  Copyright © 2018 stablekernel. All rights reserved.
//

import UIKit

extension UIImage {

    static func lock() -> UIImage {
        return UIImage(named: "lock", in: Bundle(for: ArmoryTests.self), compatibleWith: nil)!
    }

    static func close() -> UIImage {
        return UIImage(named: "close", in: Bundle(for: ArmoryTests.self), compatibleWith: nil)!
    }

}
