//
//  NotificationBanner.swift
//  latest-issue-viewer
//
//  Created by BangBang on 2022/06/25.
//

import Foundation
import SwiftEntryKit

struct NotificationBanner {
    // トーストの設定
    static func show(title: String, body: String, image: UIImage) {
        var attributes = EKAttributes.topToast
        
        attributes.entryBackground = .gradient(gradient: .init(colors: [EKColor(UIColor.red), EKColor(UIColor.orange)], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))

        //attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))

        attributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
        
        attributes.statusBar = .light

        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)

        attributes.positionConstraints.maxSize = .init(width: .constant(value: UIScreen.main.bounds.width), height: .intrinsic)
        
        // UIFont() は任意の形に変更する必要がある
        let title = EKProperty.LabelContent(text: title, style: .init(font: UIFont(), color: .white))
        let description = EKProperty.LabelContent(text: body, style: .init(font: UIFont(), color: .white))
        let image = EKProperty.ImageContent(image: image, size: CGSize(width: 35, height: 35))
        let simpleMessage = EKSimpleMessage(image: image, title: title, description: description)
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
        
        let contentView = EKNotificationMessageView(with: notificationMessage)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
}
