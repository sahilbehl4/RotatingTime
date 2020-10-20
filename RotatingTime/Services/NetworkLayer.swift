//
//  NetworkLayer.swift
//  RotatingTime
//
//  Created by Sahil Behl on 2020-10-19.
//  Copyright © 2020 sahil. All rights reserved.
//

import Foundation

class NetworkLayer {
    class func getRequest(with url: URL, timeoutInterval: TimeInterval = 240, failure: ((Error) -> Void)?, success: ((Data) -> Void)?) {
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: timeoutInterval)
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
            if let error = error {
                failure?(error)
            }

            guard let data = data else {
                failure?(NSError(domain: "Invaid Data", code: 0, userInfo: nil))
                return
            }
            
            success?(data)
        }
        dataTask.resume()
    }
}
