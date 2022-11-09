//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import Then
import SnapKit

final class MainViewController: UIViewController {
    
    enum Section {
        case main
    }
    // MARK: - UI Component
    private lazy var viewTypeSegmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["List", "GRID"]).then {
            $0.selectedSegmentIndex = 0
            $0.backgroundColor = .white
            $0.selectedSegmentTintColor = .systemBlue
            $0.layer.borderWidth = 2
            $0.layer.borderColor = UIColor.systemBlue.cgColor
            $0.addTarget(self, action: #selector(didChangeSegmentControl(_:)), for: .valueChanged)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.setTitleTextAttributes(UISegmentedControl.segmentSelectedTextAttributes, for: .selected)
            $0.setTitleTextAttributes(UISegmentedControl.segmentBasicTextAttributes, for: .normal)
        }
        
        return segmentControl
    }()
    
    private lazy var pageCollectionView: CustomCollectionView = {
        let collectionView = CustomCollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()).then {
            $0.changeLayout(type: .list)
        }
        
        return collectionView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView().then {
            $0.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            $0.center = self.view.center
            $0.color = .blue
            $0.hidesWhenStopped = true
            $0.style = UIActivityIndicatorView.Style.medium
            $0.stopAnimating()
        }
        
        return activityIndicator
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl().then {
            $0.addTarget(self, action: #selector(didRefresh), for: .valueChanged)
        }
        
        return control
    }()
    // MARK: - 변수, 상수
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
            cell.configureCell(page: itemIdentifier)
            
            return cell
        case .none:
            return UICollectionViewListCell()
        }
    }
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    // MARK: - Function
    private func configure() {
        self.view.backgroundColor = .white
        configureCollectionView()
        registerCell()
        configureSegmentControl()
        addIndicator()
        getProductListPage()
        addSwipeGesture()
    }
    
    private func configureSegmentControl() {
        let width = view.frame.size.width / 2
        viewTypeSegmentControl.snp.makeConstraints { segment in
            segment.width.equalTo(width)
        }
        
        navigationItem.titleView = viewTypeSegmentControl
    }
    
    private func addIndicator() {
        self.view.addSubview(activityIndicator)
        self.activityIndicator.startAnimating()
    }
    
    private func configureCollectionView() {
        self.view.addSubview(pageCollectionView)
        
        pageCollectionView.snp.makeConstraints { collectionView in
            collectionView.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            collectionView.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            collectionView.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            collectionView.bottom.equalTo(view.snp.bottom)
        }
        registerCell()
        pageCollectionView.refreshControl = refreshControl
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
    
    @objc func didChangeSegmentControl(_ sender: UISegmentedControl) {
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
                            self?.refreshControl.endRefreshing()
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
    
    @objc private func didRefresh() {
        getProductListPage()
    }
}

extension MainViewController: UIGestureRecognizerDelegate {
    
}
