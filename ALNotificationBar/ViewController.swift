//
//  ViewController.swift
//  ALNotificationBar
//
//  Created by Shohin Tagaev on 1/16/19.
//  Copyright © 2019 shohin. All rights reserved.
//

import UIKit

final public class BonusNotificationBar: ALNotificationBar {
    private let _titleLabel: UILabel = UILabel()
    private let _descLabel: UILabel = UILabel()
    private let _imageView: UIImageView = UIImageView()
    
    private let _title: String
    private let _desc: String
    private let _image: UIImage
    public init(title: String,
                desc: String,
                image: UIImage) {
        self._title = title
        self._desc = desc
        self._image = image
        super.init()
    }
    
    public override func configure() {
        self.configureBackgroundView { (v) in
            v.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            v.clipsToBounds = true
            v.layer.cornerRadius = 12
        }
        
        self._titleLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        self._titleLabel.font = UIFont.systemFont(ofSize: 14)
        self._titleLabel.numberOfLines = 0
        self._titleLabel.text = self._title
        self._titleLabel.sizeToFit()
        
        self._descLabel.textColor = UIColor.white
        self._descLabel.font = UIFont.boldSystemFont(ofSize: 14)
        self._descLabel.numberOfLines = 0
        self._descLabel.text = self._desc
        self._descLabel.sizeToFit()
        
        self._imageView.contentMode = .scaleAspectFit
        self._imageView.image = self._image
        
        self.add(subviews: self._titleLabel,
                 self._descLabel,
                 self._imageView)
    }
    
    public override func layout(size: CGSize) {
        let m: CGFloat = 10
        var w: CGFloat = 25
        var x: CGFloat = size.width - w - m
        var y: CGFloat = 5
        var h: CGFloat = size.height - 2 * y
        self._imageView.frame = CGRect(x: x, y: y, width: w, height: h)
        
        x = m
        y = m
        w = self._imageView.frame.minX - m - x
        h = (size.height - 2 * y) / 2
        self._titleLabel.frame = CGRect(x: x, y: y, width: w, height: h)
        
        x = self._titleLabel.frame.minX
        y = self._titleLabel.frame.maxY
        w = self._titleLabel.frame.width
        h = self._titleLabel.frame.height
        self._descLabel.frame = CGRect(x: x, y: y, width: w, height: h)
    }
}

class ViewController: UIViewController {

    let bonusBar = BonusNotificationBar(title: "Вы получили бонус в размере", desc: "700 сум", image: #imageLiteral(resourceName: "coin"))
    
    let inAppBar = ALInAppNotificationBar(title: "New notification🤖", bodyMessage: "😹👍🐳 You have new notification from Notification bar app")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bonusBar.animationType = .topBottom
        self.bonusBar.moveDirection = .right
        
        self.inAppBar.setTap {
            print("Notification tapped")
        }
    }

    @IBAction func showBarAction() {
//        self.bonusBar.showBar()
        self.inAppBar.showBar()
    }
    
    @IBAction func hideBarAction(_ sender: Any) {
//        self.bonusBar.hideBar()
        self.inAppBar.hideBar()
    }
}
