//
//  SnappingSlider.swift
//  TrainingDb
//
//  Created by Christoph Muck on 18/08/2017.
//  Copyright © 2017 Christoph Muck. All rights reserved.
//

import UIKit

class SnappingSlider: UISlider {
    override var value: Float {
        set {
            super.value = newValue
        }
        get {
            return round(super.value * 1.0) / 1.0
        }
    }
}
