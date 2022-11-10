//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class ProductListViewController: UIViewController, UIGestureRecognizerDelegate {
    
    enum Section {
        case main
    }
    // MARK: - const var
    private var productListPage: ProductListPage?
    private var dataSource: UICollectionViewDiffableDataSource<Section, Page>!
    // MARK: - UI Component
    @IBOutlet weak private var viewTypeSegmentControl: UISegmentedControl!
    @IBOutlet weak private var moveToAddViewButton: UIBarButtonItem!
    @IBOutlet weak private var pageCollectionView: CustomCollectionView!
    private let swipeGesture = UISwipeGestureRecognizer()
    
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
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.pageCollectionView.reloadData()
    }
    // MARK: - configure
    private func configure() {
        configureDataSource()
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
        pageCollectionView.register(ListPageCell.self, forCellWithReuseIdentifier: CellIdentifier.listCellID)
        pageCollectionView.register(GridPageCell.self, forCellWithReuseIdentifier: CellIdentifier.gridCellID)
    }
    
    private func addSwipeGesture() {
        swipeGesture.direction = .left
        swipeGesture.addTarget(self, action: #selector(didSwipe))
        self.view.addGestureRecognizer(swipeGesture)
    }
    // MARK: - Data
    private func getProductListPage() {
        DispatchQueue.global().async {
            NetworkManager.getData(requestType: .productList(pageNo: 1, itemsPerPage: 100)) { result in
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
    
    private func configureDataSource() {
        self.dataSource = UICollectionViewDiffableDataSource<Section, Page>(collectionView: pageCollectionView) {
            pageCollectionView, indexPath, itemIdentifier in
            
            switch CustomCollectionView.ViewType(rawValue: self.viewTypeSegmentControl.selectedSegmentIndex) {
            case .list:
                guard let cell = pageCollectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.listCellID, for: indexPath) as? ListPageCell else {
                    
                    return UICollectionViewListCell()
                }
                cell.configureCell(page: itemIdentifier)
                
                return cell
            case .grid:
                guard let cell = pageCollectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.gridCellID, for: indexPath) as? GridPageCell else {
                    
                    return UICollectionViewCell()
                }
                cell.configure(page: itemIdentifier)
                
                return cell
            case .none:
                return UICollectionViewListCell()
            }
        }
    }
    // MARK: - Action
    private func changeLayoutAction() {
        pageCollectionView.reloadData()
        activityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [self] in
            activityIndicator.stopAnimating()
        }
    }
    
    @IBAction func didChangeSegmentControl(_ sender: UISegmentedControl) {
        switch CustomCollectionView.ViewType(rawValue: sender.selectedSegmentIndex) {
        case .list:
            pageCollectionView.changeLayout(type: .list)
            changeLayoutAction()
        case .grid:
            pageCollectionView.changeLayout(type: .grid)
            changeLayoutAction()
        case .none:
            return
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
