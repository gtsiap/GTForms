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

class ExampleSelectionCustomizedFormCell: SelectionCustomizedFormCell {
    fileprivate let label = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(label)
        self.label.snp.makeConstraints() { make in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(10, 10, 10, 10))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func configure(_ text: String, detailText: String?) {
        self.label.text = text
        self.contentView.backgroundColor = UIColor.red
    }
}

class ExampleSelectionCustomizedFormItemCell: SelectionCustomizedFormItemCell {

    fileprivate let label = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(label)
        self.label.snp.makeConstraints() { make in
            make.edges.equalTo(self.contentView).inset(UIEdgeInsetsMake(10, 10, 10, 10))
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func configure(_ text: String, detailText: String?, isSelected: Bool) {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        self.contentView.addSubview(label)
        label.snp.makeConstraints() { make in
            make.edges.equalTo(self.contentView).inset(UIEdgeInsetsMake(10, 10, 10, 10))
        }

        self.contentView.backgroundColor = isSelected ? UIColor.yellow : UIColor.white
    }

    override func didSelect() {
        self.contentView.backgroundColor = UIColor.yellow
    }

    override func didDeSelect() {
        self.contentView.backgroundColor = UIColor.white
    }
}

class SelectionFormTableViewController: FormTableViewController {

    var selectionForm: SelectionForm!

    override func viewDidLoad() {
        super.viewDidLoad()

        let selectionItems = [
            SelectionFormItem(text: "Apple"),
            SelectionFormItem(text: "Orange")
        ]

        selectionForm = SelectionForm(
            items: selectionItems,
            text: "Choose a fruit"
        )

        selectionForm.textColor = UIColor.red
        selectionForm.textFont = UIFont
            .preferredFont(forTextStyle: UIFontTextStyle.headline)

        selectionForm.allowsMultipleSelection = true

        let section = FormSection()
        section.addRow(selectionForm)
        self.formSections.append(section)


        
        let selectionItems2 = [
            SelectionFormItem(text: "vim"),
            SelectionFormItem(text: "emacs")
        ]

        let selectionForm2 = SelectionForm(
            items: selectionItems2,
            text: "Choose an editor"
        )

        selectionForm2.allowsMultipleSelection = false
        selectionForm2.shouldAlwaysShowAllItems = true

        selectionForm2.didSelectItem = { item in
            print("Did Select: \(item.text)")
        }

        selectionForm2.didDeselectItem = { item in
            print("Did Deselect: \(item.text)")
        }

        let section2 = FormSection()
        section2.addRow(selectionForm2)
        self.formSections.append(section2)



        let selectionItems3 = [
            SelectionCustomizedFormItem(text: "customized vim", cellReuseIdentifier: "selectionCustomizedCellItem"),
            SelectionCustomizedFormItem(text: "customized emacs", cellReuseIdentifier: "selectionCustomizedCellItem"),
            SelectionCustomizedFormItem(text: "customized atom", cellReuseIdentifier: "selectionCustomizedCellItem")
        ]

        let selectionForm3 = SelectionCustomizedForm(
            items: selectionItems3,
            text: "Choose an editor (customized)",
            cellReuseIdentifier: "selectionCustomizedCell"
        )

        selectionForm3.allowsMultipleSelection = false

        self.tableView.register(
            ExampleSelectionCustomizedFormItemCell.self,
            forCellReuseIdentifier: "selectionCustomizedCellItem"
        )

        self.tableView.register(
            ExampleSelectionCustomizedFormCell.self,
            forCellReuseIdentifier: "selectionCustomizedCell"
        )

        let section3 = FormSection()
        section3.addRow(selectionForm3)
        self.formSections.append(section3)

        let selectionItems4 = [
            SelectionCustomizedFormItem(text: "Apple", cellReuseIdentifier: "selectionCustomizedCellItem"),
            SelectionCustomizedFormItem(text: "Orange", cellReuseIdentifier: "selectionCustomizedCellItem"),
            SelectionCustomizedFormItem(text: "Carrot", cellReuseIdentifier: "selectionCustomizedCellItem")
        ]

        let selectionForm4 = SelectionCustomizedForm(
            items: selectionItems4,
            text: "Choose a fruit (customized)",
            cellReuseIdentifier: "selectionCustomizedCell"
        )

        selectionForm4.shouldAlwaysShowAllItems = true

        let section4 = FormSection()
        section4.addRow(selectionForm4)
        self.formSections.append(section4)
    }

}
