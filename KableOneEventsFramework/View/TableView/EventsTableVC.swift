//
//  EventsTableVC.swift
//  KableOne Events
//
//  Created by Muhammad Haris on 10/12/2025.
//

import UIKit

class EventsTableVC: UITableViewCell {



  @IBOutlet weak var eventsCollectionView: UICollectionView!
  @IBOutlet weak var eventTypeCollectionView: UICollectionView!

  @IBOutlet weak var venueBtn: UIButton!
  @IBOutlet weak var areaLbl: UILabel!
  @IBOutlet weak var venueLbl: UILabel!
  @IBOutlet weak var venueView: UIView!

  @IBOutlet weak var noInfoLabel: UILabel!
  @IBOutlet weak var mainLabel: UILabel!
  let eventlistItem = "EventsCollectionVC"
  let eventtypelistItem = "EventTypeCollectionVC"
  let types = ["All Events","Movies","Concerts","Theatre","Comedy"]
  weak var gotoDetail : GoToDetailsVC?
  var eventsData: EventsData?
  var statesData : [StateModel]?
  var eventList: [EventDetail]?
  var selectedIndex: IndexPath? = IndexPath(item: 0, section: 0)
  let venueDropDown = DropDown()
  let areaDropDown = DropDown()
  var eventTypeId = 0
  private var selectedTypeId: Int? = nil
  private var selectedVenueNames = Set<String>()


    override func awakeFromNib() {
        super.awakeFromNib()
      let frameworkBundle = Bundle(for: EventsTableVC.self)
      eventsCollectionView.register(UINib(nibName: eventlistItem, bundle: frameworkBundle), forCellWithReuseIdentifier: eventlistItem)
      eventsCollectionView.dataSource = self
       eventsCollectionView.delegate = self

      eventTypeCollectionView.register(UINib(nibName: eventtypelistItem, bundle: frameworkBundle), forCellWithReuseIdentifier: eventtypelistItem)
      eventTypeCollectionView.dataSource = self
      eventTypeCollectionView.delegate = self
      //handleVenuAreaList()
    }

  func configure(data:EventsData?,stateData:[StateModel]?, locationName: String? = nil){
    statesData = stateData
    eventsData = data
    eventList = data?.eventDetails
    if let loc = locationName {
        areaLbl.text = loc
    } else {
        areaLbl.text = "Area"
    }
    eventTypeCollectionView.reloadData()
    eventsCollectionView.reloadData()
    handleVenuAreaList()
    self.noInfoLabel.isHidden = !(self.eventList?.isEmpty ?? true)
    self.mainLabel.isHidden = self.eventList?.isEmpty ?? true
  }


  func handleVenuAreaList(){

      // Venue DropDown
    self.venueDropDown.dataSource = eventsData?.venues.map { $0.venueName } ?? []
    venueDropDown.anchorView = venueView
    venueDropDown.bottomOffset = CGPoint(x: 0, y:(venueDropDown.anchorView?.plainView.bounds.height)!)
    venueDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
      //venueLbl.text = item
      print("Selected venue:", item)
      if selectedVenueNames.contains(item) {
              selectedVenueNames.remove(item)
          } else {
              selectedVenueNames.insert(item)
          }
      venueDropDown.reloadAllComponents()
         applyFilters()
    }
    venueDropDown.customCellConfiguration = { [unowned self] (index: Int, item: String, cell: DropDownCell) in
        cell.optionLabel.text = item
        //cell.accessoryType = selectedVenueNames.contains(item) ? .checkmark : .none
      if selectedVenueNames.contains(item) {
              let image = UIImage(systemName: "checkmark.circle.fill")
              cell.accessoryView = UIImageView(image: image)
              (cell.accessoryView as? UIImageView)?.tintColor = .red // 👈 your color
          } else {
              cell.accessoryView = nil
          }
    }

  }
  private func applyFilters() {
    var filtered = eventsData?.eventDetails

      // Type filter
      if let typeId = selectedTypeId {
        filtered = filtered?.filter { $0.eventTypeId == typeId }
      }

    // Venue multi-filter
       if !selectedVenueNames.isEmpty {
         filtered = filtered?.filter {
               selectedVenueNames.contains($0.venueName)
           }
       }

      eventList = filtered
    self.noInfoLabel.isHidden = !(self.eventList?.isEmpty ?? true)
    self.mainLabel.isHidden = self.eventList?.isEmpty ?? true
      eventsCollectionView.reloadData()
  }

  @IBAction func venueDropDown(_ sender: Any) {
    venueDropDown.show()
  }
  @IBAction func areaDropDown(_ sender: Any) {
    //areaDropDown.show()
    gotoDetail?.openState()
  }

}
extension EventsTableVC: UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionView == eventsCollectionView{
      return eventList?.count ?? 0
    }else{
      return (eventsData?.eventTypes.count ?? 0) + 1
      }
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if collectionView == eventsCollectionView{
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: eventlistItem, for: indexPath) as! EventsCollectionVC
      cell.setData(event: eventList?[indexPath.row])
      return cell
    }else{
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: eventtypelistItem, for: indexPath) as! EventTypeCollectionVC

      if indexPath.row == 0 {
              cell.eventName.text = "All Events"
          } else {
              let eventName = eventsData?.eventTypes[indexPath.row - 1].eventTypeName ?? ""
              cell.eventName.text = eventName
          }
//      if selectedIndex == indexPath {
//        cell.view.backgroundColor = UIColor(named: "mainColor")
//      }else{
//        cell.view.backgroundColor = UIColor.black
//      }
      if selectedIndex == indexPath {
          if let mainColor = UIColor(named: "mainColor", in: Bundle(for: HomeVC.self), compatibleWith: nil) {
              cell.view.backgroundColor = mainColor
          } else {
              cell.view.backgroundColor = UIColor.red // fallback
          }
      } else {
          cell.view.backgroundColor = UIColor.black
      }

      return cell
    }
  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if collectionView == eventTypeCollectionView{
      selectedIndex = indexPath
      collectionView.reloadData()
      if indexPath.row == 0 {
              selectedTypeId = nil // All Events
          } else {
              let typeIndex = indexPath.row - 1
              selectedTypeId = eventsData?.eventTypes[typeIndex].id

          }

          applyFilters()

    }else{
      gotoDetail?.openDetailsVC(eventId: eventsData?.eventDetails?[indexPath.row].eventId )
    }
  }

  func collectionView(_ collectionView: UICollectionView,
                      willDisplay cell: UICollectionViewCell,
                      forItemAt indexPath: IndexPath) {

    if (self.eventList?.count ?? 0)-1 == indexPath.row {
      gotoDetail?.loadMoreData(eventId: selectedTypeId ?? 0)
      }
  }
}

extension EventsTableVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 8
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      if collectionView == eventsCollectionView{
        return CGSize(width: 300, height: 520)
      }
      return CGSize(width: 130, height: 40)
    }
}
protocol GoToDetailsVC:AnyObject{
  func openDetailsVC(eventId:String?)
  func loadMoreData(eventId:Int)
  func openState()
}
