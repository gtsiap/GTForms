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
import GTForms

class DatePickersTableViewController: FormTableViewController {

    private lazy var dateForm: FormDatePicker = {
        let dateForm = FormDatePicker(text: "Date")
        dateForm.datePicker.datePickerMode = .Date
        dateForm.formAxis = .Vertical
        dateForm.customCellIdentifier = "customDatePickerCell"

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

    private lazy var timeForm: FormDatePicker<UILabel> = {
        let timeForm = FormDatePicker(text: "Time")
        timeForm.datePicker.datePickerMode = .Time
        timeForm.datePicker.minimumDate = NSDate()
        timeForm.dateFormatter = self.timeFormatter
        return timeForm
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.registerClass(
            FormDatePickerCustomCell.self,
            forCellReuseIdentifier: "customDatePickerCell"
        )

        let section = FormSection()
        section.addRow(self.dateForm)
        section.addRow(self.timeForm)

        section.title = "Date and Time Picker"

        self.formSections.append(section)

        let section2 = FormSection()
        section2.addRow(FormDatePicker(text: "Demo"))
        self.formSections.append(section2)
    }

}

class FormDatePickerCustomCell: FormTableViewCell {
    private var cellView: UIView!

    override func configureCell() {
        super.configureCell()

        guard let
            formRow = self.formRow,
            formView = formRow.form as? FormViewableType
            else { return }

        if let _ = self.cellView {
            // if the cellView exists
            // then configureCell has been
            // called for a second time
            // so let's remove the old view
            self.cellView.removeFromSuperview()
        }

        self.cellView = formView.formView()

        self.contentView.addSubview(self.cellView)
        self.cellView.translatesAutoresizingMaskIntoConstraints = false

        let borderView = UIView()
        borderView.translatesAutoresizingMaskIntoConstraints = false
        borderView.layer.borderColor = UIColor.blackColor().CGColor
        borderView.layer.borderWidth = 1

        self.contentView.addSubview(borderView)

        borderView.snp_makeConstraints() { make in
            make.top.leading.equalTo(self.contentView).offset(5)
            make.bottom.trailing.equalTo(self.contentView).offset(-5)
        }

        self.contentView.addSubview(self.cellView)
        self.cellView.snp_makeConstraints() { make in
            make.top.leading.equalTo(borderView).offset(5)
            make.bottom.trailing.equalTo(borderView).offset(-5)
        }
    }
}

