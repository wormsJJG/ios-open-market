//
//  PageCell.swift
//  OpenMarket
//
//  Created by 정재근 on 2022/11/01.
//

import UIKit

final class ListPageCell: UICollectionViewListCell, CellSelectable {
    
    var productId: Int?
    private let imageLength: CGFloat = 80
    private var contentLayout: [NSLayoutConstraint]?
    private lazy var listContentView = UIListContentView(configuration: .subtitleCell())
    private lazy var thumbnailImage = UIImageView()
    private let stockLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 15)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        constraint()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImage.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func listConfiguration() -> UIListContentConfiguration {
        .subtitleCell()
    }
    
    private func constraint() {
        guard contentLayout == nil else { return }
        
        self.accessories = [.disclosureIndicator()]
        
        [listContentView, stockLabel, thumbnailImage].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let height = contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: imageLength)
        height.priority = UILayoutPriority(999)
        
        let layouts = [
            height,
            thumbnailImage.widthAnchor.constraint(equalToConstant: imageLength-5),
            thumbnailImage.heightAnchor.constraint(equalToConstant: imageLength-5),
            thumbnailImage.trailingAnchor.constraint(equalTo: listContentView.leadingAnchor),
            thumbnailImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            thumbnailImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            listContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            listContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            
            stockLabel.leadingAnchor.constraint(equalTo: listContentView.trailingAnchor),
            stockLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            stockLabel.widthAnchor.constraint(equalTo: listContentView.widthAnchor, multiplier: 0.5),
            stockLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15)
        ]
        
        NSLayoutConstraint.activate(layouts)
    }
    
    func configureCell(page: Page) {
        var configure = self.listConfiguration()
        DispatchQueue.global().async {
            let imageData = try! Data(contentsOf: URL(string: page.thumbnail)!)
            let image = UIImage(data: imageData)
            DispatchQueue.main.async { [weak self] in
                self?.thumbnailImage.image = image
            }
        }
        
        configure.text = page.name
        configure.textProperties.font = .preferredFont(forTextStyle: .headline)
        configure.secondaryTextProperties.font = .preferredFont(forTextStyle: .callout)
        configure.secondaryTextProperties.color = .gray
        
        self.productId = page.id
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        switch page.currency {
        case .usd:
            numberFormatter.maximumFractionDigits = 1
        case .krw:
            numberFormatter.maximumFractionDigits = 0
        }
        
        let price = numberFormatter.string(for: page.price) ?? ""
        
        if page.discountedPrice == 0 {
            configure.secondaryText = "\(page.currency.rawValue) \(price)"
        } else {
            let discountPrice = numberFormatter.string(for: page.discountedPrice) ?? ""
            let priviousPrice = "\(page.currency.rawValue) \(price)"
            let text = priviousPrice + " \(page.currency.rawValue) \(discountPrice)"
            configure.secondaryAttributedText = NSMutableAttributedString(allText: text, previousText: priviousPrice)
        }
        listContentView.configuration = configure
        
        if page.stock == 0 {
            stockLabel.text = "품절"
            stockLabel.textColor = .orange
        } else {
            stockLabel.text = "잔여수량 : \(page.stock)"
            stockLabel.textColor = .gray
        }
    }
}
