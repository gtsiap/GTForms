// Copyright (c) 2015-2016 Giorgos Tsiapaliokas <giorgos.tsiapaliokas@mykolab.com>
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

class SelectionFormTableViewController: FormTableViewController {

    var selectionForm: SelectionForm!

    override func viewDidLoad() {
        super.viewDidLoad()

        let selectionItems = [
            SelectionFormItem(text: "Apple"),
            SelectionFormItem(text: "Orange")
        ]

        selectionForm = SelectionForm(
            items: selectionItems,
            text: "Choose a fruit"
        )

        selectionForm.textColor = UIColor.redColor()
        selectionForm.textFont = UIFont
            .preferredFontForTextStyle(UIFontTextStyleHeadline)

        selectionForm.allowsMultipleSelection = true

        let section = FormSection()
        section.addRow(selectionForm)
        self.formSections.append(section)


        
        let selectionItems2 = [
            SelectionFormItem(text: "vim"),
            SelectionFormItem(text: "emacs")
        ]

        let selectionForm2 = SelectionForm(
            items: selectionItems2,
            text: "Choose an editor"
        )

        selectionForm2.allowsMultipleSelection = false
        selectionForm2.shouldAlwaysShowAllItems = true

        selectionForm2.didSelectItem = { item in
            print("Did Select: \(item.text)")
        }

        selectionForm2.didDeselectItem = { item in
            print("Did Deselect: \(item.text)")
        }

        let section2 = FormSection()
        section2.addRow(selectionForm2)
        self.formSections.append(section2)

    }

}
