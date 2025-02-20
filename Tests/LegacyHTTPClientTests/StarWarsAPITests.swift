//
//  File.swift
//  LegacyHTTPClient
//
//  Created by Arun on 16/02/25.
//

import Foundation
import XCTest
@testable import LegacyHTTPClient

final class StarWarsAPITests: XCTestCase {
    
    private var sut: StarWarsAPI!
    
    private var mockLoader: MockLoader!
    
    override func setUp() {
        mockLoader = MockLoader()
        let loader = ModifyRequestLoader { request in
            var copy = request
            
            if copy.host.isEmpty {
                copy.host = "swapi.dev"
            }
            
            if copy.path.starts(with: "/api/") == false {
                copy.path = "/api/" + copy.path
            }
            
            return copy
        } --> mockLoader
        sut = StarWarsAPI(loader: loader)
    }
    
    override func tearDown() {
        mockLoader = nil
        sut = nil
    }
    
    func test_200_OK_WithValidBody() {
        var httpRequest = HTTPRequest()
        httpRequest.host = "swapi.dev"
        httpRequest.path = "/api/people"
        
        let mock = PeopleListResponse.getMock()

        mockLoader.then { request, handler in
            XCTAssertEqual(request.host, httpRequest.host)
            XCTAssertEqual(request.path, httpRequest.path)
            
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: "1.1",
                headerFields: nil
            )
            var data: Data? = nil
            if let mock {
                data = try? JSONEncoder().encode(mock)
            }
            let result = HTTPResult(request: request, urlResponse: response, body: data, error: nil)
            handler(result)
        }
        
        let expectation = expectation(description: "Falied to test PeopleListResponse.")
        
        sut.requestPeople { result, _  in
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
    
    func test_200_OK_WithInvalidBody() {
        var httpRequest = HTTPRequest()
        httpRequest.host = "swapi.dev"
        httpRequest.path = "/api/people"

        mockLoader.then { request, handler in
            XCTAssertEqual(request.host, httpRequest.host)
            XCTAssertEqual(request.path, httpRequest.path)
            
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: "1.1",
                headerFields: nil
            )
            let responseBody = "".data(using: .utf8)
            let result = HTTPResult(request: request, urlResponse: response, body: responseBody, error: nil)
            handler(result)
        }
        
        let expectation = expectation(description: "Falied to test PeopleListResponse.")
        
        sut.requestPeople { _ , error in
            if let error {
                XCTAssertNotNil(error)
                XCTAssertEqual(error.code, .invalidResponse)
            }
            else {
                XCTFail("It should return nil as response body.")
            }
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func test_404() {
        var httpRequest = HTTPRequest()
        httpRequest.host = "swapi.dev"
        httpRequest.path = "/api/people"

        mockLoader.then { request, handler in
            XCTAssertEqual(request.host, httpRequest.host)
            XCTAssertEqual(request.path, httpRequest.path)
            
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 404,
                httpVersion: "1.1",
                headerFields: nil
            )
            let responseBody = "404 NOT FOUND".data(using: .utf8)
            let result = HTTPResult(request: request, urlResponse: response, body: responseBody, error: nil)
            handler(result)
        }
        
        let expectation = expectation(description: "Falied to test PeopleListResponse.")
        
        sut.requestPeople { responseBody, error  in
            XCTAssertNotNil(error, "Error should not be nil")
            
            if let error {
                XCTAssertEqual(error.code, .invalidResponse)
            }

            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
    }
}
