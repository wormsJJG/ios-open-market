//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    let url = URL(string: Request.getProductList(pageNo: 1, itemsPerPage: 100).url)!
    let url2 = URL(string: Request.getProduntInfo(productId: 60).url)!
    let networkManager = NetworkManager()
    let decoder = JSONDecoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.getData(requestType: Request.getProductList(pageNo: 1, itemsPerPage: 100)) { result in
            let data = try! result.get()
            let page = try! self.decoder.decode(ProductListPage.self, from: data)
            print(page)
        }
//        let task = session.dataTask(with: url) { (data, response, error) in
//            if let jsonData = data {
//                do {
//                    let page = try self.decoder.decode(ProductListPage.self, from: jsonData)
//                    print(page.pageNo)
//                } catch {
//                    print(error.localizedDescription)
//                }
//            } else{
//                print("실패")
//            }
//        }
//        task.resume()
//        let task2 = session.dataTask(with: url2) { (data, response, error) in
//            if let jsonData = data {
//                do {
//                    let product = try self.decoder.decode(Product.self, from: jsonData)
//                    print(product.createdAt)
//                    print(product.currency)
//                    print(product.vendors)
//                } catch {
//                    print(error.localizedDescription)
//                }
//            } else{
//                print("실패")
//            }
//        }
//        task2.resume()
    }
}
