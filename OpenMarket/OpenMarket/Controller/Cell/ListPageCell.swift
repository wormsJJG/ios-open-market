//
//  PageCell.swift
//  OpenMarket
//
//  Created by 정재근 on 2022/11/01.
//

import UIKit
import Then
import SnapKit

final class ListPageCell: UICollectionViewListCell, CellSelectable {
    var productId: Int?
    private let imageLength: CGFloat = 80
    private var contentLayout: [NSLayoutConstraint]?
    //MARK: - UI Compoent
    private lazy var listContentView = UIListContentView(configuration: .subtitleCell())
    private lazy var thumbnailImage = UIImageView()
    private let imageCache = ImageCache.shared
    private let stockLabel: UILabel = {
        let label = UILabel().then {
            $0.textAlignment = .right
            $0.numberOfLines = 2
            $0.font = .systemFont(ofSize: 15)
        }
        
        return label
    }()
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        constraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImage.image = nil
    }
    // MARK: - Function
    private func listConfiguration() -> UIListContentConfiguration {
        .subtitleCell()
    }
    
    private func constraint() {
        guard contentLayout == nil else { return }
        let indicator = UICellAccessory.disclosureIndicator()
        self.accessories = [indicator]
        
        [listContentView, stockLabel, thumbnailImage].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let height = contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: imageLength)
        height.priority = UILayoutPriority(999)
        height.isActive = true
        
        thumbnailImage.snp.makeConstraints { imageView in
            imageView.width.height.equalTo(imageLength - 5)
            imageView.trailing.equalTo(listContentView.snp.leading)
            imageView.leading.equalTo(contentView.snp.leading)
            imageView.centerY.equalTo(contentView.snp.centerY)
        }

        listContentView.snp.makeConstraints { view in
            view.top.equalTo(contentView.snp.top)
            view.bottom.equalTo(contentView.snp.bottom)
        }

        stockLabel.snp.makeConstraints { label in
            label.leading.equalTo(listContentView.snp.trailing)
            label.trailing.equalTo(contentView.snp.trailing).offset(-5)
            label.width.equalTo(listContentView.snp.width).multipliedBy(0.5)
            label.top.equalTo(contentView.snp.top).offset(15)
        }
    }
    
    func configureCell(page: Page) {
        self.productId = page.id
        setListContentView(name: page.name, currency: page.currency, price: page.price, discountedPrice: page.discountedPrice)
        setThumbnailImage(thumbnail: page.thumbnail)
        setStockLabel(stock: page.stock)
    }
    
    private func setListContentView(name: String, currency: Currency, price: Double, discountedPrice: Double) {
        var configure = self.listConfiguration()
        
        configure.text = name
        configure.textProperties.font = .preferredFont(forTextStyle: .headline)
        configure.secondaryTextProperties.font = .preferredFont(forTextStyle: .callout)
        configure.secondaryTextProperties.color = .gray
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        switch currency {
        case .usd:
            numberFormatter.maximumFractionDigits = 1
        case .krw:
            numberFormatter.maximumFractionDigits = 0
        }
        
        let priceString = numberFormatter.string(for: price) ?? ""
        
        if  discountedPrice == 0 {
            configure.secondaryText = "\(currency.rawValue) \(priceString)"
        } else {
            let discountPrice = numberFormatter.string(for: discountedPrice) ?? ""
            let priviousPrice = "\(currency.rawValue) \(priceString)"
            let text = priviousPrice + " \(currency.rawValue) \(discountPrice)"
            configure.secondaryAttributedText = NSMutableAttributedString(allText: text, previousText: priviousPrice)
        }
        listContentView.configuration = configure
    }
    
    private func setThumbnailImage(thumbnail: String) {
        self.imageCache.loadImage(stringUrl: thumbnail) { image in
            guard let thubnailImage = image else { return }
            DispatchQueue.main.async { [weak self] in
                self?.thumbnailImage.image = thubnailImage
            }
        }
    }
    
    private func setStockLabel(stock: Int) {
        if stock == 0 {
            stockLabel.text = "품절"
            stockLabel.textColor = .orange
        } else {
            stockLabel.text = "잔여수량 : \(stock)"
            stockLabel.textColor = .gray
        }
    }
}
