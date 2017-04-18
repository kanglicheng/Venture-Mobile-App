//
//  foodTableVC.swift
//  venture
//
//  Created by Connie Liu on 4/10/17.
//  Copyright © 2017 Group1. All rights reserved.
//

import UIKit

class foodTableVC: UITableViewController {

    var restaurants = [Restauraunt]()
    var eventDate:Date!

    override func viewDidLoad() {
        self.setBackground()
        super.viewDidLoad()
        self.title = "Food"
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        if parent == nil{
            restaurants.removeAll(keepingCapacity: false)
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodCell", for: indexPath) as! foodCell

        cell.foodNameLbl.text = restaurants[indexPath.row].name
        cell.foodCategoryLbl.text = restaurants[indexPath.row].category
        cell.foodRatingLbl.text = "\(restaurants[indexPath.row].rating!)"
        return cell
    }

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     if segue.identifier == "toFoodVC" {
         if let destinationVC = segue.destination as? foodVC ,
         let indexPath = self.tableView.indexPathForSelectedRow {
             let selectedFood = restaurants[indexPath.row]
                destinationVC.restaurant = selectedFood
                destinationVC.eventDate = self.eventDate
            }
        }
    }
}
