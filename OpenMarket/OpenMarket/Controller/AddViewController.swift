//
//  AddViewController.swift
//  OpenMarket
//
//  Created by 정재근 on 2022/11/09.
//

import UIKit

class AddViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        self.view.backgroundColor = .white
        self.title = "상품등록"
    }
}
