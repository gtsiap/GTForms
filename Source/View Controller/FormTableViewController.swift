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

public class FormTableViewController: UITableViewController {

    private var datePickerHelper = DatePickerHelper()

    private var textFieldViews = [TextFieldView]()
    
    public var formSections: [FormSection] = [FormSection]() {
        didSet {
            findTextFieldViews()
            self.tableView.reloadData()
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 50
        self.tableView.rowHeight = UITableViewAutomaticDimension

        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "ReadOnlyCell")
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "SelectionCell")
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "SelectionItemCell")
        self.tableView.registerClass(FormTableViewCell.self, forCellReuseIdentifier: "formCell")
        self.tableView.registerClass(DatePickerTableViewCell.self, forCellReuseIdentifier: "DatePickerCell")

        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "keyboardWillAppear",
            name: UIKeyboardWillShowNotification,
            object: nil
        )
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    // MARK: - Table view data source
    
    override public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.formSections.count
    }
    
    override public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.formSections[section].formItemsForSection().count
    }
    
    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell

        let cellItem = self.formSections[indexPath.section].formItemsForSection()[indexPath.row]

        if let selectionItem = cellItem as? SelectionFormItem {
            cell = tableView.dequeueReusableCellWithIdentifier("SelectionItemCell", forIndexPath: indexPath)
            cell.textLabel?.text = selectionItem.text
            cell.detailTextLabel?.text = selectionItem.detailText
            cell.selectionStyle = .None
            cell.accessoryType = selectionItem.selected ? selectionItem.accessoryType : .None
            return cell
        } else if let datePicker = cellItem as? UIDatePicker {
            guard let
                datePickerCell = tableView.dequeueReusableCellWithIdentifier(
                    "DatePickerCell",
                    forIndexPath: indexPath
                ) as? DatePickerTableViewCell
            else { return UITableViewCell() }

            datePickerCell.datePicker = datePicker
            return datePickerCell
        }

        guard let cellRow = cellItem as? FormRow else { return UITableViewCell() }
        
        if let staticForm = cellRow.form as? StaticForm {
            cell = tableView.dequeueReusableCellWithIdentifier("ReadOnlyCell", forIndexPath: indexPath)
            cell.textLabel?.text = staticForm.text
            cell.detailTextLabel?.text = staticForm.detailText
        } else if let selectionForm = cellRow.form as? SelectionForm {
            cell = tableView.dequeueReusableCellWithIdentifier("SelectionCell", forIndexPath: indexPath)
            cell.textLabel?.text = selectionForm.text
            cell.detailTextLabel?.text = selectionForm.detailText

            if let textColor = selectionForm.textColor {
                cell.textLabel?.textColor = textColor
            }

            if let textFont = selectionForm.textFont {
                cell.textLabel?.font = textFont
            }

            if let detailTextColor = selectionForm.detailTextColor {
                cell.detailTextLabel?.textColor = detailTextColor
            }

            if let detailTextFont = selectionForm.detailTextFont {
                cell.textLabel?.font = detailTextFont
            }

            cell.selectionStyle = .None
        } else {
            let formCell = FormTableViewCell()
            if let formViewableCell = cellRow.form as? FormViewableType {
                formViewableCell.viewController = self
            }
            
            formCell.formRow = cellRow
            cell = formCell
        }

        cell.accessoryType = cellRow.accessoryType
        cell.selectionStyle = .None

        return cell
    }
    
    // MARK: tableview
    
    public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cellItems = self.formSections[indexPath.section].formItemsForSection()

        SelectionFormHelper.handleAccessory(
            cellItems,
            tableView: self.tableView,
            indexPath: indexPath
        )

        guard let formRow = cellItems[indexPath.row] as? FormRow else { return }
        formRow.didSelectRow?()

        SelectionFormHelper.toggleItems(
            formRow,
            tableView: self.tableView,
            indexPath: indexPath
        )

        guard let
            datePickerForm = formRow.form as? FormDatePicker
        else { return }
        self.datePickerHelper.currentSelectedDatePickerForm = datePickerForm

        self.datePickerHelper.removeAllDatePickers(self)

        hideKeyboard()

        self.datePickerHelper.showDatePicker(
            self.tableView,
            cellItems: self.formSections[indexPath.section].formItemsForSection()
        )
    }

    public override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let cellItem = self.formSections[indexPath.section].formItemsForSection()[indexPath.row]

        if let _ = cellItem as? SelectionFormItem {
            return true
        }

        guard let cellRow = cellItem as? FormRow
        else { return false }

        if let
            _ = cellRow.form as? StaticForm,
            _ = cellRow.didSelectRow
        {
            return true
        } else if let selectionForm = cellRow.form as? SelectionForm
        {
            return !selectionForm.shouldAlwaysShowAllItems ? true : false
        } else if let _ = cellRow.form as? FormDatePicker {
            return true
        }
        
        return false
    }
    
    public override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.formSections[section].title
    }

    public  func hideKeyboard() {
        self.textFieldViews.forEach() {
            if $0.textField.isFirstResponder() {
                $0.textField.resignFirstResponder()
            }
        }
    }

    private func findTextFieldViews() {
        self.textFieldViews.removeAll()
        for section in self.formSections {
            for row in section.rows {
                if let form = row.form as? FormDoubleTextField {
                    self.textFieldViews.append(form.textFieldView)
                } else if let form = row.form as? FormIntTextField {
                    self.textFieldViews.append(form.textFieldView)
                } else if let form = row.form as? BaseStringTextFieldForm {
                    self.textFieldViews.append(form.textFieldView)
                }
            } // end for
        } // end for

        self.textFieldViews.forEach() { $0.delegate = self }
    }

    @objc private func keyboardWillAppear() {
        let datePicker = self.datePickerHelper.currentSelectedDatePickerForm
        self.datePickerHelper.currentSelectedDatePickerForm = nil
        self.datePickerHelper.removeAllDatePickers(self)
        self.datePickerHelper.currentSelectedDatePickerForm = datePicker
    }
}

extension FormTableViewController: TextFieldViewDelegate {
    func textFieldViewShouldReturn(textFieldView: TextFieldView) -> Bool {

        guard let
            index = self.textFieldViews.indexOf(textFieldView)
        else { return false }

        if (self.textFieldViews.count - 1) == index {
            return false
        }
        
        let nextTextFieldView = self.textFieldViews[index + 1]
        return nextTextFieldView.textField.becomeFirstResponder()
    }


}
