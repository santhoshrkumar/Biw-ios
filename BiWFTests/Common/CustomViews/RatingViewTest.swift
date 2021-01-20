//
//  RatingViewTest.swift
//  BiWFTests
//
//  Created by Amruta Mali on 22/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
@testable import BiWF

class RatingViewTest: XCTestCase {
    var view: Rating?
    

    func testInit() {
        let bundle = Bundle(for: Rating.self)
        guard let ratingView = bundle.loadNibNamed("Rating", owner: nil)?.first as? UIView else {
            return XCTFail("CustomView nib did not contain a UIView")
        }
        view = ratingView as? Rating
    }
    
    override func tearDown() {
        super.tearDown()
        view = nil
    }

}
