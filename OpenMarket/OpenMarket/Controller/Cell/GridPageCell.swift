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
    
    private lazy var priceLabelStackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [productPriceLabel, productDiscountLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 1.0
        
        return stackView
    }()
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productImage, productTitle, priceLabelStackView, productStockLabel])
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productPriceLabel.attributedText = nil
        productImage.image = nil
    }
    
    private func setCellLayer() {
        contentView.layer.borderColor = UIColor.gray.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 10
    }
    
    private func cellConstraint() {
        let inset: CGFloat = 20
        
        contentView.addSubview(vStackView)
        NSLayoutConstraint.activate([
            vStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            vStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset),
            vStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            vStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            productImage.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            productImage.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6)
        ])
    }
    
    func configure(page: Page) {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        switch page.currency {
        case .krw:
            numberFormatter.maximumFractionDigits = 0
        case .usd:
            numberFormatter.maximumFractionDigits = 1
        }
        
        let price = numberFormatter.string(for: page.price) ?? ""
        let discountedPrice = numberFormatter.string(for: page.discountedPrice) ?? ""
        
        DispatchQueue.global().async {
            let imageData = try! Data(contentsOf: URL(string: page.thumbnail)!)
            let image = UIImage(data: imageData)
            DispatchQueue.main.async { [weak self] in
                self?.productImage.image = image
            }
        }
        
        productTitle.text = page.name
        productId = page.id
        
        if page.discountedPrice == 0 {
            productDiscountLabel.isHidden = true
            productPriceLabel.text = "\(page.currency.rawValue) \(price)"
        } else {
            productDiscountLabel.isHidden = false
            let priceText = "\(page.currency.rawValue) \(price)"
            productPriceLabel.attributedText = NSMutableAttributedString(allText: priceText, previousText: priceText)
            productDiscountLabel.text = "\(page.currency.rawValue) \(discountedPrice)"
        }
        
        if page.stock == 0 {
            productStockLabel.text = "품절"
            productStockLabel.textColor = .orange
        } else {
            productStockLabel.text = "잔여수량 : \(page.stock)"
            productStockLabel.textColor = .gray
        }
    }
}
