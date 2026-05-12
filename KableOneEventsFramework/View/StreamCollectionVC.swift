//
//  StreamCollectionVC.swift
//  KableOne Events
//
//  Created by Muhammad Haris on 13/11/2025.
//

import UIKit
internal import Kingfisher

public class StreamCollectionVC: UICollectionViewCell {
  @IBOutlet weak var mainView: UIView!
  @IBOutlet weak var imgView: UIImageView!
  @IBOutlet weak var titleLbl: UILabel!
  public override func awakeFromNib() {
        super.awakeFromNib()
      mainView.layer.borderWidth = 1

    if let mainColor = UIColor(named: "mainColor", in: Bundle(for: HomeVC.self), compatibleWith: nil) {
      mainView.layer.borderColor = mainColor.cgColor
    } else {
      mainView.layer.borderColor = UIColor.red.cgColor // fallback
    }

    }

  func setData(movie:KableOneMovie){
    titleLbl.text = movie.title
    if let url = URL(string: movie.imageUrl){
        self.imgView.kf.setImage(with: url)
    }
  }

}
