//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    let url = URL(string: "https://openmarket.yagom-academy.kr/api/products?page_no=1&items_per_page=100")!
    let session = URLSession(configuration: .default)
    let decoder = JSONDecoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let task = session.dataTask(with: url) { (data, response, error) in
            if let jsonData = data {
                do {
                    let page = try self.decoder.decode(ProductListPage.self, from: jsonData)
                    print(page.productList.count)
                } catch {
                    print(error.localizedDescription)
                }
            } else{
                print("실패")
            }
        }
        task.resume()
    }
}
