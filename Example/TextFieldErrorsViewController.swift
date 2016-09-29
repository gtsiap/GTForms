//
//  ΤextFieldErrorsViewController.swift
//  Example
//
//  Created by Giorgos Tsiapaliokas on 24/05/16.
//  Copyright © 2016 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit
import GTForms
import SnapKit

class TextFieldErrorsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let tableView = FormTableView(style: .grouped, viewController: self)


        self.view.addSubview(tableView)
        tableView.snp.makeConstraints() { make in
            make.top.equalTo(self.topLayoutGuide.snp.bottom)
            make.leading.trailing.equalTo(self.view)
            make.bottom.equalTo(self.bottomLayoutGuide.snp.top)
        }

        let section = FormSection()
        let intForm = FormIntTextField(text: "Int", placeHolder: "Min is 2 and Max is 10")
        intForm.minimumValue = 2
        intForm.maximumValue = 10
        intForm.descriptionValueErrorDelegate = self

        section.addRow(intForm)

        let doubleForm = FormDoubleTextField(text: "Double", placeHolder: "Min is 2 and Max is 10")
        doubleForm.minimumValue = 2
        doubleForm.maximumValue = 10
        doubleForm.descriptionValueErrorDelegate = self

        section.addRow(doubleForm)

        let textForm = FormTextField(text: "String", placeHolder: "Min length is 2 and Max length is 5")
        textForm.minimumLength = 2
        textForm.maximumLength = 5
        textForm.descriptionLengthErrorDelegate = self

        section.addRow(textForm)

        tableView.formSections.append(section)
    }

}

extension TextFieldErrorsViewController: FormTextFieldValueRangeErrorDescriptionDelegate {
    func minimumValueErrorDescription(_ value: Any, formText: String) -> String? {
        return "Custom Error: \(value) for \(formText) is too small"
    }

    func maximumValueErrorDescription(_ value: Any, formText: String) -> String? {
        return "Custom Error: \(value) for \(formText) is too big"
    }
}

extension TextFieldErrorsViewController: FormTextFieldValueLengthErrorDescriptionDelegate {
    func minimumLengthErrorDescription(_ value: Any, formText: String) -> String? {
        return "Min Length: \(value):\(formText)"
    }

    func maximumLengthErrorDescription(_ value: Any, formText: String) -> String? {
        return "Max Length: \(value):\(formText)"
    }
}
