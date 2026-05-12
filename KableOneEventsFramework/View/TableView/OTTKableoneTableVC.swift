//
//  OTTKableoneTableVC.swift
//  KableOne Events
//
//  Created by Muhammad Haris on 18/12/2025.
//

import UIKit

class OTTKableoneTableVC: UITableViewCell {

  @IBOutlet weak var OTTkableOneCollectionView: UICollectionView!

  var movies = [KableOneMovie]()
  let OTTlistItem = "StreamCollectionVC"
    override func awakeFromNib() {
        super.awakeFromNib()

      let frameworkBundle = Bundle(for: OTTKableoneTableVC.self)
      OTTkableOneCollectionView.register(UINib(nibName: OTTlistItem, bundle: frameworkBundle), forCellWithReuseIdentifier: OTTlistItem)
      OTTkableOneCollectionView.dataSource = self
      OTTkableOneCollectionView.delegate = self
    }

  func configure(Movies:[KableOneMovie]){
    movies = Movies
    OTTkableOneCollectionView.reloadData()
  }

  
}
extension OTTKableoneTableVC: UICollectionViewDataSource, UICollectionViewDelegate{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return movies.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OTTlistItem, for: indexPath) as! StreamCollectionVC
    cell.setData(movie: movies[indexPath.row])
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    DispatchQueue.main.async {
      KableOneEventsUI.openVideoDetail?(self.movies[indexPath.row])
    }
  }
}
extension OTTKableoneTableVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 8
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

      return CGSize(width: 200, height: 400)
    }
}
