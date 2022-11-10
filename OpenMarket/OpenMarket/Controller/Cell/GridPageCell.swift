//
//  GridPageCell.swift
//  OpenMarket
//
//  Created by 정연호 on 2022/11/03.
//

import UIKit

final class GridPageCell: UICollectionViewCell, CellSelectable {
    var productId: Int?
    
    private lazy var thumbnailImage: UIImageView = UIImageView()
    
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
        let stackView = UIStackView(arrangedSubviews: [thumbnailImage, productTitle, priceLabelStackView, productStockLabel])
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
        thumbnailImage.image = nil
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
            thumbnailImage.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            thumbnailImage.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6)
        ])
    }
    
    func configure(page: Page) {
        productId = page.id
        productTitle.text = page.name
        setThumbnailImage(thumbnail: page.thumbnail)
        setPriceLabel(currency: page.currency, price: page.price, discountedPrice: page.discountedPrice)
        setStockLabel(stock: page.stock)
    }
    
    private func setThumbnailImage(thumbnail: String) {
        ImageCacheManager.loadImage(stringUrl: thumbnail) { image in
            guard let thumbnailImage = image else { return }
            DispatchQueue.main.async { [weak self] in
                self?.thumbnailImage.image = thumbnailImage
            }
        }
    }
    
    private func setPriceLabel(currency: Currency, price: Double, discountedPrice: Double) {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        switch currency {
        case .krw:
            numberFormatter.maximumFractionDigits = 0
        case .usd:
            numberFormatter.maximumFractionDigits = 1
        }
        
        let priceString = numberFormatter.string(for: price) ?? ""
        let discountedPriceString = numberFormatter.string(for: discountedPrice) ?? ""
        
        
        
        if discountedPrice == 0 {
            productDiscountLabel.isHidden = true
            productPriceLabel.text = "\(currency.rawValue) \(priceString)"
        } else {
            productDiscountLabel.isHidden = false
            let priceText = "\(currency.rawValue) \(priceString)"
            productPriceLabel.attributedText = NSMutableAttributedString(allText: priceText, previousText: priceText)
            productDiscountLabel.text = "\(currency.rawValue) \(discountedPriceString)"
        }
    }
    
    private func setStockLabel(stock: Int) {
        if stock == 0 {
            productStockLabel.text = "품절"
            productStockLabel.textColor = .orange
        } else {
            productStockLabel.text = "잔여수량 : \(stock)"
            productStockLabel.textColor = .gray
        }
    }
}
