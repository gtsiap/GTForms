//
//  DatePickersTableViewController.swift
//  Example
//
//  Created by Giorgos Tsiapaliokas on 24/02/16.
//  Copyright © 2016 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit
import GTForms

class DatePickersTableViewController: FormTableViewController {

    private lazy var dateForm: FormDatePicker = {
        let dateForm = FormDatePicker(text: "Date")
        dateForm.datePicker.datePickerMode = .Date

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateForm.dateFormatter = dateFormatter

        return dateForm
    }()

    let timeFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    private lazy var timeForm: FormDatePicker = {
        let timeForm = FormDatePicker(text: "Time")
        timeForm.datePicker.datePickerMode = .Time
        timeForm.datePicker.minimumDate = NSDate()
        timeForm.dateFormatter = self.timeFormatter
        return timeForm
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        let section = FormSection()
        section.addRow(self.dateForm)
        section.addRow(self.timeForm)
        section.addRow(FormDatePicker(text: "Demo"))


        section.title = "Date and Time Picker"

        self.formSections.append(section)
    }

}
