//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by 정재근 on 2022/10/25.
//

import XCTest
@testable import OpenMarket

final class OpenMarketTests: XCTestCase {
    
    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
    }
    
    func test_ParsingProductListPage() {
        let fileName = "Mock"
        let decoder = JSONDecoder()
        guard let AssetData: NSDataAsset = NSDataAsset(name: fileName) else { return }
        do {
            let page = try decoder.decode(ProductListPage.self, from: AssetData.data)
            XCTAssertEqual(page.pageNo, 1)
        } catch {
            XCTAssertNil(error)
        }
    }
    
    func test_Network() {
        let networkManager = NetworkManager()
        networkManager.getData(requestType: Request.productList(pageNo: 1, itemsPerPage: 100)) { result in
            switch result {
            case .success(let jsonData):
                guard let productListPage = try? JSONDecoder().decode(ProductListPage.self, from: jsonData) else {
                    XCTFail("Fail Decode")
                    return
                }
                XCTAssertNil(productListPage)
                XCTAssertEqual(productListPage.pageNo, 1)
            case .failure(_):
                XCTFail("File Import Data")
            }
        }
    }
}
