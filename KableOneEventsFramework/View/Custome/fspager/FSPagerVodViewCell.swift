//
//  FSPagerVodViewCell.swift
//  Kableone
//
//  Created by Naveen Jangra on 04/07/23.
//

import UIKit
internal import Kingfisher
open class FSPagerVodViewCell: FSPagerViewCell {
    
  // MARK: - UI
     private(set) var viewMoreButton: UIButton = {
         let button = UIButton(type: .system)
         button.setTitle("View Shows", for: .normal)
         button.setTitleColor(.white, for: .normal)
         button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
       let bundle = Bundle(for: HomeVC.self)
       button.backgroundColor = UIColor(named: "mainColor", in: bundle, compatibleWith: nil)
         button.layer.cornerRadius = 6
         button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
         button.translatesAutoresizingMaskIntoConstraints = false
         return button
     }()

     // MARK: - Callbacks
     var onViewMoreTapped: (() -> Void)?

     // MARK: - Init
     public override init(frame: CGRect) {
         super.init(frame: frame)
         setupUI()
     }

     public required init?(coder: NSCoder) {
         super.init(coder: coder)
         setupUI()
     }
  // MARK: - Layout (IMPORTANT)
     public override func layoutSubviews() {
         super.layoutSubviews()
         imageView?.frame = contentView.bounds
     }

     // MARK: - Setup
     private func setupUI() {
         contentView.backgroundColor = .clear
         backgroundColor = .clear

         contentView.layer.cornerRadius = 16
         contentView.clipsToBounds = true

         // ImageView (already provided by FSPagerViewCell)
         imageView?.contentMode = .scaleAspectFill
         imageView?.clipsToBounds = true

         // Button
         contentView.addSubview(viewMoreButton)

       NSLayoutConstraint.activate([
           viewMoreButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
           viewMoreButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50)
       ])

      
         viewMoreButton.addTarget(self, action: #selector(viewMoreTapped), for: .touchUpInside)
     }

     // MARK: - Actions
     @objc private func viewMoreTapped() {
         onViewMoreTapped?()
     }

     // MARK: - Public API
     func setImage(_ image: UIImage?) {
         imageView?.image = image
     }

     func setImageURL(_ url: URL?) {
       imageView?.contentMode = .scaleAspectFill

         imageView?.kf.setImage(with: url)
     }


}

