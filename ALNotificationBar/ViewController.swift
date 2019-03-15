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
    @IBOutlet weak var barTypeSegmentControl: UISegmentedControl!
    @IBOutlet weak var heightModeStackView: UIStackView!
    @IBOutlet weak var heightModeSegmentControl: UISegmentedControl!
    @IBOutlet weak var manualHeightTxtField: UITextField!
    @IBOutlet weak var inAppStyleStackView: UIStackView!
    @IBOutlet weak var inAppStyleSegmentControl: UISegmentedControl!
    @IBOutlet weak var timeDurationTxtField: UITextField!
    @IBOutlet weak var positionSegmentControl: UISegmentedControl!
    @IBOutlet weak var moveDirectionSegmentControl: UISegmentedControl!
    @IBOutlet weak var animationTypeSegmentControl: UISegmentedControl!
    
    let bonusBar = BonusNotificationBar(title: "Вы получили бонус в размере", desc: "700 сум", image: #imageLiteral(resourceName: "coin"))
    let inAppBar = ALInAppNotificationBar(title: "New notification🤖", bodyMessage: "😹👍🐳 You have new notification from Notification bar app")
    
    var barType: Int {
        return self.barTypeSegmentControl.selectedSegmentIndex
    }
    
    var heightMode: ALNotificationBar.HeightMode {
        switch self.heightModeSegmentControl.selectedSegmentIndex {
        case 0:
            return .fixed
        case 1:
            return .manual
        default:
            return .auto
        }
    }
    
    var inAppBarStyle: ALInAppNotificationBar.Style {
        switch self.inAppStyleSegmentControl.selectedSegmentIndex {
        case 0:
            return .light
        default:
            return .dark
        }
    }
    
    var position: ALNotificationBar.Position {
        switch self.positionSegmentControl.selectedSegmentIndex {
        case 0:
            return .top
        case 1:
            return .center
        default:
            return .bottom
        }
    }
    
    var moveDirection: ALNotificationBar.MoveDirection {
        switch self.moveDirectionSegmentControl.selectedSegmentIndex {
        case 0:
            return .up
        case 1:
            return .left
        case 2:
            return .down
        default:
            return .right
        }
    }
    
    var animationType: ALNotificationBar.AnimationType {
        switch self.animationTypeSegmentControl.selectedSegmentIndex {
        case 0:
            return .topBottom
        case 1:
            return .leftRight
        case 2:
            return .bottomTop
        default:
            return .rightLeft
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tapGesture.cancelsTouchesInView = true
        self.view.addGestureRecognizer(tapGesture)
        self.configUI()
    }
    
    private func configUI() {
        self.configHeightMode()
        self.configManualHeightMode()
        self.configInAppStyle()
    }
    
    private func configHeightMode() {
        self.heightModeStackView.isHidden = self.barType == 0
    }
    
    private func configInAppStyle() {
        self.inAppStyleStackView.isHidden = self.barType == 1
    }
    
    private func configManualHeightMode() {
        self.manualHeightTxtField.isHidden = self.heightMode != .manual
    }
    
    private func prepare(bar: ALNotificationBar) {
        let t = self.timeDurationTxtField.text ?? ""
        bar.timerDuration = TimeInterval(t) ?? 0
        bar.position = self.position
        bar.moveDirection = self.moveDirection
        bar.animationType = self.animationType
        bar.setTap {
            let alert = UIAlertController(title: "Alert", message: "Notification bar tapped", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func show() {
        switch self.barType {
        case 0:
            self.inAppBar.style = self.inAppBarStyle
            self.prepare(bar: self.inAppBar)
            self.inAppBar.showBar()
        default:
            self.bonusBar.heightMode = self.heightMode
            if self.heightMode == .manual {
                let hTxt = self.manualHeightTxtField.text ?? ""
                let h: Double = Double(hTxt) ?? 0
                self.bonusBar.setContent(height: CGFloat(h))
            }
            self.prepare(bar: self.bonusBar)
            self.bonusBar.showBar()
        }
    }
    
    private func hide() {
        switch self.barType {
        case 0:
            self.inAppBar.hideBar()
//            ALInAppNotificationBar.showBar(title: <#T##String#>, bodyMessage: <#T##String#>, icon: <#T##UIImage?#>, style: <#T##ALInAppNotificationBar.Style#>, position: <#T##ALNotificationBar.Position#>, moveDirecton: <#T##ALNotificationBar.MoveDirection#>, animationType: <#T##ALNotificationBar.AnimationType#>)
        default:
            self.bonusBar.hideBar()
        }
    }
    
    private func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    //MARK: actions
    @objc
    private func tapAction() {
        self.hideKeyboard()
    }
    
    @IBAction func showBarAction() {
        self.show()
        self.hideKeyboard()
    }
    
    @IBAction func hideBarAction() {
        self.hide()
        self.hideKeyboard()
    }
    
    @IBAction func barTypeAction(_ sender: UISegmentedControl) {
        self.configHeightMode()
        self.configInAppStyle()
        self.hideKeyboard()
    }
    
    @IBAction func heightModeAction(_ sender: UISegmentedControl) {
        self.configManualHeightMode()
        self.hideKeyboard()
    }
    
    @IBAction func positionAction(_ sender: UISegmentedControl) {
        self.hideKeyboard()
    }
    
    @IBAction func moveDirectionAction(_ sender: UISegmentedControl) {
        self.hideKeyboard()
    }
    
    @IBAction func animationTypeAction(_ sender: UISegmentedControl) {
        self.hideKeyboard()
    }
    
}
