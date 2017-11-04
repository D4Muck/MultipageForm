//
// Created by Christoph Muck on 04/11/2017.
//

import Foundation

public extension String {

    var localized: String {
        return localized1(withComment: "")
    }

    public func localized1(withComment: String = "") -> String {

      let path =  Bundle(for: FormViewController.self)
        .path(forResource: "MultipageForm", ofType: "bundle")!

        print(path)

        let bundle = Bundle(path: path)!

        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: withComment)
    }
}