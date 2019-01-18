//
//  ALInAppNotificationBar.swift
//  ALNotificationBar
//
//  Created by Shohin Tagaev on 1/17/19.
//  Copyright © 2019 shohin. All rights reserved.
//

import UIKit

final public class ALInAppNotificationBar: ALNotificationBar {
    private let _shadowView: UIView = UIView()
    private let _contentView: UIVisualEffectView = UIVisualEffectView()
    private let _appInfoContent: UIVisualEffectView = UIVisualEffectView()
    private let _iconImageView: UIImageView = UIImageView()
    private let _appNameLabel: UILabel = UILabel()
    private let _titleLabel: UILabel = UILabel()
    private let _bodyMessageLabel: UILabel = UILabel()
    
    private let _title: String
    private let _bodyMessage: String
    public init(title: String,
                bodyMessage: String,
                icon: UIImage? = nil) {
        self._title = title
        self._bodyMessage = bodyMessage
        super.init()
        self._iconImageView.image = icon ?? self.appIcon
    }
    
    public override func configure() {
        self.setContent(height: 90)
        let cornerRadius: CGFloat = 10
        self.configureBackgroundView { (v) in
            v.backgroundColor = UIColor.clear
        }
        
        self._shadowView.layer.cornerRadius = cornerRadius
        self._shadowView.backgroundColor = UIColor.white
        self._shadowView.layer.shadowColor = UIColor.black.cgColor
        self._shadowView.layer.shadowOpacity = 0.4
        self._shadowView.layer.shadowOffset = CGSize.zero
        self._shadowView.layer.shadowRadius = 7
        
        self._iconImageView.layer.cornerRadius = 5
        self._iconImageView.clipsToBounds = true
        self._iconImageView.contentMode = .scaleAspectFit
        self._appInfoContent.contentView.addSubview(self._iconImageView)
        
        self._appNameLabel.text = self.appName
        self._appNameLabel.font = UIFont.systemFont(ofSize: 14)
        self._appNameLabel.textColor = UIColor.black
        self._appInfoContent.contentView.addSubview(self._appNameLabel)
        
        self._appInfoContent.effect = UIBlurEffect(style: .light)
        
        self._titleLabel.textColor = UIColor.black
        self._titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        self._titleLabel.textAlignment = .left
        self._titleLabel.numberOfLines = 1
        self._titleLabel.text = self._title
        
        self._bodyMessageLabel.textColor = UIColor.black
        self._bodyMessageLabel.font = UIFont.systemFont(ofSize: 15)
        self._bodyMessageLabel.textAlignment = .left
        self._bodyMessageLabel.numberOfLines = 0
        self._bodyMessageLabel.text = self._bodyMessage
        
        self._contentView.clipsToBounds = true
        self._contentView.layer.cornerRadius = cornerRadius
        self._contentView.contentView.addSubview(self._appInfoContent)
        self._contentView.contentView.addSubview(self._titleLabel)
        self._contentView.contentView.addSubview(self._bodyMessageLabel)
        
        self.add(subviews: self._shadowView,
                 self._contentView)
        
        self.change(style: .light)
    }
    
    public override func layout(size: CGSize) {
        var x: CGFloat = 0
        var y: CGFloat = x
        var w: CGFloat = size.width - 2 * x
        var h: CGFloat = 25
        self._appInfoContent.frame = CGRect(x: x, y: y, width: w, height: h)
        
        let m: CGFloat = 5
        x = m
        y = x
        h = self._appInfoContent.frame.height - 2 * y
        w = h
        self._iconImageView.frame = CGRect(x: x, y: y, width: w, height: h)
        
        x = self._iconImageView.frame.maxX + m
        y = self._iconImageView.frame.minY
        w = self._appInfoContent.frame.width - x - m
        h = self._appInfoContent.frame.height - 2 * y
        self._appNameLabel.frame = CGRect(x: x, y: y, width: w, height: h)
        
        x = 15
        y = self._appInfoContent.frame.maxY + 5
        w = size.width - 2 * x
        h = 20
        self._titleLabel.frame = CGRect(x: x, y: y, width: w, height: h)
        
        x = self._titleLabel.frame.minX
        y = self._titleLabel.frame.maxY + m
        w = size.width - 2 * x
        h = size.height - y - x
        self._bodyMessageLabel.frame = CGRect(x: x, y: y, width: w, height: h)
        
        x = 0
        y = 0
        w = size.width
        h = size.height
        self._contentView.frame = CGRect(x: x, y: y, width: w, height: h)
        
        self._shadowView.frame = self._contentView.bounds
    }
    
    final public func change(style: Style) {
        var blurEffect: UIBlurEffect?
        var appNameColor: UIColor?
        var titleColor: UIColor?
        var bodyColor: UIColor?
        switch style {
        case .dark:
            blurEffect = UIBlurEffect(style: .dark)
            appNameColor = UIColor.white
            titleColor = UIColor.white
            bodyColor = UIColor.white
        case .light:
            blurEffect = UIBlurEffect(style: .light)
            appNameColor = UIColor.black
            titleColor = UIColor.black
            bodyColor = UIColor.black
//        case .extraLight:
//            blurEffect = UIBlurEffect(style: .extraLight)
//            appNameColor = UIColor.black
//            titleColor = UIColor.black
//            bodyColor = UIColor.black
        }
        self._contentView.effect = blurEffect
        self._appNameLabel.textColor = appNameColor
        self._titleLabel.textColor = titleColor
        self._bodyMessageLabel.textColor = bodyColor
    }
}

extension ALInAppNotificationBar {
    public enum Style {
        case light, dark
    }
}
