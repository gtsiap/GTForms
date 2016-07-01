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

public class FormSection {
    weak var tableViewType: TableViewType?

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

    /**
        Appends a new row in the section
        - parameter form: The form that will be appended to the tableView
        - parameter animation: The UITableViewRowAnimation which will be used
     */
    public func appendRow(form: FormableType, animation: UITableViewRowAnimation) -> FormRow {
        let row = addRow(form)

        guard let
            tableViewType = self.tableViewType,
            tableView = tableViewType.tableView
        else {
            return row
        }

        tableView.beginUpdates()
        defer { tableView.endUpdates() }
        guard let
            section = tableViewType.formSections.indexOf({ $0 === self })
        else {
            return row
        }

        let indexPath = NSIndexPath(
            forRow: formItemsForSection().count - 1,
            inSection: section
        )

        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: animation)

        return row
    }

    /**
        Removes a new row from the section
        - parameter form: The form that will be removed from the tableView
        - parameter animation: The UITableViewRowAnimation which will be used
     */
    public func removeRow(form: FormableType, animation: UITableViewRowAnimation) {
        guard let
            tableViewType = self.tableViewType,
            tableView = tableViewType.tableView
        else {
            return
        }

        tableView.beginUpdates()
        defer { tableView.endUpdates() }

        guard let
            section = tableViewType.formSections.indexOf({ $0 === self })
        else {
            return
        }

        var row = -1

        for (index, item) in formItemsForSection().enumerate() {
            if let f = item as? FormRow where f.form === form {
                row = index
                break
            }
        }

        if row == -1 {
            return
        }

        var isSafeToDeleteRow = false
        for (index, it) in self.rows.enumerate() {
            if it.form === form {
                self.rows.removeAtIndex(index)
                isSafeToDeleteRow = true
                break
            }
        }

        if !isSafeToDeleteRow {
            return
        }

        let indexPath = NSIndexPath(
            forRow: row,
            inSection: section
        )

        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: animation)
    }


    /**
        Returns all the items in the section.
        It doesn't return the same number of items as the
        rows variable

        - returns: All the items of the section
     */
    func formItemsForSection() -> [AnyObject] {
        var formRows = [AnyObject]()

        for row in self.rows {
            formRows.append(row)

            if let
                selectionForm = row.form as? BaseSelectionForm,
                showItems = selectionForm.showItems
                where showItems
            {
                selectionForm.items.forEach() {
                    formRows.append($0)
                }
            } else if let
                selectionForm = row.form as? BaseSelectionForm
                where selectionForm.shouldAlwaysShowAllItems
            {
                selectionForm.items.forEach() {
                    formRows.append($0)
                }
            }

            if let
                datePickerForm = row.form as? FormDatePickerType,
                shouldExpand = datePickerForm.shouldExpand
                where shouldExpand
            {
                formRows.append(datePickerForm.datePicker)
            }
        }

        return formRows
    }

}
