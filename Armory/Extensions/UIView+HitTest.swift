//
//  UIView+HitTest.swift
//  Armory
//
//  Created by Brian Palma on 6/11/18.
//  Copyright © 2018 stablekernel. All rights reserved.
//

import UIKit

public extension UIView {

    var isSkippedDuringHitTest: Bool {
        // From hitTest(_:with:) docs:
        // This method ignores view objects that are hidden, that have disabled user interactions, or have an alpha level less than 0.01.
        return !isHidden && isUserInteractionEnabled && alpha > 0.01 ? false : true
    }
}

