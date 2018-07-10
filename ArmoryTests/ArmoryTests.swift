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

class ArmoryTests: XCTestCase, VCTestSetup {
    var viewController: ViewController!
    
    override func setUp() {
        super.setUp()        
        viewController = ViewController()
        build()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
