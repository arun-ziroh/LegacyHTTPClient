//
//  ResetStarWarsAPITests.swift
//  LegacyHTTPClient
//
//  Created by Arun Kumar on 19/02/25.
//

import Foundation
import XCTest
@testable import LegacyHTTPClient

final class ResetStarWarsAPITests: XCTestCase, @unchecked Sendable {
    
    private var sut: StarWarsAPI!
    
    private var mockLoader: MockLoader!
    
    private var loader: HTTPLoader!
    
    override func setUp() {
        mockLoader = MockLoader()
        loader = ResetGuardLoader() --> CustomPrintLoader() --> ApplyEnvironmentLoader() --> mockLoader
        sut = StarWarsAPI(loader: loader)
    }
    
    override func tearDown() {
        mockLoader = nil
        loader = nil
        sut = nil
    }
    
    func testResetLoader() {
        
        let endpoint = "people"
        
        let serverEnvironment = ServerEnvironment.development
        
        let mock = PeopleListResponse.getMock()

        mockLoader.then { request, handler in
            XCTAssertEqual(request.host, serverEnvironment.host)
            XCTAssertEqual(request.path, serverEnvironment.pathPrefix + "/" + endpoint)
            
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: "1.1",
                headerFields: nil
            )
            var data: Data? = nil
            if request.path.components(separatedBy: "/").last == endpoint,
            let mock {
                data = try? JSONEncoder().encode(mock)
            }
            let result = HTTPResult(request: request, urlResponse: response, body: data, error: nil)
            handler(result)
        }

        let expectation = expectation(description: "Falied to obtain PeopleListResponse.")
        
        sut.requestPeople(with: serverEnvironment) { result, _  in
            if let responseBody = result {
                
                if responseBody.count == mock?.count {
                    self.loader.reset {
                        print("Reset Success !!")
                        expectation.fulfill()
                    }
                }
            }
            else {
                XCTFail("Failed to obtain response.")
            }
        }
        wait(for: [expectation], timeout: 2)
    }
}
