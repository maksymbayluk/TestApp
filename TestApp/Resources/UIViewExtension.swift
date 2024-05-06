//
//  UIViewExtension.swift
//  TestApp
//
//  Created by Максим Байлюк on 06.05.2024.
//

import Foundation
import UIKit

@IBDesignable extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            layer.cornerRadius
        } set {
            layer.cornerRadius = newValue
            layer.masksToBounds = (newValue > 0)
        }
    }
}


@IBDesignable extension UIView {
    @IBInspectable var shadowRadius: CGFloat {
        get {
            layer.shadowRadius
        } set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable var shadowOpacity: CGFloat {
        get {
            CGFloat(layer.shadowOpacity)
        } set {
            layer.shadowOpacity = Float(newValue)
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get {
            layer.shadowOffset
        } set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            guard let cgColor = layer.shadowColor else {
                return nil
            }
            return UIColor(cgColor: cgColor)
        } set {
            layer.shadowColor = newValue?.cgColor
        }
    }
}

@IBDesignable extension UIView {
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let cgColor = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: cgColor)
        } set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            layer.borderWidth
        } set {
            layer.borderWidth = newValue
        }
    }
}
extension UIImage {
    func withRoundedCorners(radius: CGFloat) -> UIImage? {
        let maxRadius = min(size.width, size.height) / 2
        let cornerRadius = min(radius, maxRadius)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        let rect = CGRect(origin: .zero, size: size)
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        draw(in: rect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
extension NoInternetVC: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        // Customize presentation with a tinted background view
        let presentationController = DimmingPresentationController(presentedViewController: presented, presenting: presenting)
        return presentationController
    }
}
class DimmingPresentationController: UIPresentationController {
    override var shouldRemovePresentersView: Bool {
        return false // Keep the presenting view controller's view
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }
        
        // Create a semi-transparent background view
        let dimmingView = UIView(frame: containerView.bounds)
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        dimmingView.alpha = 0
        
        // Add the background view to the container view
        containerView.addSubview(dimmingView)
        
        // Animate the appearance of the background view
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            dimmingView.alpha = 1
        }, completion: nil)
    }
}

