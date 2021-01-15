//
//  KaobeiAPITests.swift
//  KaobeiAPITests
//
//  Created by horo on 10/12/20.
//  Copyright © 2020 Kantai Developer. All rights reserved.
//

import XCTest
import Alamofire
@testable import KaobeiAPI

class KaobeiAPITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testArticleList() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let request = KBGetArticleList.init(page: 1)
        
        let expect = expectation(description: "Waiting for response")
        
        KaobeiConnection.sendRequest(api: request) { (response) in
            //let str = String(data: response.data ?? Data.init(), encoding: .utf8)!
            //print(str)
            print("Status result: \(response.result)")
            switch response.result {
            case .success(let data):
                print("Type of data is: \(type(of: data))")
                XCTAssert(type(of: data) == KBArticleList.self)
                XCTAssertEqual(data.meta.pagination.currentPage, 1)
                break
            case .failure(let error):
                XCTFail(error.errorDescription ?? "")
                XCTFail("Faill to fetch data")
                break
            }
            
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 3) { error in
            if let _ = error {
                XCTFail("timeout")
            }
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
