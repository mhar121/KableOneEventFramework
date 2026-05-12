//
//  FSPagerViewCell.swift
//  FSPagerView
//
//  Created by Wenchao Ding on 17/12/2016.
//  Copyright © 2016 Wenchao Ding. All rights reserved.
//
//
//  FSPagerViewCell.swift
//  FSPagerView
//
//  Created by Wenchao Ding on 17/12/2016.
//  Copyright © 2016 Wenchao Ding. All rights reserved.
//

import UIKit

open class FSPagerViewCell: UICollectionViewCell {
    @objc
    open var imageView: UIImageView? {
        if let _ = _imageView {
            return _imageView
        }
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(imageView)
        _imageView = imageView
        return imageView
    }
    /*@objc
    open var plyButton: UIButton? {
        if let _ = _plyButton {
            return _plyButton
        }
        let plyButton = RoundableButton(type: .custom)
        plyButton.layer.cornerRadius = 20
        plyButton.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        plyButton.tintColor = .white
        plyButton.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 13)!
        //UIFont.preferredFont(forTextStyle: .subheadline)
        plyButton.translatesAutoresizingMaskIntoConstraints = false
        plyButton.setImage(UIImage(named: "ic_banner_play"), for: .normal)
        plyButton.setTitle("   Watch Now", for: .normal)
        plyButton.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(plyButton)
        _plyButton = plyButton
        //remButton.rounded = true

        plyButton.backgroundColor = #colorLiteral(red: 0.7607077956, green: 0.1319186985, blue: 0.1667235196, alpha: 1)


        return plyButton
    }*/

    var selectedForegroundView: UIView? {
        guard _selectedForegroundView == nil else {
            return _selectedForegroundView
        }
        let view = UIView()
        contentView.addSubview(view)
       // view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        _selectedForegroundView = view
        return view
    }
    
    
    
   /* fileprivate var selectedForegroundView: UIView? {
        guard _selectedForegroundView == nil else {
            return _selectedForegroundView
        }
        let view = UIView()
        contentView.addSubview(view)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        _selectedForegroundView = view
        return view
    }*/
    fileprivate weak var _imageView: UIImageView?
    fileprivate weak var _plyButton: UIButton?
    //fileprivate weak var _reminderButton: RoundableButton?
    fileprivate weak var _selectedForegroundView: UIView?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        contentView.layer.cornerRadius = 20
        contentView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        //self.contentView.layer.cornerRadius = 4
        self.contentView.clipsToBounds = true



        imageView?.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
       
        imageView?.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView?.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        imageView?.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true





//        plyButton?.topAnchor.constraint(equalTo: imageView!.bottomAnchor).isActive = true
//        plyButton?.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
//        plyButton?.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
//        plyButton?.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
}
