//
//  File.swift
//  LegacyHTTPClient
//
//  Created by Arun Kumar on 18/02/25.
//

import Foundation
import XCTest
@testable import LegacyHTTPClient

final class StarWarsAPIRequestOptionTests: XCTestCase {
    
    private var sut: StarWarsAPI!
    
    private var mockLoader: MockLoader!
    
    private var loader: HTTPLoader!
    
    override func setUp() {
        mockLoader = MockLoader()
        let applyEnvironmentLoader = ApplyEnvironmentLoader()
        loader = applyEnvironmentLoader --> mockLoader
        sut = StarWarsAPI(loader: loader)
    }
    
    override func tearDown() {
        mockLoader = nil
        loader = nil
        sut = nil
    }
    
    func testPeople_DevEnviroment_200_OK_WithValidBody_() {
        
        let endpoint = "people"
        
        let serverEnvironment = ServerEnvironment.development
        
        let mock = PeopleListResponse.getMock()

        mockLoader.add { request, handler in
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
                XCTAssertEqual(responseBody.count, mock?.count)
                XCTAssertEqual(responseBody.results.count, mock?.results.count)
            }
            else {
                XCTFail("Failed to obtain response.")
            }
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
    }
}
