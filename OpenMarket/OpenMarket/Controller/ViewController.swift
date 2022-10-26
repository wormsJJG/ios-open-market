//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    let url = URL(string: API.getProductList(pageNo: 1, itemsPerPage: 100).url)!
    let url2 = URL(string: API.getProduntInfo(productId: 60).url)!
    let session = URLSession(configuration: .default)
    let decoder = JSONDecoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let task = session.dataTask(with: url) { (data, response, error) in
            if let jsonData = data {
                do {
                    let page = try self.decoder.decode(ProductListPage.self, from: jsonData)
                    print(page.pageNo)
                } catch {
                    print(error.localizedDescription)
                }
            } else{
                print("실패")
            }
        }
        task.resume()
        let task2 = session.dataTask(with: url2) { (data, response, error) in
            if let jsonData = data {
                do {
                    let product = try self.decoder.decode(Product.self, from: jsonData)
                    print(product.createdAt)
                    print(product.currency)
                    print(product.vendors)
                } catch {
                    print(error.localizedDescription)
                }
            } else{
                print("실패")
            }
        }
        task2.resume()
    }
}
