//
//  AgeFormView.swift
//  MultipageForm_Example
//
//  Created by Christoph Muck on 05/09/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import MultipageForm

class AgeFormView: FormView {
    
    @IBOutlet var datePicker: UIDatePicker!
    
    override func writeChangesToViewModel() {
        let model = self.viewModel as! Model
        model.age = datePicker.date
    }
}
