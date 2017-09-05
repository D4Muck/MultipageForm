//
//  ExampleFormNavigationController.swift
//  MultipageForm_Example
//
//  Created by Christoph Muck on 05/09/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import MultipageForm
import RxCocoa
import RxSwift

class ExampleFormNavigationController: FormNavigationController {
    
    override func viewDidLoad() {
        self.formNavigationControllerDelegate = self
        super.viewDidLoad()
    }
}

extension ExampleFormNavigationController: FormNavigationControllerDelegate {
    
    func save(_ formNavigationController: FormNavigationController, viewModel: Any) -> Driver<Bool> {
        let model = viewModel as! Model
        
        print("Congrats, you entered:")
        print(model)
        
        return Driver.just(true)
    }
    
    func embeddedFormViewNames(_ formNavigationController: FormNavigationController) -> [String] {
        return ["AgeForm", "ColorForm"]
    }
    
    func instantiateViewModel(_ formNavigationController: FormNavigationController) -> Any {
        return Model()
    }
    
    func headerView(_ formNavigationController: FormNavigationController, forViewWithIndex index: Int) -> UIView? {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "Hello, please tell us a little about yourself!", attributes: [.font: UIFont.systemFont(ofSize: 30)])
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.heightAnchor.constraint(equalToConstant: 150).isActive = true
        return label
    }
}

class Model: NSObject {
    var age: Date!
    var favoriteColor: Color!
    
    override var description: String {
        return "Age: " + age.description + ", Favorite Color: " + favoriteColor.description
    }
}

enum Color: Int {
    case black, yellow
}

extension Color: CustomStringConvertible {
    
    var description: String {
        switch self {
        case .black: return "Black"
        case .yellow: return "Yellow"
        }
    }
}
