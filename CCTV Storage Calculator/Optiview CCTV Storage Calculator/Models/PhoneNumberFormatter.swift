//
//  PhoneNumberFormatter.swift
//  CCTV Storage Calculator
//
//  Created by Thomas Dye on 4/29/20.
//  Copyright © 2020 Thomas Dye. All rights reserved.
//

import Foundation
import UIKit

func textField(_ textField: UITextField,
               shouldChangeCharactersIn range: NSRange,
               replacementString string: String) -> Bool {
    
    var fullString = textField.text ?? ""
    fullString.append(string)
    if range.length == 1 {
        textField.text = format(phoneNumber: fullString, shouldRemoveLastDigit: true)
    } else {
        textField.text = format(phoneNumber: fullString)
    }
    return false
}

func format(phoneNumber: String,
            shouldRemoveLastDigit: Bool = false) -> String {
    
    guard !phoneNumber.isEmpty else { return "" }
    guard let regex = try? NSRegularExpression(pattern: "[\\s-\\(\\)]",
                                               options: .caseInsensitive) else { return "" }
    
    let r = NSString(string: phoneNumber).range(of: phoneNumber)
    var number = regex.stringByReplacingMatches(in: phoneNumber,
                                                options: .init(rawValue: 0),
                                                range: r, withTemplate: "")

    if number.count > 10 {
        let tenthDigitIndex = number.index(number.startIndex,
                                           offsetBy: 10)
        number = String(number[number.startIndex..<tenthDigitIndex])
    }

    if shouldRemoveLastDigit {
        let end = number.index(number.startIndex,
                               offsetBy: number.count-1)
        number = String(number[number.startIndex..<end])
    }

    if number.count < 7 {
        let end = number.index(number.startIndex,
                               offsetBy: number.count)
        let range = number.startIndex..<end
        number = number.replacingOccurrences(of: "(\\d{3})(\\d+)",
                                             with: "($1) $2",
                                             options: .regularExpression,
                                             range: range)

    } else {
        let end = number.index(number.startIndex,
                               offsetBy: number.count)
        let range = number.startIndex..<end
        number = number.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)",
                                             with: "($1) $2-$3",
                                             options: .regularExpression,
                                             range: range)
    }

    return number
}
