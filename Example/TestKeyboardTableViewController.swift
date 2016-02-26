//
//  TestKeyboardTableViewController.swift
//  Example
//
//  Created by Giorgos Tsiapaliokas on 26/02/16.
//  Copyright © 2016 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit
import GTForms

class TestKeyboardTableViewController: FormTableViewController {
    private lazy var hideKeyboardButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            title: "Hide Keyboard",
            style: .Done,
            target: self,
            action: Selector("didTapHideKeyboardButton")
        )

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = self.hideKeyboardButton

        let selectionItems = [
            SelectionFormItem(text: "Apple"),
            SelectionFormItem(text: "Orange")
        ]

        let selectionForm = SelectionForm(
            items: selectionItems,
            text: "Choose a fruit"
        )

        selectionForm.textColor = UIColor.redColor()
        selectionForm.textFont = UIFont
            .preferredFontForTextStyle(UIFontTextStyleHeadline)

        selectionForm.allowsMultipleSelection = true

        let section = FormSection()
        section.addRow(selectionForm)

        section.addRow(FormDatePicker(text: "Date Picker"))
        section.addRow(FormDoubleTextField(
            text: "Double Form",
            placeHolder: "Type a double")
        )

        self.formSections.append(section)
    }

    @objc private func didTapHideKeyboardButton() {
        hideKeyboard()
    }
    
}
