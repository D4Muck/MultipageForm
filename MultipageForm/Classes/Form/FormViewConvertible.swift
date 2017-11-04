//
// Created by Christoph Muck on 04/11/2017.
//

import Foundation

public protocol FormViewConvertible {

    func asFormView() -> FormView
}

extension String: FormViewConvertible {

    public func asFormView() -> FormView {
        return Bundle.main.loadNibNamed(self, owner: nil)![0] as! FormView
    }
}

extension FormView: FormViewConvertible {

    public func asFormView() -> FormView {
        return self
    }
}