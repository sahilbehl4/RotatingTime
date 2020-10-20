//
//  StringExtensions.swift
//  RotatingTime
//
//  Created by Sahil Behl on 2020-10-19.
//  Copyright © 2020 sahil. All rights reserved.
//

import Foundation

extension String {
    var timeFromDate: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"
        guard let date = dateFormatter.date(from: self) else {
            return nil
        }
        
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter.string(from: date)
    }
}
