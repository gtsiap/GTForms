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

public class FormTableViewController: UITableViewController {
    private var tableViewController: TableViewController!

    public var formSections: [FormSection] {
        set(newValue) {
            self.tableViewController.formSections = newValue
        }

        get {
            return self.tableViewController.formSections
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.tableViewController = TableViewController(tableViewType: self, viewController: self)
    }

    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        self.tableViewController.registerNotifications()
    }

    public override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.tableViewController.unRegisterNotifications()
    }

    public func registerCustomForm(customForm: CustomForm) {
        self.tableViewController.registerCustomForm(customForm)
    }

    // MARK: - Table view data source
    
    override public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.tableViewController.numberOfSectionsInTableView(tableView)
    }
    
    override public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableViewController.tableView(tableView, numberOfRowsInSection: section)
    }
    
    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return self.tableViewController.tableView(tableView, cellForRowAtIndexPath: indexPath)
    }
    
    // MARK: tableview
    
    public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableViewController.tableView(tableView, didSelectRowAtIndexPath: indexPath)
    }

    public override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return self.tableViewController.tableView(tableView, shouldHighlightRowAtIndexPath: indexPath)
    }
    
    public override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.tableViewController.tableView(tableView, titleForHeaderInSection: section)
    }

    public func hideKeyboard() {
        self.tableViewController.hideKeyboard()
    }
}

extension FormTableViewController: TableViewType {
}
