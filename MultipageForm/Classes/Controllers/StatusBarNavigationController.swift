//
// Created by Christoph Muck on 06/09/2017.
// Copyright (c) 2017 Christoph Muck. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

open class StatusBarNavigationController: UINavigationController {

    private let statusBarLabel = UILabel()

    open override func viewDidLoad() {
        super.viewDidLoad()

        statusBarLabel.isHidden = true
        statusBarLabel.backgroundColor = .red
        statusBarLabel.textColor = .white
        statusBarLabel.translatesAutoresizingMaskIntoConstraints = false

        self.view!.addSubview(statusBarLabel)

        let navigationBar = self.navigationBar
        NSLayoutConstraint.activate([
            statusBarLabel.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            statusBarLabel.leftAnchor.constraint(equalTo: navigationBar.leftAnchor),
            statusBarLabel.rightAnchor.constraint(equalTo: navigationBar.rightAnchor),
            statusBarLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
    }

    func showStatusBar(withText text: StatusBarTextType) {
        self.statusBarLabel.layer.removeAllAnimations()

        statusBarLabel.attributedText = NSAttributedString(string: "   " + text.text, attributes: [.font: UIFont.systemFont(ofSize: 15)])
        statusBarLabel.alpha = 1.0
        statusBarLabel.isHidden = false

        UIView.animate(withDuration: 1.5, delay: 5.0, animations: {
            self.statusBarLabel.alpha = 0
        }) { finished in
            if finished {
                self.statusBarLabel.isHidden = true
            }
        }
    }
}

extension Reactive where Base: StatusBarNavigationController {
    public func errorMessages<T:StatusBarTextType>() -> Binder<T> {
        return Binder(self.base) { navigationController, errorText in
            navigationController.showStatusBar(withText: errorText)
        }
    }
}

public protocol StatusBarTextType {
    var text: String { get }
}

extension String: StatusBarTextType {
    public var text: String {
        return self
    }
}
