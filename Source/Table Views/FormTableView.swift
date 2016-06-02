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

public class FormTableView: UITableView, TableViewType {
    private var tableViewController: TableViewController!
    private var didMofidyTableViewForKeyboard = false

    public var formSections: [FormSection] {
        set(newValue) {
            self.tableViewController.formSections = newValue
        }

        get {
            return self.tableViewController.formSections
        }
    }

    var tableView: UITableView! {
        return self
    }

    public init(style: UITableViewStyle) {
        super.init(frame: CGRectZero, style: style)
        self.tableViewController = TableViewController(tableViewType: self)
        commonInit()
    }

    public init(style: UITableViewStyle, viewController: UIViewController) {
        super.init(frame: CGRectZero, style: style)
        self.tableViewController = TableViewController(
            tableViewType: self,
            viewController:  viewController
        )
        commonInit()
    }

    deinit {
        self.tableViewController.unRegisterNotifications()
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func registerCustomForm(customForm: CustomForm) {
        self.tableViewController.registerCustomForm(customForm)
    }

    private func commonInit() {
        self.tableViewController.registerNotifications()
        self.delegate = self.tableViewController
        self.dataSource = self.tableViewController

        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(keyboardWillAppear),
            name: UIKeyboardWillShowNotification,
            object: nil
        )

        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIKeyboardWillHideNotification,
            object: nil
        )
    }

    @objc private func keyboardWillAppear(notification: NSNotification) {
        if self.didMofidyTableViewForKeyboard {
            return
        }

        guard let
            keyboardHeight = notification
                .userInfo?[UIKeyboardFrameEndUserInfoKey]?
                .CGRectValue().size.height
        else { return }

        let contentInsets = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: keyboardHeight,
            right: 0
        )

        self.contentInset = contentInsets
        self.scrollIndicatorInsets = contentInsets
        self.didMofidyTableViewForKeyboard = true
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsetsZero
        self.contentInset = contentInsets
        self.scrollIndicatorInsets = contentInsets
        self.didMofidyTableViewForKeyboard = false
    }
}
