//
//  FormTableViewController.swift
//  GTForms
//
//  Created by Giorgos Tsiapaliokas on 15/12/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

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
        
        if let staticForm = cellRow.formView as? StaticForm {
            cell = tableView.dequeueReusableCellWithIdentifier("ReadOnlyCell", forIndexPath: indexPath)
            cell.textLabel?.text = staticForm.text
            cell.detailTextLabel?.text = staticForm.detailText
        } else {
            let formCell = tableView
                .dequeueReusableCellWithIdentifier("formCell", forIndexPath: indexPath)
                as! FormTableViewCell
            
            formCell.formRow = cellRow
            cell = formCell
        }
        
        cell.accessoryType = cellRow.accessoryType
        
        return cell
    }
    
    // MARK: tableview
    
    public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.formSections[indexPath.section].rows[indexPath.row].didSelectRow?()
    }
    
    public override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let cellRow = self.formSections[indexPath.section].rows[indexPath.row]
        
        if let
            _ = cellRow.formView as? StaticForm,
            _ = cellRow.didSelectRow
        {
            return true
        }
        
        return false
    }
    
    public override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.formSections[section].title
    }
    
}
