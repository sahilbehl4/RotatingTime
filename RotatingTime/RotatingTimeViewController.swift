//
//  ViewController.swift
//  RotatingTime
//
//  Created by Sahil Behl on 2020-10-19.
//  Copyright © 2020 sahil. All rights reserved.
//

import UIKit

class RotatingTimeViewController: UIViewController {
    // MARK: - Properties
    
    private var initialTranslation = CGPoint(x: 0, y: 0)
    private var initialSquareViewCenter: CGPoint?
    private let viewModel = RotatingTimeViewModel()
        
    // MARK: - IBOutlets

    @IBOutlet weak var squareView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var squareViewCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var squareViewCenterYConstraint: NSLayoutConstraint!

    // MARK: - IBActions

    @IBAction func squareViewPanned(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: view)
        
        switch gestureRecognizer.state {
        case .began:
            animateBottomViewUp()
            break
        case .changed:
            dragSquareView(by: translation)
        case .ended:
            placeSquareView()
        default:
            dragSquareView(by: initialTranslation)
        }
    }
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.configure()
        rotateSquareView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initialSquareViewCenter = squareView.center
    }
    
    // MARK: - Helper Methods
    
    private func dragSquareView(by translation: CGPoint) {
        squareViewCenterXConstraint.constant = initialTranslation.x + translation.x
        squareViewCenterYConstraint.constant = initialTranslation.y + translation.y
    }
    
    private func placeSquareView() {
        let squareViewFrame = squareView.frame
        let squareViewArea = squareViewFrame.width * squareViewFrame.height
        let frameInsideBottomView = bottomView.frame.intersection(squareViewFrame)
        let areaInsideBottomView = frameInsideBottomView.width * frameInsideBottomView.height
        let inBottomView: Bool = areaInsideBottomView >= 0.25 * squareViewArea
        initialTranslation = inBottomView ? CGPoint(x: 0, y: bottomView.center.y - (initialSquareViewCenter?.y ?? 0.0)) : CGPoint(x: 0, y: 0)
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: { [weak self] in
            guard let self = self else { return }
            self.squareViewCenterYConstraint.constant = self.initialTranslation.y
            self.squareViewCenterXConstraint.constant = self.initialTranslation.x
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func animateBottomViewUp() {
        guard bottomViewBottomConstraint.constant != 0 else { return }
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: { [weak self] in
            guard let self = self else { return }
            self.bottomViewBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    private func rotateSquareView() {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * 2)
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.duration = 1
        rotateAnimation.repeatCount = Float.infinity
        self.squareView.layer.add(rotateAnimation, forKey: nil)
    }
}

extension RotatingTimeViewController: RotatingTimeViewModelDelegate {
    func updateTime(with string: String) {
        DispatchQueue.main.async { [weak self] in
            self?.timeLabel.text = string
        }
    }
}

