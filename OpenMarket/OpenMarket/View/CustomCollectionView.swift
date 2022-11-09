//
//  CustomCollectionView.swift
//  OpenMarket
//
//  Created by 정재근 on 2022/11/02.
//

import UIKit

final class CustomCollectionView: UICollectionView {
    
    enum ViewType: Int {
        case list = 0
        case grid = 1
    }
    
    private lazy var listLayout: UICollectionViewCompositionalLayout = {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        return layout
    }()
    
    private lazy var gridLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout().then {
            let inset: CGFloat = 10
            let rowItem = 2
            let width = (safeAreaLayoutGuide.layoutFrame.width / CGFloat(rowItem)) - (inset * 1.5)
            let height = (safeAreaLayoutGuide.layoutFrame.height / 2.6) - inset
            
            $0.minimumLineSpacing = inset
            $0.minimumInteritemSpacing = inset
            $0.scrollDirection = .vertical
            $0.itemSize = CGSize(width: width, height: height)
            $0.sectionInset.left = inset
            $0.sectionInset.right = inset
        }
        
        return layout
    }()
    
    func changeLayout(type: ViewType) {
        switch type {
        case .list:
            setCollectionViewLayout(listLayout, animated: true)
        case.grid:
            setCollectionViewLayout(gridLayout, animated: true)
        }
        
        self.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
    }
}
