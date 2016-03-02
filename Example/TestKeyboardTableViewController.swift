// Copyright (c) 2015 Giorgos Tsiapaliokas <giorgos.tsiapaliokas@mykolab.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

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
