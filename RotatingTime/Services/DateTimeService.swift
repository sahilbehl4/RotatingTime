//
//  DateTimeService.swift
//  RotatingTime
//
//  Created by Sahil Behl on 2020-10-19.
//  Copyright © 2020 sahil. All rights reserved.
//

import Foundation

class DateTimeService {
    // MARK: - Singleton

    static let shared = DateTimeService()
    private init() {}

    // MARK: - Properties

    let url = URL(string: "https://dateandtimeasjson.appspot.com/")

    // MARK: - Get Date time

    func getDateTime(failure: ((Error) -> Void)?, success: ((DateTime) -> Void)?) {
        guard let url = url else {
            failure?(NSError(domain: "Invalid url", code: 0, userInfo: nil))
            return
        }
        NetworkLayer.getRequest(with: url, failure: failure, success: { data in
            do {
                let dateTime = try JSONDecoder().decode(DateTime.self, from: data)
                success?(dateTime)
            } catch let error {
                failure?(error)
            }
        })
    }
    
}
