//
//  EventsCollectionVC.swift
//  KableOne Events
//
//  Created by Muhammad Haris on 13/11/2025.
//

import UIKit
internal import Kingfisher
public class EventsCollectionVC: UICollectionViewCell {

  @IBOutlet weak var eventName: UILabel!
  @IBOutlet weak var eventDate: UILabel!
  @IBOutlet weak var eventLocation: UILabel!
  @IBOutlet weak var eventPricing: UILabel!
  @IBOutlet weak var eventImg: UIImageView!
  @IBOutlet weak var mainView: UIView!
  public override func awakeFromNib() {
        super.awakeFromNib()
      mainView.layer.borderWidth = 1
      //mainView.layer.borderColor = UIColor(named: "mainColor")?.cgColor

    if let mainColor = UIColor(named: "mainColor", in: Bundle(for: HomeVC.self), compatibleWith: nil) {
      mainView.layer.borderColor = mainColor.cgColor
    } else {
      mainView.layer.borderColor = UIColor.red.cgColor // fallback
    }
    }

  func setData(event:EventDetail?){
    eventName.text = event?.eventTitle
    eventPricing.text = event?.pricing
    eventLocation.text = event?.venueName
    eventDate.text =  event?.eventTimeDetails[0].eventDate
    if let url = URL(string: "\(event?.imageUrl ?? "")?im=Resize,width=300"){
        self.eventImg.kf.setImage(with: url)
    }
  }

}
