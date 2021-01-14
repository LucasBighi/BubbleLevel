//
//  ViewController.swift
//  BubbleLevel
//
//  Created by Lucas Bighi on 14/01/21.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    lazy var bubbleView: UIView = {
        let bubbleWidth = view.bounds.width - 200
        let bubbleView = UIView(frame: CGRect(x: view.frame.midX - bubbleWidth / 2,
                                              y: view.frame.midY - bubbleWidth / 2,
                                              width: bubbleWidth,
                                              height: bubbleWidth))
        bubbleView.layer.cornerRadius = bubbleWidth / 2
        bubbleView.backgroundColor = .red
        self.view.addSubview(bubbleView)
        return bubbleView
    }()

    private var motionManager: CMMotionManager!
    private var bubbleCenter: CGPoint!
    private var newBubbleCenter: CGPoint!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        motionManager.accelerometerUpdateInterval = 0.01
        if let currentOperationQueue = OperationQueue.current {
            motionManager.startAccelerometerUpdates(to: currentOperationQueue) { data, _ in
                if let data = data
                {
                    print(data)

                    self.newBubbleCenter.x = (CGFloat(data.acceleration.x) * 100)
                    self.newBubbleCenter.y = (CGFloat(data.acceleration.y) * -100)

                    if abs(self.newBubbleCenter.x) + abs(self.newBubbleCenter.y) < 1.0 {
                        self.newBubbleCenter = .zero
                    }

                    self.bubbleCenter = CGPoint(x: self.bubbleCenter.x + self.newBubbleCenter.x, y: self.bubbleCenter.y + self.newBubbleCenter.y)

                    self.bubbleCenter.x = max(self.bubbleView.frame.size.width * 0.5, min(self.bubbleCenter.x, self.view.bounds.width - self.bubbleView.frame.size.width * 0.5))
                    self.bubbleCenter.y = max(self.bubbleView.frame.size.height * 0.5, min(self.bubbleCenter.y, self.view.bounds.height - self.bubbleView.frame.size.height * 0.5))

                    self.bubbleView.center = self.bubbleCenter
                    if (self.bubbleCenter.x - self.view.center.x) <= 5,
                       (self.bubbleCenter.y - self.view.center.y) <= 5 {
                        self.bubbleView.backgroundColor = .green
                    } else {
                        self.bubbleView.backgroundColor = .red
                    }

                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        motionManager = CMMotionManager()
        bubbleCenter = bubbleView.center
        newBubbleCenter = bubbleView.center
        
        let mainCircleWidth = view.bounds.width - 190
        let mainCircleView = UIView(frame: CGRect(x: view.frame.midX - mainCircleWidth / 2,
                                              y: view.frame.midY - mainCircleWidth / 2,
                                              width: mainCircleWidth,
                                              height: mainCircleWidth))
        mainCircleView.backgroundColor = .clear
        mainCircleView.layer.cornerRadius = mainCircleWidth / 2
        mainCircleView.layer.borderWidth = 5
        mainCircleView.layer.borderColor = UIColor.white.cgColor
        mainCircleView.layer.zPosition = -1
        view.addSubview(mainCircleView)
    }
}
