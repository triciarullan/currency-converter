//
//  UIViewController+Extension.swift
//  currency-converter
//
//  Created by Tric Rullan on 1/17/20.
//  Copyright © 2020 Tric. All rights reserved.
//

import UIKit
import MBProgressHUD

extension UIViewController {

    func showHUD(progressLabel:String){
        DispatchQueue.main.async { [weak self] in
         guard let self = self else {
            return
         }
            let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
            progressHUD.label.text = progressLabel
        }
    }

    func dismissHUD(isAnimated:Bool) {
         DispatchQueue.main.async { [weak self] in
            guard let self = self else {
               return
            }
            MBProgressHUD.hide(for: self.view, animated: isAnimated)
        }
    }
}
