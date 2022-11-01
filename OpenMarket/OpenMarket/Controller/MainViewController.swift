//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak private var viewTypeSegement: UISegmentedControl!
    @IBOutlet weak private var plusButton: UIBarButtonItem!
    @IBOutlet weak private var pagesCollectionView: UICollectionView!
    private let cellID: String = "PageCell"
    private var productListPage: ProductListPage?
    private let networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        self.networkManager.getData(requestType: .productList(pageNo: 1, itemsPerPage: 100)) { result in
            switch result {
            case .success(let data):
                do {
                    let productListPage = try JSONDecoder().decode(ProductListPage.self, from: data)
                    print(productListPage)
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
