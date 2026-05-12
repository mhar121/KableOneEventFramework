//
//  WebViewViewController.swift
//  KableOne Events
//
//  Created by Muhammad Haris on 19/12/2025.
//

import UIKit
import WebKit
@_exported import Razorpay
public class WebViewViewController: BaseViewController, WKUIDelegate, RazorpayPaymentCompletionProtocolWithData {

  @IBOutlet weak var webView: WKWebView!
  var eventDetails: EventDetail?
  var createOrder:OrderModel?
  var selectedSlotId: Int?
  var selectedScreenId: String?
  private var razorpay: RazorpayCheckout?
  var booking: OnBookingDataModel?

  public init() {
    let bundle = Bundle(for: WebViewViewController.self)
    super.init(nibName: "WebViewViewController", bundle: bundle)
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  public override func viewDidLoad() {
    super.viewDidLoad()
    //razorpay = RazorpayCheckout.initWithKey(Constants.rpayKey, andDelegateWithData: self)
    setupWebView()
    loadURL()
  }

  func setupWebView() {
      let controller = webView.configuration.userContentController
    // Remove old scripts / handlers
        controller.removeAllUserScripts()
        controller.removeScriptMessageHandler(forName: "onBookingData")
        controller.removeScriptMessageHandler(forName: "onGoBack")

        // Add handlers
        controller.add(self, name: "onBookingData")
        controller.add(self, name: "onGoBack")

      // --- Inject viewport meta to stop zoom ---
      let viewportJS = """
      var meta = document.querySelector('meta[name=viewport]');
      if (!meta) {
          meta = document.createElement('meta');
          meta.name = 'viewport';
          document.head.appendChild(meta);
      }
      meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
      """
      let viewportScript = WKUserScript(
          source: viewportJS,
          injectionTime: .atDocumentEnd,
          forMainFrameOnly: true
      )
      controller.addUserScript(viewportScript)

      // --- Force input fields font-size ≥ 16px ---
      let fontFixJS = """
      var style = document.createElement('style');
      style.innerHTML = 'input, textarea, select { font-size:16px !important; }';
      document.head.appendChild(style);
      """
      let fontScript = WKUserScript(
          source: fontFixJS,
          injectionTime: .atDocumentEnd,
          forMainFrameOnly: true
      )
      controller.addUserScript(fontScript)

      // --- WebView delegates ---
      webView.navigationDelegate = self
      webView.uiDelegate = self
      webView.scrollView.delegate = self

      // --- Zoom & scrolling behavior ---
      webView.allowsBackForwardNavigationGestures = true
      webView.scrollView.maximumZoomScale = 1.0
      webView.scrollView.minimumZoomScale = 1.0
      webView.scrollView.contentInsetAdjustmentBehavior = .never
      webView.scrollView.bounces = false
      webView.scrollView.pinchGestureRecognizer?.isEnabled = false
      webView.scrollView.keyboardDismissMode = .interactive

      // --- Custom User Agent ---
      let systemVersion = UIDevice.current.systemVersion
      let customUA = "kableoneDevice=MobileApp; os=ios; osVersion=\(systemVersion); deviceType=ios; appVersion=1.0"
      webView.customUserAgent = customUA

      if #available(iOS 16.4, *) {
          webView.isInspectable = true
      }
  }

  private func loadURL() {
    let eventId = eventDetails?.eventId ?? ""
    let venueId = eventDetails?.venueId ?? ""
    let venueType = eventDetails?.venueType ?? ""
    let slotId = selectedSlotId ?? 0
    let screenId = selectedScreenId ?? ""
    let userId = Constants.userId
    //https://event.kableone.com/
   // https://testevent.kableone.com
    if let url = URL(string:"https://testevent.kableone.com/booking/?" +
                     "EventId=\(eventId)" +
                     "&VenueId=\(venueId)" +
                     "&VenueType=\(venueType)" +
                     "&SlotId=\(slotId)" +
                     "&ScreenId=\(screenId)" +
                     "&UserId=\(userId)") {
      print("Booking URL:", url)
      var request = URLRequest(url: url)


      request.setValue(Constants.token, forHTTPHeaderField: "Authorization")
      webView.load(request)
    }
  }

}

// MARK: - WKNavigationDelegate & JS Bridge
extension WebViewViewController: WKNavigationDelegate, WKScriptMessageHandler {


  public func userContentController(_ userContentController: WKUserContentController,
                                    didReceive message: WKScriptMessage) {

      switch message.name {

      case "onBookingData":
          guard let body = message.body as? [String: Any] else { return }

          do {
              print("JS DATA RECEIVED:", message.body)
              let jsonData = try JSONSerialization.data(withJSONObject: body)
              let bookingPayload = try JSONDecoder().decode(OnBookingDataModel.self, from: jsonData)

              // Store Data
              self.booking = bookingPayload

              print("Stored Booking:", bookingPayload.order?.eventTitle ?? "")

              if booking?.order?.isPaid ?? true {
                  print("Paid Event")
                  createOrderApi()
              } else {
                  print("Free Event")
                  bookFreeApi()
              }

          } catch {
              print("Decode error:", error)
          }

      case "onGoBack":
          guard let body = message.body as? [String: Any] else { return }

          print("Go Back Data:", body)

          let isForbidden = body["isForbidden"] as? Bool ?? false
          let action = body["action"] as? String ?? ""

          if isForbidden && action == "Back" {
              print("Back action received")
              self.navigationController?.popViewController(animated: true)
              // OR dismiss(animated: true)
          }

      default:
          break
      }
  }

  public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    showLoader()
    print("Page loading started")
  }

  public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    hideLoader()
    print("Page loading finished")
  }

  public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    hideLoader()
    print("Failed with error: \(error.localizedDescription)")
  }

  public func webView(
          _ webView: WKWebView,
          didReceive challenge: URLAuthenticationChallenge,
          completionHandler: @escaping (
              URLSession.AuthChallengeDisposition,
              URLCredential?
          ) -> Void
      ) {

          guard challenge.protectionSpace.authenticationMethod ==
                  NSURLAuthenticationMethodServerTrust,
                let serverTrust = challenge.protectionSpace.serverTrust
          else {

              completionHandler(.performDefaultHandling, nil)
              return
          }


        let credential = URLCredential(trust: serverTrust)
        completionHandler(.useCredential, credential)
      }
}

extension WebViewViewController{
  func createOrderApi() {
      showLoader()
      EventAPIClient.createOrder(
          userId: booking?.userId ?? "",
          sessionId: booking?.sessionId ?? "",
          couponCode: booking?.couponCode ?? ""
      ) { [weak self] result in
          guard let self = self else { return }
          self.hideLoader()
          switch result {
          case .failure(let error):
              print(error)
          case .success(let response):
              switch response.statusCode {
              case 200:
                // 100% off on coupon code
                self.showSuccessAlert()

              case 201:
                  guard response.isSuccess, let data = response.data else { return }
                  self.createOrder = data
                  self.startPayment(orderId: data.orderId)

              default:
                  print("Unhandled status code:", response.statusCode)
              }
          }
      }
  }
  func verifyPaymentApi(paymentid: String, orderId: String, signatureId: String){
    self.showLoader()
    EventAPIClient.verifyPayment(userId: booking?.userId ?? "", sessionId: booking?.sessionId ?? "", razorPaymentId: paymentid, relationId: createOrder?.relationId ?? "", razorOrderId: orderId, signature: signatureId) { result in
      self.hideLoader()
      switch result{
      case .failure(let error):
        print(error)
      case .success(let stateResponse):
        if stateResponse.isSuccess{
          self.showSuccessAlert()
        }
      }
    }
  }

  func bookFreeApi(){
    self.showLoader()
    EventAPIClient.bookFreeSeats(userId: booking?.userId ?? "", sessionId: booking?.sessionId ?? "") { result in
      self.hideLoader()
      switch result{
      case .failure(let error):
        print(error)
      case .success(let stateResponse):
        if stateResponse.isSuccess,let data = stateResponse.data{
          self.showSuccessAlert()
        }
      }
    }
  }

  func goToHome() {
      DispatchQueue.main.async {

          // 1️⃣ Dismiss Razorpay / modal if any
          self.dismiss(animated: false)

          // 2️⃣ Find TabBarController
          guard let windowScene = UIApplication.shared.connectedScenes
              .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
                let window = windowScene.windows.first,
                let tabBarController = window.rootViewController as? UITabBarController
          else {
              return
          }

          // 3️⃣ Switch to Home tab (usually index 0)
          tabBarController.selectedIndex = 0

          // 4️⃣ Pop to HomeVC inside navigation controller
          if let navController = tabBarController.selectedViewController as? UINavigationController {
              navController.popToRootViewController(animated: false)
          }

          // 5️⃣ Ensure tab bar is visible
          tabBarController.tabBar.isHidden = false
      }
  }

  func showSuccessAlert(){
    self.showAlert(
      title: "Successful",
      message: "Your booking has been completed successfully."
    ) {
      self.goToHome()
    }
  }



}

extension WebViewViewController {

  public func onPaymentSuccess(_ payment_id: String,
                               andData response: [AnyHashable : Any]?) {
    print(" Payment Success")
    print("Payment ID:", payment_id)
    print("Response:", response ?? [:])

    guard let response = response else { return }

    let paymentId = response["razorpay_payment_id"] as? String
    let orderId = response["razorpay_order_id"] as? String
    let signatureId = response["razorpay_signature"] as? String

    guard let pId = paymentId,
          let oId = orderId,
          let sId = signatureId else {
      print("❌ Missing Razorpay payment data")
      return
    }

    // Call your verification API
    verifyPaymentApi(paymentid: pId,
                     orderId: oId,
                     signatureId: sId)
  }

  public func onPaymentError(_ code: Int32,
                             description str: String,
                             andData response: [AnyHashable : Any]?) {
    print(" Payment Failed")
    print("Code:", code)
    print("Description:", str)
    print("Response:", response ?? [:])
    self.showAlert(
      title: "Payment Failed",
      message: "Something went wrong. Please try again."
    ) {
      //self.goToHome()
    }

  }
  func showAlert(
    title: String,
    message: String,
    okTitle: String = "OK",
    onOk: (() -> Void)? = nil
  ) {
    DispatchQueue.main.async {

      let alert = UIAlertController(
        title: title,
        message: message,
        preferredStyle: .alert
      )

      let okAction = UIAlertAction(title: okTitle, style: .default) { _ in
        onOk?()
      }

      alert.addAction(okAction)

      // Present safely
      if let presentedVC = self.presentedViewController {
        presentedVC.dismiss(animated: false) {
          self.present(alert, animated: true)
        }
      } else {
        self.present(alert, animated: true)
      }
    }
  }


  private func startPayment(orderId:String) {
    razorpay = RazorpayCheckout.initWithKey(createOrder?.key ?? "", andDelegateWithData: self)
    let options: [String: Any] = [
      "key":createOrder?.key ?? "",
      "description": "KableOne Events Ticket Booking System",
      "image": "https://images.kableone.com/Images/WImg/fab_black.png",
      "name": "KableOne Events",
      "order_id":orderId,
      "prefill": [
                  "contact": KableOneEventsUI.currentUser()?.mobile ?? ""

              ]
    ]

    DispatchQueue.main.async {
      print("Option: \(options)")
      print("Razorpay instance:", self.razorpay as Any)
      if let rzp = self.razorpay {
        rzp.open(options, displayController: self)
      } else {
        print("Unable to initialize")
      }
    }
  }

}
extension WebViewViewController: UIScrollViewDelegate {
  public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
}
