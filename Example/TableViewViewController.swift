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
import SnapKit

private class _Label: UILabel { }
private class _TextField: UITextField { }

class TableViewViewController: UIViewController {
    fileprivate let tableView: FormTableView = {
        let t = FormTableView(style: .grouped)
        t.translatesAutoresizingMaskIntoConstraints = false
        return t
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.red
        self.view.addSubview(self.tableView)

        self.tableView.snp.makeConstraints() { make in
            make.center.equalTo(self.view)
            make.width.height.equalTo(self.view).multipliedBy(0.8)
        }

        let t = FormIntTextField<_TextField, _Label>(text: "Field 1", placeHolder: "PlaceHolder")
        t.formAxis = .vertical
        let t2 = FormIntTextField<_TextField, _Label>(text: "Field 2", placeHolder: "PlaceHolder")
        t2.formAxis = .vertical

        let d = FormDatePicker<_Label>(text: "Date")
        d.formAxis = .vertical

        let section = FormSection()
        section.addRow(t)
        section.addRow(t2)
        section.addRow(d)
        section.addRow(FormTextField<_TextField, _Label>(text: "Field 3", placeHolder: "PlaceHolder"))
        section.addRow(FormTextField<_TextField, _Label>(text: "Field 4", placeHolder: "PlaceHolder"))
        section.addRow(FormTextField<_TextField, _Label>(text: "Field 5", placeHolder: "PlaceHolder"))
        section.addRow(FormTextField<_TextField, _Label>(text: "Field 6", placeHolder: "PlaceHolder"))
        section.addRow(FormTextField<_TextField, _Label>(text: "Field 7", placeHolder: "PlaceHolder"))
        section.addRow(FormTextField<_TextField, _Label>(text: "Field 8", placeHolder: "PlaceHolder"))
        section.addRow(FormTextField<_TextField, _Label>(text: "Field 9", placeHolder: "PlaceHolder"))
        section.addRow(FormTextField<_TextField, _Label>(text: "Field 10", placeHolder: "PlaceHolder"))

        self.tableView.formSections.append(section)
    }

}
