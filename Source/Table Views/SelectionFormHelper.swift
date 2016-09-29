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
        _ formRow: FormRow,
        tableView: UITableView,
        indexPath: IndexPath
    ) {
        if let selectionForm = formRow.form as? BaseSelectionForm
            , !selectionForm.shouldAlwaysShowAllItems {
            var selectionIndexPaths = [IndexPath]()
            let rowIndex = (indexPath as NSIndexPath).row
            let sectionIndex = (indexPath as NSIndexPath).section

            for (index, _) in selectionForm.items.enumerated() {
                let targetIndexPath = IndexPath(
                    row: rowIndex + index + 1,
                    section: sectionIndex
                )
                selectionIndexPaths.append(targetIndexPath)
            }

            tableView.beginUpdates()

            if let showItems = selectionForm.showItems , showItems {
                tableView.deleteRows(
                    at: selectionIndexPaths,
                    with: selectionForm.animation
                )
                selectionForm.showItems = false
            } else {
                tableView.insertRows(
                    at: selectionIndexPaths,
                    with: selectionForm.animation
                )
                selectionForm.showItems = true
            }

            tableView.endUpdates()
        }
    }

    class func handleAccessory(
        _ cellItems: [AnyObject],
        tableView: UITableView,
        indexPath: IndexPath
    ) {
        let cellItem = cellItems[(indexPath as NSIndexPath).row]

        guard let selectionItem = cellItem as? BaseSelectionFormItem else { return }

        let cell = tableView.cellForRow(at: indexPath)
        if selectionItem.selected {
            selectionItem.selected = false
            selectionItem.selectionForm?.didDeselectItem?(selectionItem)
            cell?.accessoryType = .none

            if let
                _ = selectionItem as? SelectionCustomizedFormItem,
                let cell = cell as? SelectionCustomizedFormItemCell
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
                    let cell = cell as? SelectionCustomizedFormItemCell
                {
                    cell.didSelect()
                }
                selectionItem.selectionForm?.didSelectItem?(selectionItem)
            }

            if let
                allowsMultipleSelection = selectionItem.selectionForm?
                    .allowsMultipleSelection
                , allowsMultipleSelection
            {
                return
            }

            let rowCount = tableView.numberOfRows(inSection: (indexPath as NSIndexPath).section)
            for index in 1...rowCount {
                let cellIndexPath = IndexPath(
                    row: index - 1,
                    section: (indexPath as NSIndexPath).section
                )

                if let otherSelectionItem = cellItems[index - 1] as? BaseSelectionFormItem
                    , otherSelectionItem.selectionForm === selectionItem.selectionForm
                {
                    otherSelectionItem.selected = false
                    let cell = tableView.cellForRow(at: cellIndexPath)

                    if let _ = selectionItem as? SelectionFormItem {
                        cell?.accessoryType = .none
                    } else if let
                        _ = selectionItem as? SelectionCustomizedFormItem,
                        let cell = cell as? SelectionCustomizedFormItemCell
                    {
                        cell.didDeSelect()
                    }
                }
            }
        }
    }
}
