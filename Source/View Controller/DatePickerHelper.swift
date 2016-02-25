//
//  DatePickerHelper.swift
//  GTForms
//
//  Created by Giorgos Tsiapaliokas on 25/02/16.
//  Copyright © 2016 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit
class DatePickerHelper {

    init() {}

    var currentSelectedDatePickerForm: FormDatePicker!

    func removeAllDatePickers(tableView: UITableView, cellItems: [AnyObject]) {
        var indexPathsToDelete = [NSIndexPath]()

        for section in 0...tableView.numberOfSections - 1 {
            let rowCount = tableView.numberOfRowsInSection(section)
            for index in 0...rowCount - 1 {
                let cellIndexPath = NSIndexPath(
                    forRow: index + 1,
                    inSection: section
                )

                guard let
                    otherFormRow = cellItems[index]
                        as? FormRow,
                    otherDatePickerForm = otherFormRow.form
                        as? FormDatePicker,
                    datePickerCell = tableView.cellForRowAtIndexPath(cellIndexPath)
                        as? DatePickerTableViewCell
                    where
                    datePickerCell.datePicker === otherDatePickerForm.datePicker &&
                        self.currentSelectedDatePickerForm !== otherDatePickerForm
                    else { continue }


                otherDatePickerForm.shouldExpand = false
                indexPathsToDelete.append(cellIndexPath)
            }

            tableView.beginUpdates()
            tableView.deleteRowsAtIndexPaths(indexPathsToDelete, withRowAnimation: .Top)
            tableView.endUpdates()
        }
    }

    func showDatePicker(tableView: UITableView, cellItems: [AnyObject]) {

        for section in 0...tableView.numberOfSections - 1 {
            let rowCount = tableView.numberOfRowsInSection(section)
            for index in 0...rowCount - 1 {
                let cellIndexPath = NSIndexPath(
                    forRow: index + 1,
                    inSection: section
                )

                guard let
                    otherFormRow = cellItems[index]
                        as? FormRow,
                    otherDatePickerForm = otherFormRow.form
                        as? FormDatePicker
                    where self.currentSelectedDatePickerForm === otherDatePickerForm
                    else { continue }

                tableView.beginUpdates()
                defer { tableView.endUpdates() }

                guard let shouldExpand = self.currentSelectedDatePickerForm.shouldExpand else {
                    self.currentSelectedDatePickerForm.shouldExpand = true
                    tableView.insertRowsAtIndexPaths([cellIndexPath], withRowAnimation: .Top)
                    return
                }

                if !shouldExpand {
                    self.currentSelectedDatePickerForm.shouldExpand = true
                    tableView.insertRowsAtIndexPaths([cellIndexPath], withRowAnimation: .Top)
                } else {
                    tableView.deleteRowsAtIndexPaths([cellIndexPath], withRowAnimation: .Top)
                    self.currentSelectedDatePickerForm.shouldExpand = false
                }
            }
        }
    }
}
