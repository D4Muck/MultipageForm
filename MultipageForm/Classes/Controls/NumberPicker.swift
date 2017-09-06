//
// Created by Christoph Muck on 25/08/2017.
// Copyright (c) 2017 Christoph Muck. All rights reserved.
//

import UIKit

@IBDesignable
class NumberPicker: UIPickerView {

    @IBInspectable var min: Int = 0 {
        didSet {
            calculateValues()
        }
    }

    @IBInspectable var max: Int = 10 {
        didSet {
            calculateValues()
        }
    }

    @IBInspectable var interval: Int = 1 {
        didSet {
            calculateValues()
        }
    }

    private var _selectedValue: Int?

    @IBInspectable var selectedValue: Int {
        get {
            return values[self.selectedRow(inComponent: 0)]
        }
        set(newSelected) {
            _selectedValue = newSelected
            updateSelected()
        }
    }

    @IBInspectable var unitText: String? {
        get {
            return unitLabel.text
        }
        set(newText) {
            unitLabel.text = newText
            unitLabel.sizeToFit()
        }
    }

    override var bounds: CGRect {
        didSet {
            positionLabel()
        }
    }

    let unitLabel = UILabel()
    private var values: [Int] = []

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
        self.dataSource = self

        unitLabel.font = UIFont.boldSystemFont(ofSize: 20)
        unitLabel.backgroundColor = UIColor.clear
        unitLabel.textColor = UIColor.white
        unitLabel.sizeToFit()
        self.addSubview(unitLabel)
    }

    private func positionLabel() {
        let halfHeight = self.bounds.size.height / 2
        let halfWidth = self.bounds.size.width / 2

        unitLabel.center.y = halfHeight
        unitLabel.frame.origin.x = halfWidth + 40
    }

    private func calculateValues() {
        if min > max || interval < 1 {
            return
        }

        values = (min...max).enumerated().filter { $0.0 % interval == 0 }.map { $0.1 }
        self.reloadAllComponents()
        self.updateSelected()
    }

    private func updateSelected() {
        guard let val = _selectedValue else { return }

        if let i = values.index(of: val) {
            self.selectRow(i, inComponent: 0, animated: false)
        }
    }
}

extension NumberPicker: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: String(values[row]), attributes: [.foregroundColor: UIColor.white])
    }
}

extension NumberPicker: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return values.count
    }
}
