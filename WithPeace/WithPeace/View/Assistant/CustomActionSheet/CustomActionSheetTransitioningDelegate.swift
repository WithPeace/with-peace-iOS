//
//  CustomActionSheetTransitioningDelegate.swift
//  WithPeace
//
//  Created by Dylan_Y on 3/27/24.
//

import UIKit

final class CustomActionSheetTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomActionSheetPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
