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

class CustomTableViewController: SelectionFormTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        let myCustomForm = MyCustomForm(cellClass: CustomTableViewCell.self, reuseIdentifier: "foo")
        registerCustomForm(myCustomForm)

        self.selectionForm.didSelectItem = { _ in
            self.formSections[0].appendRow(myCustomForm, animation: .Fade)
        }

        self.selectionForm.didDeselectItem = { _ in
            self.formSections[0].removeRow(myCustomForm, animation: .Fade)
        }
    }
}

class MyCustomForm: CustomForm {
    override func configureCell(cell: UITableViewCell) {
    }
}

class CustomTableViewCell: UITableViewCell {

    private let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.borderColor = UIColor.grayColor().CGColor
        textView.layer.borderWidth = 1.0
        return textView
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.contentView.addSubview(self.textView)

        self.textView.snp_makeConstraints() { make in
            make.top.equalTo(self.contentView).offset(10)
            make.leading.equalTo(self.contentView).offset(10)
            make.trailing.equalTo(self.contentView).offset(-10)
            make.bottom.equalTo(self.contentView).offset(-10).priorityLow()
            make.height.equalTo(200)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}