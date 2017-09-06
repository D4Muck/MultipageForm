//
// Created by Christoph Muck on 28/08/2017.
// Copyright (c) 2017 Christoph Muck. All rights reserved.
//

import UIKit
import RxCocoa

open class FormView: UIView {

    public var viewModel: Any!
    public var nextButtonEnabled = Driver.just(true)

    open func didSetViewModel() {
    }

    open func writeChangesToViewModel() {
    }
}
