//
//  BaseTextFieldForm.swift
//  GTForms
//
//  Created by Giorgos Tsiapaliokas on 18/05/16.
//  Copyright © 2016 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit

/**
    If the form has a custom textField which comforts to this
    protocol, then errorDidOccur will be called when a validation error occurs.
 */
public protocol FormTextFieldErrorDelegate {
    func errorDidOccur()
}

public class BaseTextFieldForm<T: UITextField, L: UILabel, V>:
    BaseResultForm<V>,
    FormTextFieldViewType
{
    let textFieldView = TextFieldView<T, L>()

    var textFieldViewType: TextFieldViewType {
        return self.textFieldView
    }

    public var formAxis: FormAxis {
        set(newValue) { self.textFieldView.formAxis = newValue }
        get { return self.textFieldView.formAxis }
    }

    public var textField: UITextField {
        return self.textFieldView.textField
    }

    public override func formView() -> UIView {
        return self.textFieldView
    }

    func errorDidOccur() {
        if let
            delegate = self.textFieldView.textField as? FormTextFieldErrorDelegate
        {
            delegate.errorDidOccur()
        }
    }
}
