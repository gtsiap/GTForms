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

    func removeAllDatePickers(vc: FormTableViewController) {
        var indexPathsToDelete = [NSIndexPath]()

        for (sectionIndex, section) in vc.formSections.enumerate() {
            let rowCount = vc.tableView.numberOfRowsInSection(sectionIndex)
            for index in 0...rowCount - 1 {
                let cellIndexPath = NSIndexPath(
                    forRow: index + 1,
                    inSection: sectionIndex
                )

                let cellItems = section.formItemsForSection()
                
                if index >= cellItems.count {
                    continue
                }

                guard let
                    otherFormRow = cellItems[index]
                        as? FormRow,
                    otherDatePickerForm = otherFormRow.form
                        as? FormDatePicker,
                    datePickerCell = vc.tableView.cellForRowAtIndexPath(cellIndexPath)
                        as? DatePickerTableViewCell
                    where
                        datePickerCell.datePicker === otherDatePickerForm.datePicker &&
                        self.currentSelectedDatePickerForm !== otherDatePickerForm
                    else { continue }

                otherDatePickerForm.shouldExpand = false
                indexPathsToDelete.append(cellIndexPath)
            }
        }

        vc.tableView.beginUpdates()
        vc.tableView.deleteRowsAtIndexPaths(indexPathsToDelete, withRowAnimation: .Top)
        vc.tableView.endUpdates()
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
                    selectedIndexPath = tableView.indexPathForSelectedRow
                where
                    selectedIndexPath.row == index &&
                    selectedIndexPath.section == section
                else {
                    continue
                }

                guard let
                    otherFormRow = cellItems[index]
                        as? FormRow,
                    otherDatePickerForm = otherFormRow.form
                        as? FormDatePicker
                where self.currentSelectedDatePickerForm === otherDatePickerForm
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
                    tableView.insertRowsAtIndexPaths([cellIndexPath], withRowAnimation: .Top)
                } else {
                    tableView.deleteRowsAtIndexPaths([cellIndexPath], withRowAnimation: .Top)
                    self.currentSelectedDatePickerForm.shouldExpand = false
                }
            }
        }
    }
}
