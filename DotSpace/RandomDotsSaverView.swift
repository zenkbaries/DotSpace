//
//  RandomDotsSaverView.swift
//  DotSpace
//
//  Created by John Towery on 5/10/23.
//

import Cocoa
import ScreenSaver
import QuartzCore

class RandomDotsSaverView: ScreenSaverView {
    private var timer: Timer?

    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.black.cgColor
        startAnimation()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.black.cgColor
        startAnimation()
    }

    private func createDot(at position: CGPoint) {
        let dotLayer = CALayer()
        dotLayer.bounds = CGRect(x: 0, y: 0, width: 10, height: 10)
        dotLayer.position = position
        dotLayer.cornerRadius = 5
        dotLayer.backgroundColor = NSColor.white.cgColor
        self.layer?.addSublayer(dotLayer)

        let fadeOutAnimation = CABasicAnimation(keyPath: "opacity")
        fadeOutAnimation.fromValue = 1.0
        fadeOutAnimation.toValue = 0.0
        fadeOutAnimation.duration = 5
        fadeOutAnimation.fillMode = .forwards
        fadeOutAnimation.isRemovedOnCompletion = false
        fadeOutAnimation.delegate = self
        dotLayer.add(fadeOutAnimation, forKey: "opacityAnimation")

        let moveAnimation = CABasicAnimation(keyPath: "position")
        moveAnimation.fromValue = position
        moveAnimation.toValue = NSValue(point: CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2))
        moveAnimation.duration = 5
        moveAnimation.fillMode = .forwards
        moveAnimation.isRemovedOnCompletion = false
        dotLayer.add(moveAnimation, forKey: "moveAnimation")

        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 1.0
        scaleAnimation.toValue = 0.0
        scaleAnimation.duration = 5
        scaleAnimation.fillMode = .forwards
        scaleAnimation.isRemovedOnCompletion = false
        dotLayer.add(scaleAnimation, forKey: "scaleAnimation")
    }

    override func startAnimation() {
        super.startAnimation()
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let randomX = CGFloat.random(in: 0..<self.bounds.width)
            let randomY = CGFloat.random(in: 0..<self.bounds.height)
            self.createDot(at: CGPoint(x: randomX, y: randomY))
        }
    }

    override func stopAnimation() {
        super.stopAnimation()
        timer?.invalidate()
        timer = nil
    }
}

extension RandomDotsSaverView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let dotLayer = anim.value(forKey: "dotLayer") as? CALayer {
            dotLayer.removeFromSuperlayer()
        }
    }
}

