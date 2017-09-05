//
// Created by Christoph Muck on 22/08/2017.
// Copyright (c) 2017 Catalysts. All rights reserved.
//

import UIKit

@IBDesignable
class ButtonWithSpinner: UIView {

    @IBInspectable var buttonTitle: String? {
        didSet {
            button!.setTitle(buttonTitle, for: .normal)
        }
    }

    @IBInspectable var buttonColor: UIColor? {
        didSet {
            button!.setTitleColor(buttonColor, for: .normal)
        }
    }

    var activityIndicator: UIActivityIndicatorView!
    @IBInspectable var button: UIButton!

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }

    private func setUp() {
        let button = UIButton(type: .system)
        let activityIndicator = UIActivityIndicatorView()

        self.addSubview(button)
        self.addSubview(activityIndicator)

        button.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: button, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: button, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        ])

        self.button = button
        self.activityIndicator = activityIndicator
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let halfHeight = self.bounds.size.height / 2
        let width = self.bounds.size.width
        activityIndicator.center = CGPoint(x: width - 20, y: halfHeight)
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        //setup your view with the settings
    }
}
