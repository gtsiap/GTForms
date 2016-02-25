//
//  SelectionFormHelper.swift
//  GTForms
//
//  Created by Giorgos Tsiapaliokas on 25/02/16.
//  Copyright © 2016 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit

class SelectionFormHelper {

    class func toggleItems(
        formRow: FormRow,
        tableView: UITableView,
        indexPath: NSIndexPath
    ) {
        if let selectionForm = formRow.form as? SelectionForm
            where !selectionForm.shouldAlwaysShowAllItems {
            var selectionIndexPaths = [NSIndexPath]()
            let rowIndex = indexPath.row
            let sectionIndex = indexPath.section

            for (index, _) in selectionForm.items.enumerate() {
            let targetIndexPath = NSIndexPath(
                forRow: rowIndex + index + 1,
                inSection: sectionIndex
            )
                selectionIndexPaths.append(targetIndexPath)
            }

            tableView.beginUpdates()

            if let showItems = selectionForm.showItems where showItems {
                tableView.deleteRowsAtIndexPaths(
                    selectionIndexPaths,
                    withRowAnimation: selectionForm.animation
                )
                selectionForm.showItems = false
            } else {
                tableView.insertRowsAtIndexPaths(
                    selectionIndexPaths,
                    withRowAnimation: selectionForm.animation
                )
                selectionForm.showItems = true
            }

            tableView.endUpdates()
        }
    }

    class func handleAccessory(
        cellItems: [AnyObject],
        tableView: UITableView,
        indexPath: NSIndexPath
    ) {
        let cellItem = cellItems[indexPath.row]

        guard let selectionItem = cellItem as? SelectionFormItem else { return }

        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if let accessoryType = cell?.accessoryType where accessoryType != .None {
            cell?.accessoryType = .None
            selectionItem.selected = false
            selectionItem.selectionForm?.didDeselectItem?(selectedItem: selectionItem)
        } else {
            defer {
                selectionItem.selected = true
                cell?.accessoryType = selectionItem.accessoryType
                selectionItem.selectionForm?.didSelectItem?(selectedItem: selectionItem)
            }

            if selectionItem.selectionForm?.allowsMultipleSelection ?? false {
                return
            }

            let rowCount = tableView.numberOfRowsInSection(indexPath.section)
            for index in 1...rowCount {
                let cellIndexPath = NSIndexPath(
                    forRow: index - 1,
                    inSection: indexPath.section
                )

                if let otherSelectionItem = cellItems[index - 1] as? SelectionFormItem
                    where otherSelectionItem.selectionForm === selectionItem.selectionForm
                {
                    otherSelectionItem.selected = false
                    let cell = tableView.cellForRowAtIndexPath(cellIndexPath)
                    cell?.accessoryType = .None
                }
            }
        }
    }
}
