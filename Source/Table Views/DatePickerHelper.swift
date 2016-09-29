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
class DatePickerHelper {

    init() {}

    var currentSelectedDatePickerForm: FormDatePickerType!

    func removeAllDatePickers(_ tableViewType: TableViewType) {
        var indexPathsToDelete = [IndexPath]()

        for (sectionIndex, section) in tableViewType.formSections.enumerated() {
            let rowCount = tableViewType.tableView.numberOfRows(inSection: sectionIndex)
            for index in 0...rowCount - 1 {
                let cellIndexPath = IndexPath(
                    row: index + 1,
                    section: sectionIndex
                )

                let cellItems = section.formItemsForSection()
                
                if index >= cellItems.count {
                    continue
                }

                guard let
                    otherFormRow = cellItems[index]
                        as? FormRow,
                    let otherDatePickerForm = otherFormRow.form
                        as? FormDatePickerType,
                    let datePickerCell = tableViewType.tableView.cellForRow(at: cellIndexPath)
                        as? DatePickerTableViewCell
                    ,
                        datePickerCell.datePicker === otherDatePickerForm.datePicker &&
                        self.currentSelectedDatePickerForm !== otherDatePickerForm
                    else { continue }

                otherDatePickerForm.shouldExpand = false
                indexPathsToDelete.append(cellIndexPath)
            }
        }

        tableViewType.tableView.beginUpdates()
        tableViewType.tableView.deleteRows(at: indexPathsToDelete, with: .top)
        tableViewType.tableView.endUpdates()
    }

    func showDatePicker(_ tableView: UITableView, cellItems: [AnyObject]) {
        for section in 0...tableView.numberOfSections - 1 {
            let rowCount = tableView.numberOfRows(inSection: section)
            for index in 0...rowCount - 1 {
                let cellIndexPath = IndexPath(
                    row: index + 1,
                    section: section
                )

                guard let
                    selectedIndexPath = tableView.indexPathForSelectedRow
                ,
                    (selectedIndexPath as NSIndexPath).row == index &&
                    (selectedIndexPath as NSIndexPath).section == section
                else {
                    continue
                }

                guard let
                    otherFormRow = cellItems[index]
                        as? FormRow,
                    let otherDatePickerForm = otherFormRow.form
                        as? FormDatePickerType
                , self.currentSelectedDatePickerForm === otherDatePickerForm
                else { continue }


                tableView.beginUpdates()
                defer { tableView.endUpdates() }

                let shouldExpand: Bool
                if let expand = self.currentSelectedDatePickerForm.shouldExpand {
                    shouldExpand = !expand
                } else {
                    shouldExpand = true
                }

                if shouldExpand {
                    self.currentSelectedDatePickerForm.shouldExpand = true
                    tableView.insertRows(at: [cellIndexPath], with: .top)
                } else {
                    tableView.deleteRows(at: [cellIndexPath], with: .top)
                    self.currentSelectedDatePickerForm.shouldExpand = false
                }
            }
        }
    }
}
