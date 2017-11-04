//
//  SleepFormNavigationController.swift
//  TrainingDb
//
//  Created by Christoph Muck on 28/08/2017.
//  Copyright © 2017 Christoph Muck. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

open class FormNavigationController: StatusBarNavigationController {

    var views: [FormView]!
    var vcs: [FormViewController?]!
    public var formNavigationControllerDelegate: FormNavigationControllerDelegate!

    var viewModel: Any!
    var cancelButton: UIBarButtonItem!

    override open func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()

        viewModel = formNavigationControllerDelegate.instantiateViewModel(self)
        views = formNavigationControllerDelegate.embeddedForms(self).map { $0.asFormView() }

        initViews()

        cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissVc(sender:)))

        vcs = [FormViewController?](repeating: nil, count: views.count)
        pushVc(withIndex: 0, animated: false)
    }

    @objc func dismissVc(sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }

    private func initViews() {
        self.views.forEach { view in
            view.viewModel = self.viewModel
            view.didSetViewModel()
        }
    }

    private func pushVc(withIndex index: Int, animated: Bool = true) {
        let vc = vcs[index] ?? {
            let newVc = FormViewController()
            newVc.form = views[index]
            newVc.lastForm = index == vcs.count - 1

            newVc.navigationItem.rightBarButtonItem = cancelButton
            newVc.cancelButton = cancelButton

            newVc.headerView = formNavigationControllerDelegate.headerView(self, forViewWithIndex: index)
            newVc.gradient = formNavigationControllerDelegate.gradient(self, forViewWithIndex: index)
            newVc.backgroundColor = formNavigationControllerDelegate.backgroundColor(self, forViewWithIndex: index)
            newVc.buttonTextColor = formNavigationControllerDelegate.buttonTextColor(self, forViewWithIndex: index)
            newVc.buttonBackgroundColor = formNavigationControllerDelegate.buttonBackgroundColor(self, forViewWithIndex: index)

            newVc.navigationItem.title = formNavigationControllerDelegate.navigationItemTitle(self, forViewWithIndex: index)

            vcs[index] = newVc
            return newVc
        }()
        self.pushViewController(vc, animated: animated)
    }

    func buttonTapped(sender weakSender: FormViewController?) -> Driver<ErrorMessageType> {
        guard let sender = weakSender else { return Driver.never() }
        let currentIndex = vcs.index(where: { $0 === sender })!

        (self.topViewController as? FormViewController)?.form.writeChangesToViewModel()

        let currentIndexIsLast = currentIndex == views.count - 1
        if (!currentIndexIsLast) {
            pushVc(withIndex: currentIndex + 1)
            return Driver.never()
        } else {
            return save()
        }
    }

    open func configureNavigationBar() {
    }

    private func save() -> Driver<ErrorMessageType> {
        return formNavigationControllerDelegate.save(self, viewModel: viewModel)
    }
}

public protocol FormNavigationControllerDelegate {

    func save(_ formNavigationController: FormNavigationController, viewModel: Any) -> Driver<ErrorMessageType>

    func embeddedForms(_ formNavigationController: FormNavigationController) -> [FormViewConvertible]

    func instantiateViewModel(_ formNavigationController: FormNavigationController) -> Any

    func headerView(_ formNavigationController: FormNavigationController, forViewWithIndex index: Int) -> UIView?

    func gradient(_ formNavigationController: FormNavigationController, forViewWithIndex index: Int) -> CAGradientLayer?

    func backgroundColor(_ formNavigationController: FormNavigationController, forViewWithIndex index: Int) -> UIColor?

    func buttonBackgroundColor(_ formNavigationController: FormNavigationController, forViewWithIndex index: Int) -> UIColor?

    func buttonTextColor(_ formNavigationController: FormNavigationController, forViewWithIndex index: Int) -> UIColor?

    func navigationItemTitle(_ formNavigationController: FormNavigationController, forViewWithIndex index: Int) -> String?
}

public extension FormNavigationControllerDelegate {

    func headerView(_ formNavigationController: FormNavigationController, forViewWithIndex index: Int) -> UIView? {
        return nil
    }

    func gradient(_ formNavigationController: FormNavigationController, forViewWithIndex index: Int) -> CAGradientLayer? {
        return nil
    }

    func backgroundColor(_ formNavigationController: FormNavigationController, forViewWithIndex index: Int) -> UIColor? {
        return nil
    }

    func buttonBackgroundColor(_ formNavigationController: FormNavigationController, forViewWithIndex index: Int) -> UIColor? {
        return nil
    }

    func buttonTextColor(_ formNavigationController: FormNavigationController, forViewWithIndex index: Int) -> UIColor? {
        return nil
    }

    func navigationItemTitle(_ formNavigationController: FormNavigationController, forViewWithIndex index: Int) -> String? {
        return nil
    }
}
