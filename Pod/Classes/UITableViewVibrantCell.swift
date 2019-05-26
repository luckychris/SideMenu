//
//  UITableViewVibrantCell.swift
//  Pods
//
//  Created by Jon Kent on 1/14/16.
//
//

import UIKit

open class UITableViewVibrantCell: UITableViewCell {
    
    var tapGR : UITapGestureRecognizer?

    fileprivate var vibrancyView:UIVisualEffectView = UIVisualEffectView()
    fileprivate var vibrancySelectedBackgroundView:UIVisualEffectView = UIVisualEffectView()
    fileprivate var defaultSelectedBackgroundView:UIView?
    open var blurEffectStyle: UIBlurEffect.Style = .light {
        didSet {
            updateBlur()
        }
    }
    
    @IBInspectable var blurEffectStyleIB: Int {
        get {
            return blurEffectStyle.rawValue
        }
        set {
            self.blurEffectStyle = UIBlurEffect.Style(rawValue: newValue)!
        }
    }
    
    // For registering with UITableView without subclassing otherwise dequeuing instance of the cell causes an exception
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        vibrancyView.frame = bounds
        vibrancyView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        for view in subviews {
            vibrancyView.contentView.addSubview(view)
        }
        addSubview(vibrancyView)
        
        let blurSelectionEffect = UIBlurEffect(style: .light)
        vibrancySelectedBackgroundView.effect = blurSelectionEffect
        defaultSelectedBackgroundView = selectedBackgroundView
        
        updateBlur()
        
        self.tapGR = UITapGestureRecognizer(target: self, action: #selector(self.cellTapped(tapGR:)))
        tapGR?.cancelsTouchesInView = false
        self.addGestureRecognizer(tapGR!)
    }
    
    @objc func cellTapped(tapGR: UITapGestureRecognizer) {
        
        if contentView.subviews.count > 0 {
            
            if let cellID = reuseIdentifier {
                
       //         if SharedData.shared.allowedReuseIDsToSendNotifications.contains(cellID) {
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: cellID), object: nil, userInfo: ["cellID":cellID])
    //            }
            }
        }
    }
    
    internal func updateBlur() {
        // shouldn't be needed but backgroundColor is set to white on iPad:
        backgroundColor = UIColor.clear
        
        if  !UIAccessibility.isReduceTransparencyEnabled {
            let blurEffect = UIBlurEffect(style: blurEffectStyle)
            vibrancyView.effect = UIVibrancyEffect(blurEffect: blurEffect)
            
            if selectedBackgroundView != nil && selectedBackgroundView != vibrancySelectedBackgroundView {
                vibrancySelectedBackgroundView.contentView.addSubview(selectedBackgroundView!)
                selectedBackgroundView = vibrancySelectedBackgroundView
            }
        } else {
            vibrancyView.effect = nil
            selectedBackgroundView = defaultSelectedBackgroundView
        }
    }
}
