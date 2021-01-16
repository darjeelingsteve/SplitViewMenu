//
//  UILabel+Extensions.swift
//  SplitViewMenu
//
//  Created by Stephen Anthony on 16/01/2021.
//

import UIKit

extension UILabel {
    convenience init(text: String, colour: UIColor = .label, textStyle: UIFont.TextStyle = .body, alignment: NSTextAlignment = .natural, numberOfLines: Int = 1) {
        self.init(frame: .zero)
        self.text = text
        self.textColor = colour
        self.font = .preferredFont(forTextStyle: textStyle)
        self.textAlignment = alignment
        self.numberOfLines = numberOfLines
        self.adjustsFontForContentSizeCategory = true
    }
}
