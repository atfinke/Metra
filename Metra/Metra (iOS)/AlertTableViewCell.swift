//
//  AlertTableViewCell.swift
//  Metra
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import UIKit

class AlertTableViewCell: UITableViewCell {

    // MARK: - Properties

    static let reuseIdentifier = "reuseIdentifier"
    let titleLabel = UILabel()

    private var rightMarginConstraint: NSLayoutConstraint!

    // MARK: - Initalization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 15.0)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(titleLabel)

        let leftMarginConstraint = NSLayoutConstraint(item: titleLabel,
                                                      attribute: .left,
                                                      relatedBy: .equal,
                                                      toItem: self,
                                                      attribute: .leftMargin,
                                                      multiplier: 1.0,
                                                      constant: 0.0)

        rightMarginConstraint = NSLayoutConstraint(item: titleLabel,
                                                       attribute: .right,
                                                       relatedBy: .equal,
                                                       toItem: self,
                                                       attribute: .rightMargin,
                                                       multiplier: 1.0,
                                                       constant: 0.0)

        let constraints = [
            leftMarginConstraint,
            rightMarginConstraint!,
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Life Cycle

    override func layoutSubviews() {
        super.layoutSubviews()
        rightMarginConstraint.constant = accessoryType == .none ? 0 : -15
    }

}
