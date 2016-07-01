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

class SelectionFormHelper {

    class func toggleItems(
        formRow: FormRow,
        tableView: UITableView,
        indexPath: NSIndexPath
    ) {
        if let selectionForm = formRow.form as? BaseSelectionForm
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

        guard let selectionItem = cellItem as? BaseSelectionFormItem else { return }

        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if selectionItem.selected {
            selectionItem.selected = false
            selectionItem.selectionForm?.didDeselectItem?(selectedItem: selectionItem)
            cell?.accessoryType = .None

            if let
                _ = selectionItem as? SelectionCustomizedFormItem,
                cell = cell as? SelectionCustomizedFormItemCell
            {
                cell.didDeSelect()
            }
        } else {
            defer {
                selectionItem.selected = true
                if let selectionItem = selectionItem as? SelectionFormItem {
                    cell?.accessoryType = selectionItem.accessoryType
                } else if let
                    _ = selectionItem as? SelectionCustomizedFormItem,
                    cell = cell as? SelectionCustomizedFormItemCell
                {
                    cell.didSelect()
                }
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

                if let otherSelectionItem = cellItems[index - 1] as? BaseSelectionFormItem
                    where otherSelectionItem.selectionForm === selectionItem.selectionForm
                {
                    otherSelectionItem.selected = false

                    if let _ = selectionItem as? SelectionFormItem {
                        let cell = tableView.cellForRowAtIndexPath(cellIndexPath)
                        cell?.accessoryType = .None
                    } else if let
                        _ = selectionItem as? SelectionCustomizedFormItem,
                        cell = cell as? SelectionCustomizedFormItemCell
                    {
                        cell.didDeSelect()
                    }
                }
            }
        }
    }
}
