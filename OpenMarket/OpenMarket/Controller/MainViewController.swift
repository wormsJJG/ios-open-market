//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class MainViewController: UIViewController, UIGestureRecognizerDelegate {
    
    enum Section {
        case main
    }
    
    @IBOutlet weak private var viewTypeSegmentControl: UISegmentedControl!
    @IBOutlet weak private var plusButton: UIBarButtonItem!
    @IBOutlet weak private var pageCollectionView: CustomCollectionView!
    
    private let listCellID: String = "ListPageCell"
    private let gridCellID: String = "GridPageCell"
    private let networkManager = NetworkManager()
    private let swipeGesture = UISwipeGestureRecognizer()
    private var productListPage: ProductListPage?
    
    private lazy var dataSource = UICollectionViewDiffableDataSource<Section, Page>(collectionView: pageCollectionView) { pageCollectionView, indexPath, itemIdentifier in
        
        switch CustomCollectionView.ViewType(rawValue: self.viewTypeSegmentControl.selectedSegmentIndex) {
        case .list:
            guard let cell = pageCollectionView.dequeueReusableCell(withReuseIdentifier: self.listCellID, for: indexPath) as? ListPageCell else {
                
                return UICollectionViewListCell()
            }
            cell.configureCell(page: itemIdentifier)
            
            return cell
        case .grid:
            guard let cell = pageCollectionView.dequeueReusableCell(withReuseIdentifier: self.gridCellID, for: indexPath) as? GridPageCell else {
                
                return UICollectionViewCell()
            }
            cell.configure(page: itemIdentifier)
            
            return cell
        case .none:
            return UICollectionViewListCell()
        }
    }
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = self.view.center
        activityIndicator.color = .blue
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        activityIndicator.stopAnimating()
        
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        pageCollectionView.changeLayout(type: .list)
        registerCell()
        addIndicator()
        getProductListPage()
        addSwipeGesture()
    }
    
    private func addIndicator() {
        self.view.addSubview(activityIndicator)
        self.activityIndicator.startAnimating()
    }
    
    private func registerCell() {
        pageCollectionView.register(ListPageCell.self, forCellWithReuseIdentifier: listCellID)
        pageCollectionView.register(GridPageCell.self, forCellWithReuseIdentifier: gridCellID)
    }
    
    private func addSwipeGesture() {
        swipeGesture.direction = .left
        swipeGesture.addTarget(self, action: #selector(didSwipe))
        self.view.addGestureRecognizer(swipeGesture)
    }
    
    @IBAction func didChangeSegmentControl(_ sender: UISegmentedControl) {
        switch CustomCollectionView.ViewType(rawValue: sender.selectedSegmentIndex) {
        case .list:
            pageCollectionView.changeLayout(type: .list)
            pageCollectionView.reloadData()
        case .grid:
            pageCollectionView.changeLayout(type: .grid)
            pageCollectionView.reloadData()
        case .none:
            return
        }
    }
    
    private func getProductListPage() {
        DispatchQueue.global().async {
            self.networkManager.getData(requestType: .productList(pageNo: 1, itemsPerPage: 100)) { result in
                switch result {
                case .success(let data):
                    do {
                        let productListPage = try JSONDecoder().decode(ProductListPage.self, from: data)
                        DispatchQueue.main.async { [weak self] in
                            self?.setSnapShot(pages: productListPage.pages)
                            self?.pageCollectionView.reloadData()
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func setSnapShot(pages: [Page]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Page>()
        snapShot.appendSections([.main])
        DispatchQueue.main.async { [weak self] in
            snapShot.appendItems(pages)
            self?.dataSource.apply(snapShot, animatingDifferences: false)
            self?.activityIndicator.stopAnimating()
        }
    }
    
    @objc private func didSwipe(sender: UIGestureRecognizer) {
        let isLeftSwipe = viewTypeSegmentControl.selectedSegmentIndex == 0
        swipeGesture.direction = isLeftSwipe ? .right : .left
        
        viewTypeSegmentControl.selectedSegmentIndex = isLeftSwipe ? 1 : 0
        
        pageCollectionView.changeLayout(type: isLeftSwipe ? .grid : .list)
        pageCollectionView.reloadData()
    }
}
