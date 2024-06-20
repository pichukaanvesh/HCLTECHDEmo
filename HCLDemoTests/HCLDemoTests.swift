//
//  HitsViewModelTests.swift
//  HCLDemoTests
//
//  Created by Pichuka, Anvesh (623-Extern) on 19/06/24.
//


import XCTest
@testable import HCLDemo

class HitsViewModelTests: XCTestCase {
    
    var viewModel: HitsViewModel!
    var session: URLSession!

    override func setUpWithError() throws {
        session = URLSession.test
        viewModel = HitsViewModel(session: session)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        session = nil
    }

    
    func testFetchHitsFailure() throws {
        // Arrange
        let expectation = XCTestExpectation(description: "Fetching hits fails")
        
        URLProtocolMock.testURLs = [URL(string: "https://www.jsonkeeper.com/b/6JS0"): Data()]
        
        // Act
        viewModel.onError = { error in
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        viewModel.fetchHits()
        
        // Assert
        wait(for: [expectation], timeout: 5.0)
    }
}

class URLProtocolMock: URLProtocol {
    static var testURLs = [URL?: Data]()

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let url = request.url, let data = URLProtocolMock.testURLs[url] {
            client?.urlProtocol(self, didReceive: HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
        } else {
            let error = NSError(domain: "No data found for URL", code: 404, userInfo: nil)
            client?.urlProtocol(self, didFailWithError: error)
        }
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}

extension URLSession {
    static let test: URLSession = {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        return URLSession(configuration: config)
    }()
}
