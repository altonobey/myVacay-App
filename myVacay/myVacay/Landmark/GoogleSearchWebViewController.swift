//
//  GoogleSearchWebViewController.swift
//  myVacay
//
//  Created by Ahmed AlTonobey and Nolan Turley on 11/7/18.
//  Copyright © 2018 Ahmed AlTonobey. All rights reserved.
//

import UIKit
import WebKit

class GoogleSearchWebViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet var webView: WKWebView!
    
    // The value of this instance variable is set by the upstream view controller (TableViewController) object.
    var landmark: String = ""
    
    override func viewDidLoad() {
        webView.navigationDelegate = self
        
        // Set this view's title to be the selected country name
        self.title = landmark
        
        /*
         We compose a Google Maps API query by using the selected country name.
         We ask the webView object to send the query to Google Maps API, obtain the map, and display it.
         The query cannot contain spaces. Therefore, we replace all spaces in a country name, if any, with "+".
         */
        let landmarkNameWithNoSpaces = landmark.replacingOccurrences(of: " ", with: "+", options: [], range: nil)
        
        /*
         Convert the Google Maps API query string into an NSURL object and store its object
         reference into the local variable url. An NSURL object represents a URL.
         */
        let url = URL(string: "https://www.google.com/search?q=" + landmarkNameWithNoSpaces)
        
        /*
         Convert the NSURL object into an NSURLRequest object and store its object
         reference into the local variable request. An NSURLRequest object represents
         a URL load request in a manner independent of protocol and URL scheme.
         */
        let request = URLRequest(url: url!)
        
        // Ask the webView object to fetch and display the map of the selected country
        webView.load(request)
    }
    
    /*
     ---------------------------------------------
     MARK: - WKNavigationDelegate Protocol Methods
     ---------------------------------------------
     */
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // Starting to load the web page. Show the animated activity indicator in the status bar
        // to indicate to the user that the UIWebVIew object is busy loading the web page.
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Finished loading the web page. Hide the activity indicator in the status bar.
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        /*
         Ignore this error if the page is instantly redirected via JavaScript or in another way.
         NSURLErrorCancelled is returned when an asynchronous load is cancelled, which happens
         when the page is instantly redirected via JavaScript or in another way.
         */
        
        if (error as NSError).code == NSURLErrorCancelled  {
            return
        }
        
        // An error occurred during the web page load. Hide the activity indicator in the status bar.
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        // Create the error message in HTML as a character string and store it into the local constant errorString
        let errorString = "<html><font size=+4 color='red'><p>Unable to Display Webpage: <br />Possible Causes:<br />- No network connection<br />- Wrong URL entered<br />- Server computer is down</p></font></html>" + error.localizedDescription
        
        // Display the error message within the UIWebView object
        // self. is required here since this method has a parameter with the same name.
        self.webView.loadHTMLString(errorString, baseURL: nil)
    }
}
