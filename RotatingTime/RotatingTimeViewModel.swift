//
//  ViewModel.swift
//  RotatingTime
//
//  Created by Sahil Behl on 2020-10-19.
//  Copyright © 2020 sahil. All rights reserved.
//

import Foundation

class RotatingTimeViewModel {
    // MARK: - Properties
    
    private let dateTimeService = DateTimeService.shared
    weak var delegate: RotatingTimeViewModelDelegate?
    private var timer: Timer?
    
    // MARK: - Configure
    
    func configure() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(performTasks), userInfo: nil, repeats: true)
    }
    
    deinit {
        timer?.invalidate()
    }
    
    @objc func performTasks() {
        getTime()
    }
    
    private func getTime() {
        dateTimeService.getDateTime(failure: { error in
            // TODO: - Error Handling
            print("Error\(error)")
        }, success: { [weak self] dateTime in
            if let time = dateTime.datetime?.timeFromDate {
                self?.delegate?.updateTime(with: time)
            }
        })
    }
}

protocol RotatingTimeViewModelDelegate: class {
    func updateTime(with string: String)
}
