//
//  GridPageCell.swift
//  OpenMarket
//
//  Created by 정연호 on 2022/11/03.
//

import UIKit

final class GridPageCell: UICollectionViewCell, CellSelectable {
    var productId: Int?
    private lazy var productImage: UIImageView = UIImageView()
    private lazy var productTitle: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.preferredFont(forTextStyle: .headline)
        
        return lable
    }()
    private lazy var productPriceLabel: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.preferredFont(forTextStyle: .callout)
        lable.textColor = .gray
        
        return lable
    }()
    private lazy var productDiscountLabel: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.preferredFont(forTextStyle: .callout)
        lable.textColor = .gray
        
        return lable
    }()
    private lazy var productStockLabel: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.preferredFont(forTextStyle: .callout)
        
        return lable
    }()
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productImage, productTitle, productPriceLabel, productDiscountLabel, productStockLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setCellLayer()
        cellConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setCellLayer() {
        contentView.layer.borderColor = UIColor.gray.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 10
    }
    
    private func cellConstraint() {
        contentView.addSubview(vStackView)
        
        let inset: CGFloat = 20
        NSLayoutConstraint.activate([
            vStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            vStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset),
            vStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            vStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            productImage.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            productImage.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5)
        ])
    }
}
