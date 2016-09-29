//
//  DatePickerTableViewCell.swift
//  GTForms
//
//  Created by Giorgos Tsiapaliokas on 23/02/16.
//  Copyright © 2016 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit

class DatePickerTableViewCell: UITableViewCell {

    var datePicker: UIDatePicker? {
        didSet {
            oldValue?.removeFromSuperview()
            configureCell()
        }
    }

    private func configureCell() {

        guard let
            datePicker = self.datePicker
        else { return }

        datePicker.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(datePicker)

        datePicker.snp.makeConstraints() { make in
            make.top.equalTo(self.contentView).offset(10)
            make.bottom.equalTo(self.contentView).offset(-10)
            make.leading.equalTo(self.contentView).offset(10)
            make.trailing.equalTo(self.contentView).offset(-10)
        }

    }

}
