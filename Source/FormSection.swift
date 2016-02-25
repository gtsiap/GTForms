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

public class FormSection {
    /**
        The rows of the section
     */
    private (set) var rows: [FormRow] = [FormRow]()
    
    /**
        The title of the section
     */
    public var title: String?
    
    public init() {}
    
    /**
        Adds a new row to the section from a FormViewable
     
        - parameter form: the form from which the new
                              row will be created
     */
    public func addRow(form: FormableType) -> FormRow {
        let row = FormRow(form: form)
        self.rows.append(row)
        return row
    }

    func formItemsForSection() -> [AnyObject] {
        var formRows = [AnyObject]()

        for row in self.rows {
            formRows.append(row)

            if let
                selectionForm = row.form as? SelectionForm,
                showItems = selectionForm.showItems
                where showItems
            {
                selectionForm.items.forEach() {
                    formRows.append($0)
                }
            } else if let
                selectionForm = row.form as? SelectionForm
                where selectionForm.shouldAlwaysShowAllItems
            {
                selectionForm.items.forEach() {
                    formRows.append($0)
                }
            }

            if let
                datePickerForm = row.form as? FormDatePicker,
                shouldExpand = datePickerForm.shouldExpand
                where shouldExpand
            {
                formRows.append(datePickerForm.datePickerView)
            }
        }

        return formRows
    }

}
