//
//  ArmoryTests.swift
//  ArmoryTests
//
//  Created by Joe Conway on 8/29/17.
//  Copyright © 2017 stablekernel. All rights reserved.
//

import XCTest
import UIKit

@testable import Armory

enum Tap {
    case received
}

class ArmoryTests: XCTestCase, ArmoryTestable {
    var viewController: ViewController!

    private var taps: [Tap] = []

    override func setUp() {
        super.setUp()
        viewController = ViewController()
        build()
    }

    override func tearDown() {
        taps = []

        super.tearDown()
    }

    func testAppear() {
        after(self.viewController.finishedAppearing)
    }

    func testAnim() {
        viewController.g()

        after(self.viewController.v.layer.animation(forKey: "hello") == nil)
    }

    func testService() {
        viewController.f()
        after(self.viewController.finished == true)
    }

    func testTappingViewWithNumberOfTapsEqualToZero() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1

        viewController.view.addGestureRecognizer(tapGestureRecognizer)

        do {
            try tap(viewController.view, numberOfTimes: 0)
            XCTFail("Expected test to throw error")
        } catch let error as ArmoryError {
            XCTAssertEqual(ArmoryError.invalidValue, error)
            XCTAssertEqual([], taps)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }

    func testTappingViewWithNumberOfTapsLessThanZero() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1

        viewController.view.addGestureRecognizer(tapGestureRecognizer)

        do {
            try tap(viewController.view, numberOfTimes: -1)
            XCTFail("Expected test to throw error")
        } catch let error as ArmoryError {
            XCTAssertEqual(ArmoryError.invalidValue, error)
            XCTAssertEqual([], taps)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }

    func testTappingViewWithNumberOfTapsGreaterThanZero() {
        let numberOfTaps = 2

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
        tapGestureRecognizer.numberOfTapsRequired = numberOfTaps

        viewController.view.addGestureRecognizer(tapGestureRecognizer)

        try! tap(viewController.view, numberOfTimes: numberOfTaps)

        XCTAssertEqual([Tap.received], taps)
    }

}

extension ArmoryTests {

    @objc func tapGesture(_ sender: UITapGestureRecognizer) {
        taps.append(.received)
    }
}


class ViewController: UIViewController {
    var v: UIView!
    let session = URLSession(configuration: URLSessionConfiguration.default)
    var task: URLSessionDataTask?
    var finished = false
    var finishedAppearing = false

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        finishedAppearing = true
    }

    override func loadView() {
        view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        v = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        view.addSubview(v)
    }

    func g() {
        let anim = CABasicAnimation(keyPath: "position")
        anim.fromValue = NSValue(cgPoint: CGPoint(x: 0, y: 0))
        anim.toValue = NSValue(cgPoint: CGPoint(x: 500, y: 0))
        anim.duration = 1.0
        anim.isRemovedOnCompletion = true
        v.layer.add(anim, forKey: "hello")
    }

    func f() {
        let url = URL(string: "https://google.com")!
        task = session.dataTask(with: url) { (data, _, _) in
            OperationQueue.main.addOperation {
                self.finished = true
            }

        }
        task!.resume()
    }
}
