//
// Created by Christoph Muck on 28/08/2017.
// Copyright (c) 2017 Christoph Muck. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FormViewController: UIViewController {

    var contentView: UIView!
    var cancelButton: UIBarButtonItem!
    var nextButton: ButtonWithSpinner!
    var lastForm: Bool!
    var form: FormView!

    var headerView: UIView?
    var backgroundColor: UIColor?
    var buttonBackgroundColor: UIColor?
    var buttonTextColor: UIColor?

    let disposeBag = DisposeBag()

    var bottomConstraint: NSLayoutConstraint?

    override func loadView() {
        contentView = UIView(frame: UIScreen.main.bounds)
        if (gradient == nil) {
            contentView.backgroundColor = backgroundColor ?? .white
        }

        self.view = contentView

        var constraints: [NSLayoutConstraint] = []

        nextButton = ButtonWithSpinner()
        nextButton.button.setTitle(buttonTitle(), for: .normal)
        nextButton.button.setTitleColor(buttonTextColor, for: .normal)

        if let bgColor = buttonBackgroundColor {
            nextButton.button.setBackgroundImage(UIImage.from(color: bgColor), for: .normal)
            nextButton.button.adjustsImageWhenDisabled = true
        }

        nextButton.button.layer.cornerRadius = 1
        nextButton.activityIndicator.color = buttonTextColor

        contentView.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false

        let bottomConstraint = contentView.bottomAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 20)
        self.bottomConstraint = bottomConstraint

        constraints.append(contentsOf: [
            nextButton.heightAnchor.constraint(equalToConstant: 46),
            nextButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            bottomConstraint,
            nextButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20)
        ])

        let header: UIView
        if (headerView != nil) {
            header = headerView!
        } else {
            header = UIView()
            constraints.append(header.heightAnchor.constraint(equalToConstant: 0))
            headerView = header
        }
        header.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(header)

        let topConstraintToItem: NSLayoutYAxisAnchor
        if #available(iOS 11.0, *) {
            topConstraintToItem = contentView.safeAreaLayoutGuide.topAnchor
        } else {
            // Fallback on earlier versions
            topConstraintToItem = self.topLayoutGuide.bottomAnchor
        }

        constraints.append(contentsOf: [
            header.topAnchor.constraint(equalTo: topConstraintToItem),
            header.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            header.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])

        contentView.addSubview(form)
        form.translatesAutoresizingMaskIntoConstraints = false

        constraints.append(contentsOf: [
            form.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            form.topAnchor.constraint(equalTo: header.bottomAnchor),
            form.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            form.bottomAnchor.constraint(equalTo: nextButton.topAnchor),
        ])

        NSLayoutConstraint.activate(constraints)
    }

    private func buttonTitle() -> String {
        if lastForm {
            return "Speichern"
        } else {
            return "Weiter"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initBackgroundGradient()
        initRx()
    }

    private func initRx() {
        let isLoading = nextButton.button.rx.tap.asDriver().map { [weak self] in self }
                .flatMapLatest((self.navigationController as? FormNavigationController)!.buttonTapped)

        isLoading.drive(nextButton.activityIndicator.rx.isAnimating).disposed(by: disposeBag)

        let isNotLoading = isLoading.map { !$0 }
        isNotLoading.drive(cancelButton.rx.isEnabled).disposed(by: disposeBag)

        let isButtonEnabled = Driver.merge(form.nextButtonEnabled, isNotLoading)
        isButtonEnabled.drive(nextButton.button.rx.isEnabled).disposed(by: disposeBag)
    }

    var gradient: CAGradientLayer?

    private func initBackgroundGradient() {
        guard let guardedGradient = gradient else { return }
        self.view.layer.insertSublayer(guardedGradient, at: 0)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        gradient?.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gradient?.frame = self.view.bounds

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: Notification.Name.UIKeyboardWillShow, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func keyboardWillAppear(n: NSNotification) {
        let d = n.userInfo!
        let r = (d[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        bottomConstraint?.constant = r.size.height + 20
        self.view.layoutIfNeeded()
    }

    @objc func keyboardWillDisappear() {
        bottomConstraint?.constant = 20
        self.view.layoutIfNeeded()
    }
}

extension UIImage {
    public static func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}
