//
//  StrokedCircularImageView.swift
//  PoodleSurf
//
//  Created by Westin Newell on 4/9/19.
//  Copyright © 2019 Haiku. All rights reserved.
//

import UIKit

class StrokedCirularImageView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupLayout()
        configureViews()
    }

    var image: UIImage? {
        get { return imageView.image }
        set { imageView.image = newValue }
    }

    var strokeGradient: Gradient? {
        get { return strokeView.gradient }
        set { strokeView.gradient = newValue }
    }

    var strokeWidth: CGFloat {
        get { return strokeMaskLayer.lineWidth }
        set {
            strokeMaskLayer.lineWidth = newValue
            updateStrokePath(forWidth: newValue)
        }
    }

    func setStrokeColor(_ color: UIColor?) {
        guard let color = color else {
            strokeGradient = nil
            return
        }

        strokeGradient = Gradient(color: color)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let cornerRadius = frame.size.width / 2
        self.cornerRadius = cornerRadius
        imageView.layer.cornerRadius = cornerRadius
        updateStrokePath(forWidth: strokeWidth)
    }

    private func setupLayout() {
        var constraints = embed(imageView, shouldActivateConstraints: false)

        let aspectConstraint = imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        constraints.append(aspectConstraint)

        constraints += embed(strokeView, shouldActivateConstraints: false)

        NSLayoutConstraint.activate(constraints)
    }

    private func configureViews() {
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true

        strokeMaskLayer.fillColor = nil
        strokeMaskLayer.strokeColor = UIColor.black.cgColor

        strokeView.layer.mask = strokeMaskLayer
    }

    private func updateStrokePath(forWidth width: CGFloat) {
        /// Since the stroke is rendered around the line we need to inset the path by half the stroke width.
        let insetAmount = width / 2
        let strokeBounds = strokeView.frame.insetBy(dx: insetAmount, dy: insetAmount)
        let cornerRadius = strokeView.frame.size.width / 2
        strokeMaskLayer.path = UIBezierPath(roundedRect: strokeBounds, cornerRadius: cornerRadius).cgPath
    }

    override class var requiresConstraintBasedLayout: Bool { return true }

    private let imageView = UIImageView()
    private let strokeView = GradientView()
    private let strokeMaskLayer = CAShapeLayer()

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { fatalError("\(#function) not implemented.") }
}
