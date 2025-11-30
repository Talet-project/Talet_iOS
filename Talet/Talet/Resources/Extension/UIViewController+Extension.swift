//
//  UIViewController+Extension.swift
//  Talet
//
//  Created by 김승희 on 12/1/25.
//

import UIKit

extension UIViewController {
    
    /// 두 버튼 알림 (취소 + 확인)
    func showAlert(
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
    
    /// 한 버튼 알림 (확인만)
    func showConfirmAlert(
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
    
    /// 에러 알림 (확인만)
    func showErrorAlert(title: String, message: String) {
        showConfirmAlert(
            title: title,
            message: message,
            confirmTitle: "확인"
        )
    }
}
