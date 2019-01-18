//
//  ALInAppNotificationBar.swift
//  ALNotificationBar
//
//  Created by Shohin Tagaev on 1/17/19.
//  Copyright © 2019 shohin. All rights reserved.
//

import UIKit

final public class ALInAppNotificationBar: ALNotificationBar {
    private let _appInfoContent: UIView = UIView()
    private let _appInfoBottom: UIView = UIView() //for hidding info content bottom corner
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
        let cornerRadius: CGFloat = 12
        self.configureBackgroundView { (v) in
            v.backgroundColor = UIColor.lightGray
            v.clipsToBounds = true
            v.layer.cornerRadius = cornerRadius
        }
        
        self._iconImageView.contentMode = .scaleAspectFit
        self._appInfoContent.addSubview(self._iconImageView)
        
        self._appNameLabel.text = self.appName
        self._appNameLabel.font = UIFont.systemFont(ofSize: 14)
        self._appNameLabel.textColor = UIColor.black
        self._appInfoContent.addSubview(self._appNameLabel)
        
        self._appInfoContent.backgroundColor = UIColor.gray
        self._appInfoContent.clipsToBounds = true
        self._appInfoContent.layer.cornerRadius = cornerRadius
        
        self._appInfoBottom.backgroundColor = self._appInfoContent.backgroundColor
        
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
        
        self.add(subviews: self._appInfoContent,
                 self._appInfoBottom,
                 self._iconImageView,
                 self._appNameLabel,
                 self._titleLabel,
                 self._bodyMessageLabel)
    }
    
    public override func layout(size: CGSize) {
        var x: CGFloat = 0
        var y: CGFloat = x
        var w: CGFloat = size.width - 2 * x
        var h: CGFloat = 25
        self._appInfoContent.frame = CGRect(x: x, y: y, width: w, height: h)
        
        h = self._appInfoContent.layer.cornerRadius
        y = self._appInfoContent.frame.maxY - h
        x = 0
        w = size.width - 2 * x
        self._appInfoBottom.frame = CGRect(x: x, y: y, width: w, height: h)
        
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
    }
}
