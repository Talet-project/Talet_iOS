//
//  UIViewController+Extension.swift
//  Talet
//
//  Created by 김승희 on 12/1/25.
//

import UIKit

extension UIViewController {
    
    /// default alert (확인)
    func showDefaultAlert(
        title: String,
        message: String? = nil,
        confirmTitle: String = "확인",
        onConfirm: (() -> Void)? = nil
    ) {
        let alert = CustomAlert(
            style: .oneButton,
            title: title,
            message: message,
            confirmButtonTitle: confirmTitle,
            onConfirm: onConfirm
        )
        alert.show(in: self)
    }
    
    /// destructive alert (취소, 확인)
    func showDestructiveAlert(
        title: String,
        message: String? = nil,
        cancelTitle: String = "취소",
        confirmTitle: String = "확인",
        onCancel: (() -> Void)? = nil,
        onConfirm: (() -> Void)? = nil
    ) {
        let alert = CustomAlert(
            style: .twoButton,
            title: title,
            message: message,
            cancelButtonTitle: cancelTitle,
            confirmButtonTitle: confirmTitle,
            onCancel: onCancel,
            onConfirm: onConfirm
        )
        alert.show(in: self)
    }
}
