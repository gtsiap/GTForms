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
    
    public var formSections: [FormSection] = [FormSection]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 50
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "ReadOnlyCell")
        self.tableView.registerClass(FormTableViewCell.self, forCellReuseIdentifier: "formCell")
    }
    
    // MARK: - Table view data source
    
    override public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.formSections.count
    }
    
    override public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.formSections[section].rows.count
    }
    
    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        let cellRow = self.formSections[indexPath.section].rows[indexPath.row]
        
        if let staticForm = cellRow.form as? StaticForm {
            cell = tableView.dequeueReusableCellWithIdentifier("ReadOnlyCell", forIndexPath: indexPath)
            cell.textLabel?.text = staticForm.text
            cell.detailTextLabel?.text = staticForm.detailText
        } else {
            let formCell = FormTableViewCell()
            if let formViewableCell = cellRow.form as? FormViewableType {
                formViewableCell.viewController = self
            }
            
            formCell.formRow = cellRow
            cell = formCell
        }
        
        cell.accessoryType = cellRow.accessoryType
        
        return cell
    }
    
    // MARK: tableview
    
    public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.formSections[indexPath.section].rows[indexPath.row].didSelectRow?()
       
        guard let
            cell = tableView.cellForRowAtIndexPath(indexPath) as? FormTableViewCell,
            formRow = cell.formRow,
            expandable = formRow.form as? FormCellExpandable
        else { return }
        
        expandable.shouldExpand = !expandable.shouldExpand
        expandable.toogleExpand()
        tableView.beginUpdates()
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Bottom)
        tableView.endUpdates()

    }
    
    public override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let cellRow = self.formSections[indexPath.section].rows[indexPath.row]
        
        if let
            _ = cellRow.form as? StaticForm,
            _ = cellRow.didSelectRow
        {
            return true
        } else if let
            _ = cellRow.form as? FormCellExpandable
        {
            return true
        }
        
        return false
    }
    
    public override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.formSections[section].title
    }
    
}
