//
//  ColorFormView.swift
//  MultipageForm_Example
//
//  Created by Christoph Muck on 05/09/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import MultipageForm

class ColorFormView: FormView {
    
    @IBOutlet var pickerView: UIPickerView!
    
    override func writeChangesToViewModel() {
        let model = self.viewModel as! Model
        let selectedIndex = pickerView.selectedRow(inComponent: 0)
        model.favoriteColor = values[selectedIndex]
    }
    
    let values = (Color.black.rawValue...Color.yellow.rawValue).map{ Color(rawValue: $0)! }
}

extension ColorFormView: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return values.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return values[row].description
    }
}
