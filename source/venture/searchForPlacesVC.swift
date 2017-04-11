//
//  searchForPlacesVC.swift
//  venture
//
//  Created by Julianne Crea on 4/8/17.
//  Copyright © 2017 Group1. All rights reserved.
//

import UIKit
import YelpAPI
import BrightFutures

class searchForPlacesVC: UIViewController, UITableViewDelegate {
    
    var places = [String]()

    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var ratingField: UITextField!
    
    let myRequest = DispatchGroup()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search for Places"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
    @IBAction func getPlaces(_ sender: Any) {
        myRequest.enter()
        let appId = "7MvZ6dze7A0CJ7LnQqzeeA"
        let appSecret = "NqyyQzN25eWVlUhAa5SCius0uNNqd3DS2DDDBUwrQLd3dftFnwr3BySJXBZr7KzA"
        
        // Search for 3 dinner restaurants in user-defined location
        let query = YLPQuery(location: locationField.text!)
        query.term = "dinner"
        query.limit = 3
        var businessName:String?
       
        YLPClient.authorize(withAppId: appId, secret: appSecret).flatMap { client in
            client.search(withQuery: query)
            }.onSuccess { search in
                if let topBusiness = search.businesses.first {
                    businessName = topBusiness.name
                    print("Top business: \(topBusiness.name)")
                    self.myRequest.leave()
                } else {
                    businessName = "none found"
                    print("None found")
                }
                //exit(EXIT_SUCCESS)
            }.onFailure { error in
                print("Search errored: \(error)")
                //exit(EXIT_FAILURE)
        }
        
        myRequest.notify(queue: DispatchQueue.main, execute: {
            print("Finished all requests.")
            print(self.places)
            self.places.append(businessName!)
            self.segueToTable()
        })
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toPlaces" {
//            if let destinationVC = segue.destination as? placesTableVC {
//                // pass array to table VC
//                destinationVC.locales = places
//            }
//        }
//    }
    
    func segueToTable() {
        let vc = UIStoryboard(name:"places", bundle:nil).instantiateViewController(withIdentifier: "placesTable") as! placesTableVC
        vc.locales = self.places
        self.show(vc, sender: self)
//        self.navigationController?.pushViewController(vc, animated:true)
    }

}
