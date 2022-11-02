//
//  Extension+NSMutableAttributedString.swift
//  OpenMarket
//
//  Created by 정재근 on 2022/11/02.
//

import UIKit

extension NSMutableAttributedString {
    convenience init(allText: String, previousText: String) {
        self.init(string: allText)
        self.addAttribute(.foregroundColor, value: UIColor.red, range: (previousText as NSString).range(of: previousText))
        self.addAttribute(.strikethroughColor, value: UIColor.red, range: (previousText as NSString).range(of: previousText))
        self.addAttribute(.strikethroughStyle, value: 1, range: (previousText as NSString).range(of: previousText))
    }
}
