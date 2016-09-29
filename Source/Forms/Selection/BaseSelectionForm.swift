// Copyright (c) 2016 Giorgos Tsiapaliokas <giorgos.tsiapaliokas@mykolab.com>
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

public class BaseSelectionForm: FormableType {

    /**
        The cell reuse identifier
     */
    public var cellReuseIdentifier = "SelectionCell"

    public let text: String
    public let detailText: String?

    public let items: [BaseSelectionFormItem]

    /**
        The animation that will be used for the
        insertions and the deletion of rows
     */
    let animation: UITableViewRowAnimation

    /**
        If true the items will always be visible
     */
    public var shouldAlwaysShowAllItems: Bool = false

    /**
        If true multiple items can be selected.
     */
    public var allowsMultipleSelection: Bool = true

    /**
        When an item gets selected this closure will be called
     */
    public var didSelectItem: ((_ selectedItem: BaseSelectionFormItem) -> ())?

    /**
        When an item gets deselected this closure will be called
     */
    public var didDeselectItem: ((_ selectedItem: BaseSelectionFormItem) -> ())?

    var showItems: Bool?

    public init(
        items: [BaseSelectionFormItem],
        text: String,
        detailText: String? = nil,
        animation: UITableViewRowAnimation = .top
    ) {
        self.text = text
        self.detailText = text
        self.items = items
        self.animation = animation

        self.items.forEach() {
            $0.selectionForm = self
        }
    }
    
}
