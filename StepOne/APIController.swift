//
//  APIController.swift
//  StepOne
//
//  Created by RYPE on 25/04/2015.
//  Copyright (c) 2015 RYPE. All rights reserved.
//

import Foundation

/**************************************************************************************************/
// Protocol
/**************************************************************************************************/
protocol APIControllerProtocol {
    func didReceiveAPIResults(results: NSArray)
}

/**************************************************************************************************/
// Class
/**************************************************************************************************/
class APIController {

    /*************************************************/
    // Main
    /*************************************************/
    
    // Var
    /*************************/
    var delegate: APIControllerProtocol
    
    // init
    /*************************/
    init(delegate: APIControllerProtocol) {
        self.delegate = delegate
    }
    
    /*************************************************/
    // Functions
    /*************************************************/
    
    func searchItunesFor(searchTerm: String) {
        // The iTunes API wants multiple terms separated by + symbols, so replace spaces with + signs
        let itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        
        // Now escape anything else that isn't URL-friendly
        if let escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet()) {
            let urlPath = "https://itunes.apple.com/search?term=\(escapedSearchTerm)&amp;media=music&amp;entity=album"
            let url = NSURL(string: urlPath)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
                print("Task completed")
                if(error != nil) {
                    // If there is an error in the web request, print it to the console
                    print(error!.localizedDescription)
                }
                do {
                    let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    if let results: NSArray = jsonResult["results"] as? NSArray {
                        self.delegate.didReceiveAPIResults(results)
                    }
                } catch let error as NSError {
                    print(error.description)
                }
            })
            
            // The task is just an object with all these properties set
            // In order to actually make the web request, we need to "resume"
            task.resume()
        }
    }
    
}

