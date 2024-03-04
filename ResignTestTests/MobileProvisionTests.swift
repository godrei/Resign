//
//  MobileProvisionTests.swift
//  ResignTestTests
//
//  Created by Krisztián Gödrei on 01/03/2024.
//

import XCTest
@testable import ResignTest

final class MobileProvisionTests: XCTestCase {
    func testDistributionType() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        let profile = MobileProvision.read()
        if profile != nil {
            let distrType = profile!.distributionType()
            XCTAssertEqual(distrType, "development")
        } else {
            XCTAssertNotNil(profile)
        }
    }
    
    func testName() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        let profile = MobileProvision.read()
        if profile != nil {
            let name = profile!.name
            XCTAssertEqual(name, "test profile")
        } else {
            XCTAssertNotNil(profile)
        }
    }
    
    func testAppID() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        let profile = MobileProvision.read()
        if profile != nil {
            let appID = profile!.appID()
            XCTAssertEqual(appID, "test id")
        } else {
            XCTAssertNotNil(profile)
        }
    }

}
