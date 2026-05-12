//
//  EventsDetailsViewController.swift
//  KableOneEvents
//
//  Created by Muhammad Haris on 20/11/2025.
//

import UIKit
internal import Kingfisher
public class EventsDetailsViewController: BaseViewController {

  @IBOutlet weak var eventName: UILabel!
  @IBOutlet weak var eventDate: UILabel!
  @IBOutlet weak var eventDuration: UILabel!
  @IBOutlet weak var lblVenue: UILabel!
  @IBOutlet weak var eventVenue: UILabel!
  @IBOutlet weak var eventLanguage: UILabel!
  @IBOutlet weak var eventImg: UIImageView!
  @IBOutlet weak var eventDescription: UILabel!
  @IBOutlet weak var eventPrice: UILabel!
  @IBOutlet weak var eventType: UILabel!
  @IBOutlet weak var detailView: UIView!

  @IBOutlet weak var dateBtn: UIButton!
  @IBOutlet weak var venueBtn: UIButton!
  @IBOutlet weak var bookmarkBtn: UIButton!
  public var eventId = ""
//  public var stateId = 0
//  public var cityId = 0
  var eventDetails: EventDetail?
  let dateDropDown = DropDown()
  let venueDropDown = DropDown()
  var selectedSlotId: Int?
  var selectedScreenId: String?
  public init() {
    let bundle = Bundle(for: EventsDetailsViewController.self)
    super.init(nibName: "EventsDetailsViewController", bundle: bundle)
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  public override func viewDidLoad() {
    super.viewDidLoad()
    detailView.isHidden = true
    getEventDetailsData()
    eventDescription.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDescriptionTap)))

    setupScrollView()
  }

  private func setupScrollView() {
    let scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.showsVerticalScrollIndicator = false
    
    let contentView = UIView()
    contentView.translatesAutoresizingMaskIntoConstraints = false
    
    scrollView.addSubview(contentView)
    view.insertSubview(scrollView, at: 0)
    
    eventImg.removeFromSuperview()
    detailView.removeFromSuperview()
    
    contentView.addSubview(eventImg)
    contentView.addSubview(detailView)
    
    NSLayoutConstraint.activate([
        scrollView.topAnchor.constraint(equalTo: view.topAnchor),
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        
        eventImg.topAnchor.constraint(equalTo: contentView.topAnchor),
        eventImg.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        eventImg.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        
        detailView.topAnchor.constraint(equalTo: eventImg.bottomAnchor, constant: -140),
        detailView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
        detailView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        detailView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
    ])
  }

  func addBookmarkEvent(isBookMarked: Bool){
    self.showLoader()
    EventAPIClient.addBookmarkEvent(userId: Constants.userId, eventId: eventId, isCurrentlyBookMarked: isBookMarked){[weak self]response in
      guard self != nil else {return}
      self?.hideLoader()
      switch response{
      case .failure(let error):
        print(error.localizedDescription)
      case .success(let data):
        if data.isSuccess,let allData = data.data{
         self?.bookmarkBtn.isSelected = allData.isCurrentlyBookMarked
        }

      }}
  }

  func getEventDetailsData(){
    self.showLoader()
    EventAPIClient.getEventDetails(userId: Constants.userId, eventId: eventId){[weak self]response in
      guard self != nil else {return}
      self?.hideLoader()
      switch response{
      case .failure(let error):
        print(error.localizedDescription)
      case .success(let data):
        if data.isSuccess,let allData = data.data{
          print(allData)
          self?.eventDetails = allData
          self?.setEventDetailsData()
          self?.loadDropDownData()


        }

      }}
  }
 // ?im=Resize,width=\(UIScreen.main.bounds.width)
  func setEventDetailsData(){

    //if let imageUrlString = resizeImageURL(eventDetails?.imageUrl, width: 800),
    if let url = URL(string: "\(eventDetails?.imageUrl ?? "")?im=Resize,width=\(UIScreen.main.bounds.width)"){
                      //eventDetails?.imageUrl ?? "") {
      self.eventImg.kf.setImage(with:url )
    }
    bookmarkBtn.isSelected = eventDetails?.isCurrentlyBookMarked ?? false
    eventType.text = eventDetails?.eventTypeName
    eventName.text = eventDetails?.eventTitle
    eventDescription.text = eventDetails?.description
    eventDate.text = "\(eventDetails?.eventTimeDetails[0].eventDate ?? ""), \(eventDetails?.eventTimeDetails[0].eventTime ?? "")"
    eventDuration.text = eventDetails?.eventDuration
    lblVenue.text = "Venue - \(eventDetails?.venueName ?? "")"
    eventLanguage.text = eventDetails?.language
    eventPrice.text = eventDetails?.pricing
    detailView.isHidden = false
  }
  @objc func handleDescriptionTap(){
    //eventDescription.numberOfLines = (eventDescription.numberOfLines == 2) ? 0 : 2
  }



  func loadDropDownData() {

    guard let timeDetails = eventDetails?.eventTimeDetails else { return }
    dateBtn.isHidden = timeDetails.count  <= 1
    // --------------------
    // DATE DROPDOWN
    // --------------------
    dateDropDown.dataSource = timeDetails.map { $0.eventDate }
    dateDropDown.anchorView = eventDate
    dateDropDown.bottomOffset = CGPoint(
      x: 0,
      y: (dateDropDown.anchorView?.plainView.bounds.height) ?? 0
    )

    dateDropDown.selectionAction = { [weak self] (index: Int, item: String) in
      guard let self = self else { return }

      let selectedDetail = timeDetails[index]
      self.eventDate.text = "\(selectedDetail.eventDate), \(selectedDetail.eventTime)"
      print("Selected date:", selectedDetail.eventDate)
      self.selectedSlotId = selectedDetail.slotId
          print("Selected Slot ID:", selectedDetail.slotId)
      // ✅ Update VENUE dropdown with SCREENS
      self.setupVenueDropDown(screens: selectedDetail.screens ?? [])
    }


    // --------------------
    // AUTO-SELECT if ONLY ONE DATE
    // --------------------
    if timeDetails.count == 1 {
      let singleDetail = timeDetails[0]
      selectedSlotId = singleDetail.slotId
      eventDate.text = "\(singleDetail.eventDate), \(singleDetail.eventTime)" 
      setupVenueDropDown(screens: singleDetail.screens ?? [])
    }
  }

  func setupVenueDropDown(screens: [Screen]) {
    venueBtn.isHidden = screens.count <= 1
    venueDropDown.dataSource = screens.map { $0.screenName }
    venueDropDown.anchorView = eventVenue
    venueDropDown.bottomOffset = CGPoint(
      x: 0,
      y: (venueDropDown.anchorView?.plainView.bounds.height) ?? 0
    )
    if let firstScreen = screens.first {
      selectedScreenId = firstScreen.screenId
      eventVenue.text = firstScreen.screenName
      print("Auto selected screen:", firstScreen.screenName)
    } else {
      lblVenue.text = "Venue"
      eventVenue.text = eventDetails?.venueName
      selectedScreenId = nil
    }

    venueDropDown.selectionAction = { [weak self] (index: Int, item: String) in
      guard let self = self else { return }

      let selectedScreen = screens[index]
      self.eventVenue.text = selectedScreen.screenName

      print("Selected Screen:")
      print("Name:", selectedScreen.screenName)
      print("ID:", selectedScreen.screenId)
      self.selectedScreenId = selectedScreen.screenId

    }
  }



  @IBAction func backBtn(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  @IBAction func dateDropDown(_ sender: Any) {
    dateDropDown.show()
  }
  @IBAction func venueDropDown(_ sender: Any) {
    venueDropDown.show()
  }

  @IBAction func bookmarkBtnAction(_ sender: UIButton) {
    if self.checkLogin(){
       return
    }

    addBookmarkEvent(isBookMarked: !sender.isSelected)
  }
  @IBAction func bookTicketBtn(_ sender:Any) {
    if self.checkLogin(){
       return
    }

    let webViewVC = WebViewViewController()
    webViewVC.eventDetails = eventDetails
    webViewVC.selectedSlotId = selectedSlotId
    webViewVC.selectedScreenId = selectedScreenId
    if let navigation = self.navigationController {
      navigation.pushViewController(webViewVC, animated: true)
    } else {
      self.present(webViewVC, animated: true)
    }
  }

  private func checkLogin()->Bool{
    if KableOneEventsUI.currentUser() == nil{
      KableOneEventsUI.openLogin?()
          return true
      }
      return false
  }
  func resizeImageURL(_ urlString: String?, width: Int) -> String? {
    guard let urlString = urlString else { return nil }

    // Remove existing query parameters
    let baseUrl = urlString.components(separatedBy: "?").first ?? urlString

    // Append your desired width
    return "\(baseUrl)?im=Resize,width=\(width)"
  }
}
