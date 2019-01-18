//
//  ALNotificationBar.swift
//  ALNotificationBar
//
//  Created by Shohin Tagaev on 1/16/19.
//  Copyright © 2019 shohin. All rights reserved.
//

import UIKit

open class ALNotificationBar {
    private static let infoDic = Bundle.main.infoDictionary
    
    private var manualHeight: CGFloat = 0
    private let _contentView = ContentView()
    private let _bgView = UIView()
    private var _window: UIWindow?
    
    private var timer: Timer!
    
    private var tapActionClosure: (() -> ())?
    
    private var window: UIWindow! {
        get {
            if self._window == nil {
                self.initWindow()
            }
            return self._window
        }
        
        set {
            self._window = newValue
        }
    }
    
    private var screenFrame: CGRect {
        return UIScreen.main.bounds
    }
    
    private var application: UIApplication {
        return UIApplication.shared
    }
    
    private var keyWindow: UIWindow {
        return self.application.keyWindow!
    }
    
    private var topArea: CGFloat {
        if #available(iOS 11.0, *) {
            return self.keyWindow.safeAreaInsets.top
        } else {
            return 0//keyWindow.layoutMargins.top
        }
    }
    
    private var bottomArea: CGFloat {
        if #available(iOS 11.0, *) {
            return self.keyWindow.safeAreaInsets.bottom
        } else {
            return 0//keyWindow.layoutMargins.bottom
        }
    }
    
    private var windowWidth: CGFloat {
        return self.screenFrame.width - self.padding.left - self.padding.right
    }
    
    private func height(of window: UIWindow) -> CGFloat {
        var h: CGFloat = 0
        switch self.heightMode {
        case .avto:
            self.resizeHeightToFitSubviews(of: window)
            h = window.frame.height
        case .fixed:
            h = 70
        case .manual:
            h = self.manualHeight
        }
        return h
    }
    
    private func y(by height: CGFloat) -> CGFloat {
        var y: CGFloat = 0
        switch self.position {
        case .top:
            y = self.topArea + self.padding.top
        case .center:
            let maxH = self.screenFrame.height
            y = (maxH - height - self.padding.top - self.padding.bottom) / 2
        case .bottom:
            let maxH = self.screenFrame.height
            y = maxH - height - self.padding.bottom - self.bottomArea
        }
        
        return y
    }
    
    //MARK: final public properties
    final public var isShowed: Bool {
        return self._window != nil
            && !(self._window?.isHidden ?? true)
    }
    
    final public var padding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15) {
        didSet {
            self.updateLayout()
        }
    }
    
    final public var heightMode: HeightMode = .fixed {
        didSet {
            self.updateLayout()
        }
    }
    
    final public var position: Position = .top {
        didSet {
            self.updateLayout()
        }
    }
    
    final public var moveDirection: MoveDirection = .right {
        didSet {
            self._contentView.set(moveDirection: self.moveDirection)
        }
    }
    
    final public var animationType: AnimationType = .topBottom {
        didSet {
            
        }
    }
    
    final public var timerDuration: TimeInterval = 5 {
        didSet {
            
        }
    }
    
    final public var appName: String? {
        return ALNotificationBar.infoDic?["CFBundleName"] as? String
    }
    
    final public var appIcon: UIImage? {
//        (((Bundle.main.infoDictionary?["CFBundleIcons"] as? Dictionary<String, Any>)?["CFBundlePrimaryIcon"] as? Dictionary<String, Any>)?["CFBundleIconFiles"] as? AnyObject)?.object(at: 0) as? String
        let iconsDic = ALNotificationBar.infoDic?["CFBundleIcons"] as? Dictionary<String, Any>
        let primaryIconsDic = iconsDic?["CFBundlePrimaryIcon"] as? Dictionary<String, Any>
        let appIconName = (primaryIconsDic?["CFBundleIconFiles"] as AnyObject).firstObject as? String
        guard let ain = appIconName,
            let icon = UIImage(named: ain) else {
            return nil
        }
        
        return icon
    }
    
    //MARK: open methods section
    open func configure() {
        fatalError("Must implement on subsclass!")
    }
    
    open func layout(size: CGSize) {
        fatalError("Must implement on subsclass!")
    }
    
    deinit {
        self.stopTimer()
    }
    
    //MARK: public final methods section
    final public func configureBackgroundView(configurator: ((UIView) -> ())) {
        configurator(self._bgView)
    }
    
    final public func styleBackgroundView(styletor: ((UIView) -> ())) {
        styletor(self._bgView)
    }
    
    final public func add(subview: UIView) {
        self._contentView.addSubview(subview)
    }
    
    final public func add(subviews: UIView...) {
        for sbv in subviews {
            self.add(subview: sbv)
        }
    }
    
    final public func showBar() {
        
        self.showAnimated()
    }
    
    final public func hideBar() {
        self.hideAnimated()
    }
    
    final public func setContent(height: CGFloat) {
        self.manualHeight = height
        self.heightMode = .manual
    }
    
    final public func setTap(action: @escaping () -> ()) {
        self.tapActionClosure = action
    }
    
    //MARK: private methods section
    private func initWindow() {
        let win = UIWindow(frame: .zero)
        win.windowLevel = UIWindow.Level.statusBar + 1
        win.backgroundColor = UIColor.clear
        
        self._contentView.frame = win.bounds
        win.addSubview(self._contentView)
        
        self.configContentView(window: win)
        
        self._window = win
        
        self.configure()
        self.updateLayout(window: self._window!)
    }
    
    private func configContentView(window: UIWindow) {
        self._contentView.setRemove {[unowned self] in
            self.hideAnimated()
        }
        self._contentView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        self._contentView.addGestureRecognizer(tapGesture)
        window.addSubview(self._contentView)
        self.configBgView()
    }
    
    private func configBgView() {
        self.add(subview: self._bgView)
    }
    
    private func updateLayout(window: UIWindow) {
        let w: CGFloat = self.windowWidth
        let h: CGFloat = self.height(of: window)
        let x: CGFloat = self.padding.left
        let y: CGFloat = self.y(by: h)
        window.frame = CGRect(x: x, y: y, width: w, height: h)
        
        self._contentView.frame = window.bounds
        self._bgView.frame = self._contentView.bounds
        
        self.layout(size: self._contentView.bounds.size)
    }
    
    private func updateLayout() {
        self.updateLayout(window: self.window)
    }
    
    private func show() {
        if self.isShowed {
//            self.hide()
            return
        }
        
        self.window.isHidden = false
    }
    
    private func showAnimated() {
        if self.isShowed {
//            self.hide()
            return
        }
        let frame = self.window.frame
        let x: CGFloat = frame.minX
        let y: CGFloat = frame.minY
        let w: CGFloat = frame.width
        let h: CGFloat = frame.height
        var moveX: CGFloat = x
        var moveY: CGFloat = y
        switch self.animationType {
        case .topBottom:
            moveY = -(self.screenFrame.height + h)
        case .leftRight:
            moveX = -(self.screenFrame.width + w)
        case .bottomTop:
            moveY = self.screenFrame.height + h
        case .rightLeft:
            moveX = self.screenFrame.width + w
        case .none:
            break
        }
        self.window.frame = CGRect(x: moveX, y: moveY, width: w, height: h)
        self.show()
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            self.window.frame = frame
        }, completion: { (yes) in
            self.startTimer()
        })
    }
    
    private func hide() {
        self.window.isHidden = true
        self.window = nil
    }
    
    private func hideAnimated() {
        let frame = self.window.frame
        let x: CGFloat = frame.minX
        let y: CGFloat = frame.minY
        let w: CGFloat = frame.width
        let h: CGFloat = frame.height
        var moveX: CGFloat = x
        var moveY: CGFloat = y
        switch self.moveDirection {
        case .up:
            moveY = -self.screenFrame.height
        case .left:
            moveX = -self.screenFrame.width
        case .down:
            moveY = self.screenFrame.height
        case .right:
            moveX = self.screenFrame.width
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.window.frame = CGRect(x: moveX, y: moveY, width: w, height: h)
        }, completion: { (yes) in
            self.hide()
            self.stopTimer()
        })
    }
    
    private func startTimer() {
        self.stopTimer()
        if self.timerDuration > 0 {
            self.timer = Timer.scheduledTimer(timeInterval: self.timerDuration, target: self, selector: #selector(hideAction), userInfo: nil, repeats: false)
        }
    }
    
    private func stopTimer() {
        if self.timer != nil {
            self.timer.invalidate()
            self.timer = nil
        }
    }
    
    private func resizeToFitSubviews(of view: UIView) {
        var w: CGFloat = view.frame.width
        var h: CGFloat = view.frame.height
        for sbv in view.subviews {
            let sw = sbv.frame.maxX
            let sh = sbv.frame.maxY
            w = max(sw, w)
            h = max(sh, h)
        }
        view.frame.size = CGSize(width: w, height: h)
    }
    
    private func resizeHeightToFitSubviews(of view: UIView) {
        var h: CGFloat = view.frame.height
        for sbv in view.subviews {
            if !sbv.subviews.isEmpty {
                self.resizeHeightToFitSubviews(of: sbv)
            }
            let sh = sbv.frame.maxY
            h = max(sh, h)
        }
        view.frame.size = CGSize(width: view.frame.width, height: h)
    }
    
    //MARK: actions
    @objc
    private func hideAction() {
        self.hideAnimated()
    }
    
    @objc
    private func tapAction() {
        self.tapActionClosure?()
        self.hideAnimated()
    }
}

extension ALNotificationBar {
    public enum MoveDirection {
        case up, left, down, right
    }
    
    public enum AnimationType {
        case none, topBottom, leftRight, bottomTop, rightLeft
    }
    
    public enum Position {
        case top, center, bottom
    }
    
    //TODO: MUT FIX auto height mode
    public enum HeightMode {
        case fixed, manual, avto
    }
}

extension ALNotificationBar {
    final private class ContentView: UIView {
        private var realOrigin: CGPoint!
        private var moveDirection: MoveDirection = .right
        private var removeClosure: (() -> ())?
        
        convenience init() {
            self.init(frame: .zero)
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.configure()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            self.configure()
        }
        
        private func configure() {
            self.isUserInteractionEnabled = true
            
            let panGesture: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
            self.addGestureRecognizer(panGesture)
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            if self.realOrigin == nil {
                self.realOrigin = self.frame.origin
            }
        }
        
        public func set(moveDirection: MoveDirection) {
            self.moveDirection = moveDirection
        }
        
        public func setRemove(closure: @escaping () -> ()) {
            self.removeClosure = closure
        }
        
        //MARK: action
        @objc
        private func panGestureAction(_ gestureRecognizer: UIPanGestureRecognizer) {
            let velocity = gestureRecognizer.velocity(in: self)
            let translation = gestureRecognizer.translation(in: self)
            let view = gestureRecognizer.view!
            
            switch gestureRecognizer.state {
            case .began,
                 .changed:
                
                func verticalMove() {
                    view.center = CGPoint(x: view.center.x, y: view.center.y + translation.y)
                }
                
                func horizontalMove() {
                    view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y)
                }
                
                let directionYValue = velocity.y < 1.0 ? -1 : 1
                let directionXValue = velocity.x < 1.0 ? -1 : 1
                
                switch self.moveDirection {
                case .up:
                    if directionYValue == -1 {
                        verticalMove()
                    }
                case .left:
                    if directionXValue == -1 {
                        horizontalMove()
                    }
                case .down:
                    if directionYValue == 1 {
                        verticalMove()
                    }
                case .right:
                    if directionXValue == 1 {
                        horizontalMove()
                    }
                }
                
                print(view.frame)
                gestureRecognizer.setTranslation(CGPoint(x: 0, y: 0), in: self)
                break
            case .ended:
                func remove() {
                    self.removeClosure?()
                }
                
                switch self.moveDirection {
                case .up:
                    if view.frame.origin.y < -0.4 * view.frame.height {
                        remove()
                        print(view.frame.origin)
                    }
                case .left:
                    if view.frame.origin.x < -0.4 * view.frame.width {
                        remove()
                        print(view.frame.origin)
                    }
                case .down:
                    if view.frame.origin.y > 0.6 * view.frame.height {
                        remove()
                        print(view.frame.origin)
                    }
                case .right:
                    if view.frame.origin.x > 0.4 * view.frame.width {
                        remove()
                        print(view.frame.origin)
                    }
                }
                
                UIView.animate(withDuration: 0.5, animations: {
                    view.frame.origin = CGPoint(x:  self.realOrigin?.x ?? 0, y: self.realOrigin?.y ?? 0)
                })
                
                break
            default:
                break
            }
        }
    }
}
