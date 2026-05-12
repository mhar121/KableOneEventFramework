//
//  HomeVC.swift
//  KableOne Events
//
//  Created by Muhammad Haris on 10/12/2025.
//

import UIKit

public class HomeVC: BaseViewController,GoToDetailsVC {

  @IBOutlet weak var bannerHeaderView: UIView!
  @IBOutlet weak var stateView: UIView!
  @IBOutlet weak var stateLabel: UILabel!
  @IBOutlet weak var cityLabel: UILabel!
  @IBOutlet weak var dataTableView: UITableView!
  @IBOutlet weak var pageControls: JXPageControlScale!
  @IBOutlet weak var fsPagerView: FSPagerView!{
      didSet
      {
          self.fsPagerView.register(FSPagerVodViewCell.self, forCellWithReuseIdentifier: "cell")
          self.fsPagerView.itemSize = FSPagerView.automaticSize
          //self.fsPagerView.automaticSlidingInterval = 4
          //self.fsPagerView.interitemSpacing = 10
          self.fsPagerView.isInfinite = true
      }
  }
  let eventsCell = "EventsTableVC"
  let eventtypelistItem = "EventTypeCollectionVC"
  let OTTCell = "OTTKableoneTableVC"
  let types = ["All Events","Movies","Concerts","Theatre","Comedy"]

  var eventsData: EventsData?
  var statesData : [StateModel]?
  var citiesData : [StateModel]?
  var isLoading = false
  var page = 0
  let pageLimit = 10
 var stateId = 0
  var cityId = 0
  var selectedStateName: String?
  var selectedCityName: String?
  let stateDropDown = DropDown()
  let cityDropDown = DropDown()



  public override func viewDidLoad() {
        super.viewDidLoad()
      dataTableView.isHidden = true
      stateView.isHidden = true

    if UIDevice.current.userInterfaceIdiom == .pad {
        self.fsPagerView.automaticSlidingInterval = 0
    }else{
        self.fsPagerView.automaticSlidingInterval = 4
    }
      var width = UIScreen.main.bounds.width
      if width > UIScreen.main.bounds.height {
          width = UIScreen.main.bounds.height
      }

      let calWidth = width
     // let aspectRatio: CGFloat = 1200.0 / 899.0   // ≈ 1.334
    let calHeight = calWidth * 1.25

      fsPagerView.interitemSpacing = 10
      fsPagerView.itemSize = CGSize(width: calWidth, height: calHeight)
      bannerHeaderView.frame = CGRect(x: 0, y: 0, width: 0, height: calHeight)

      dataTableView.tableHeaderView = bannerHeaderView
    let frameworkBundle = Bundle(for: HomeVC.self)
      dataTableView.register(UINib(nibName: eventsCell, bundle: frameworkBundle), forCellReuseIdentifier: eventsCell)

      dataTableView.register(UINib(nibName: OTTCell, bundle: frameworkBundle), forCellReuseIdentifier: OTTCell)
      dataTableView.dataSource = self
      dataTableView.delegate = self
      fsPagerView.dataSource = self
      fsPagerView.delegate = self
      getStates()
      getHomeData()

    }
  public override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)

    print("Token:=========", KableOneEventsUI.authToken())
    print("User ID:=======", KableOneEventsUI.currentUser()?.objectID ?? "nil")

  }
  func getHomeData(){
    self.isLoading = true
      self.showLoader()
      EventAPIClient.getHomeData(userId: Constants.userId, countryId:103 , stateId:stateId , cityId: cityId ){[weak self]response in
        guard self != nil else {return}
          self?.hideLoader()
          switch response{
          case .failure(let error):
              print(error.localizedDescription)
          case .success(let data):
              if data.statusCode == 401{
//                  userLogout()
                  return
              }
              if data.isSuccess,let allData = data.data{
                 print(allData)
                self?.isLoading = allData.eventDetails?.count ?? 0 < self!.pageLimit
                self?.eventsData = allData
                self?.pageControls.numberOfPages = allData.banners.count
                self?.fsPagerView.reloadData()

                self?.dataTableView.reloadData()
                self?.dataTableView.isHidden = false
              }

          }}
  }

  func getMoreEvents(typeId:Int){
    self.isLoading = true
      self.showLoader()
    EventAPIClient.getMoreEvents(userId: Constants.userId, countryId:103 , stateId:stateId , cityId: cityId, eventTypeId: typeId ,pageNo:page,pageSize:pageLimit){[weak self]response in
        guard self != nil else {return}
          self?.hideLoader()
          switch response{
          case .failure(let error):
            self?.isLoading = true
              print(error.localizedDescription)
          case .success(let data):
              if data.statusCode == 401{
//                  userLogout()
                  return
              }
              if data.isSuccess,let allData = data.dataList{
                 print(allData)
//                self?.eventsData = allData
//                self?.pageControls.numberOfPages = allData.banners.count

                self?.isLoading = allData.count < self!.pageLimit
                self?.eventsData?.eventDetails?.append(contentsOf: allData)
                self?.dataTableView.reloadData()
              }else{
                self?.isLoading = true
            }

          }}
  }
  private func getStates(){
     // guard let selectedCountry = selectedCountry else{return}
     // self.showLoader()
      EventAPIClient.getStates(countryId: "103") { result in
         // self.hideLoader()
          switch result{
          case .failure(let error):
              print(error)
          case .success(let stateResponse):
              if stateResponse.isSuccess,let data = stateResponse.dataList{
                self.statesData = data
                self.loadCityStateData()
                self.dataTableView.reloadData()

              }
          }
      }
  }

  private func getCities(stateId:String){
     // guard let selectedCountry = selectedCountry else{return}
      self.showLoader()
      EventAPIClient.getCities(stateId: stateId) { result in
          self.hideLoader()
          switch result{
          case .failure(let error):
              print(error)
          case .success(let stateResponse):
              if stateResponse.isSuccess,let data = stateResponse.dataList{
                self.citiesData = data
                self.loadCityStateData()
                self.cityId = 0
                self.cityLabel.text = "Select City"
                self.dataTableView.reloadData()

              }
          }
      }
  }
  func openDetailsVC(eventId: String?)  {
    let detailsVC = EventsDetailsViewController()
    detailsVC.hidesBottomBarWhenPushed = true
    detailsVC.eventId = eventId ?? ""
//    detailsVC.stateId = stateId
//    detailsVC.cityId = cityId
    if let navigation = self.navigationController {
      navigation.pushViewController(detailsVC, animated: true)
    } else {
      self.present(detailsVC, animated: true)
    }
  }

  func openState() {
    stateView.isHidden = false
  }
}

extension HomeVC: UITableViewDataSource, UITableViewDelegate {

  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }

  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: eventsCell) as! EventsTableVC
        cell.gotoDetail = self
        var locStr: String? = nil
        if let state = selectedStateName {
            locStr = state
            if let city = selectedCityName {
                locStr = "\(city), \(state)"
            }
        }
        cell.configure(data: eventsData,stateData: statesData, locationName: locStr)
        return cell
  } else{
    let cell = tableView.dequeueReusableCell(withIdentifier: OTTCell) as! OTTKableoneTableVC
    cell.configure(Movies: eventsData?.kableOneMovies ?? [])
    return cell
  }
  }

  public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row == 0 {
      return 700
    }else{
        return 450
      }
  }

  
  func loadMoreData(eventId: Int) {
    if !isLoading{
        page+=1
      self.getMoreEvents(typeId: eventId)
    }
  }
}
extension HomeVC: FSPagerViewDelegate{
  public func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
    self.pageControls.currentPage = targetIndex
  }
  public func pagerViewDidScroll(_ pagerView: FSPagerView) {
    self.pageControls.currentPage = pagerView.currentIndex
  }
  public func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {

  }

}
extension HomeVC: FSPagerViewDataSource{
  public func numberOfItems(in pagerView: FSPagerView) -> Int {
    return eventsData?.banners.count ?? 0
  }


  public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
    let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index) as! FSPagerVodViewCell

    let dataModel = eventsData?.banners[index]
    //if let imageUrlString = resizeImageURL(dataModel?.imageUrl, width: 100),
    cell.viewMoreButton.isHidden = !(dataModel?.showButton ?? false)
    cell.viewMoreButton.setTitle(dataModel?.btnText, for: .normal)
    if let url = URL(string: dataModel?.imageUrl ?? "") {
        cell.setImageURL(url)
    }
    cell.onViewMoreTapped = {
        print("View Show tapped")
      self.openDetailsVC(eventId: dataModel?.btnUrl)
    }
    return cell
  }
  /// Returns a URL string with the specified width, removing any existing query parameters.
  func resizeImageURL(_ urlString: String?, width: Int) -> String? {
      guard let urlString = urlString else { return nil }

      // Remove existing query parameters
      let baseUrl = urlString.components(separatedBy: "?").first ?? urlString

      // Append your desired width
      return "\(baseUrl)?im=Resize,width=\(width)"
  }

}
extension HomeVC {

  func loadCityStateData(){
    // State DropDown
  self.stateDropDown.dataSource = statesData?.map { $0.text } ?? []
    stateDropDown.anchorView = stateLabel
    stateDropDown.bottomOffset = CGPoint(x: 0, y:(stateDropDown.anchorView?.plainView.bounds.height)!)
    stateDropDown.selectionAction = { [weak self] (index: Int, item: String) in
      guard let self = self,
               let state = self.statesData?[index] else { return }
      stateLabel.text = state.text
      selectedStateName = state.text
      selectedCityName = nil
    print("Selected state:", state.text)
      stateId = Int(state.value) ?? 0
      getCities(stateId: state.value)
  }

    // City DropDown
  self.cityDropDown.dataSource = citiesData?.map { $0.text } ?? []
    cityDropDown.anchorView = cityLabel
    cityDropDown.bottomOffset = CGPoint(x: 0, y:(cityDropDown.anchorView?.plainView.bounds.height)!)
    cityDropDown.selectionAction = { [weak self] (index: Int, item: String) in
      guard let self = self,
               let city = self.citiesData?[index] else { return }
      cityLabel.text = city.text
      selectedCityName = city.text
      cityId = Int(city.value) ?? 0
      print("Selected city:", city.text)
  }

  }

  @IBAction func stateBtn(_ sender: Any) {
    stateDropDown.show()
  }
  @IBAction func cityBtn(_ sender: Any) {

//    guard let cities = citiesData, !cities.isEmpty else {
//           showAlert(message: "City list is not available. Please select state first.")
//           return
//       }
    cityDropDown.show()

  }
  @IBAction func crossBtn(_ sender: Any) {
    stateView.isHidden = true


  }
  @IBAction func submitBtn(_ sender: Any) {
    stateView.isHidden = true
    getHomeData()
  }
}
