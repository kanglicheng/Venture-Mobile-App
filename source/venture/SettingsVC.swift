//
//  SettingsVC.swift
//  venture
//
//  Created by Justin Chao on 3/17/17.
//  Copyright © 2017 Group1. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class SettingsVC: UIViewController {
    
    var alertController:UIAlertController? = nil
    var newEmail: UITextField? = nil
    var newPassword: UITextField? = nil
    
    let fbManager = FBSDKLoginManager()
    let firEmail = FIRAuth.auth()?.currentUser?.email
    
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var passButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if firEmail == nil {
            self.emailButton.setTitle("Add Email", for: [])
            self.passButton.setTitle("Add Password", for: [])
        }
    }

    
    @IBAction func changeEmail(_ sender: Any) {
        
        if firEmail != nil {
            self.alertController = UIAlertController(title: "Change Email", message: "Change your current email.", preferredStyle: UIAlertControllerStyle.alert)
        }
            
        else {
            self.alertController = UIAlertController(title: "Add an Email", message: "Add an email address to your user account.", preferredStyle: UIAlertControllerStyle.alert)
        }
        
        
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            FIRAuth.auth()?.currentUser?.updateEmail((self.newEmail?.text!)!) {
                (error) in
                if error != nil {
                    self.alertController = UIAlertController(title:"Email is already in use!", message: "", preferredStyle: UIAlertControllerStyle.alert)
                    self.present(self.alertController!, animated: true, completion: nil)
                    let cancel = UIAlertAction(title: "cancel", style: UIAlertActionStyle.cancel) {
                        (action) -> Void in
                    }
                    self.alertController!.addAction(cancel)
                }
                else {
                    print ("email updated")
                }
            }
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (action) -> Void in
        }
        
        self.alertController!.addAction(ok)
        self.alertController!.addAction(cancel)
        
        self.alertController!.addTextField { (textField) -> Void in
            self.newEmail = textField
            self.newEmail?.placeholder = "enter new email"
        }
        present(self.alertController!, animated: true, completion: nil)
    }
    
    @IBAction func changePassword(_ sender: Any) {
        
        if firEmail != nil {
            self.alertController = UIAlertController(title: "Change Password", message: "Password must be at least 6 characters long.", preferredStyle: UIAlertControllerStyle.alert)
        }
            
        else {
            self.alertController = UIAlertController(title: "Add Password", message: "Password must be at least 6 characters long.", preferredStyle: UIAlertControllerStyle.alert)
        }
        
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            FIRAuth.auth()?.currentUser?.updatePassword((self.newPassword?.text!)!) { (error) in
                if error != nil {
                    // Firebase requires a minimum length 6-characters password
                    print (error.debugDescription)
                }
                else {
                    print ("password changed")
                }
            }
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (action) -> Void in
        }
        
        self.alertController!.addAction(ok)
        self.alertController!.addAction(cancel)
        
        self.alertController!.addTextField { (textField) -> Void in
            self.newPassword = textField
            self.newPassword?.placeholder = "enter new password"
        }
        present(self.alertController!, animated: true, completion: nil)
    }
    
    @IBAction func deleteAccount(_ sender: Any) {
        
        self.alertController = UIAlertController(title: "Delete Account", message: "Are you sure you want to delete your account?", preferredStyle: UIAlertControllerStyle.alert)
        
        let ok = UIAlertAction(title: "Delete", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            
            let user = FIRAuth.auth()?.currentUser
            user?.delete { error in
                if error != nil {
                    print ("delete account error")
                } else {
                    print ("account deleted")
                   self.fbManager.logOut()
                    let storyboard: UIStoryboard = UIStoryboard(name: "login", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "Login")
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }
            }
        
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (action) -> Void in
        }
        
        self.alertController!.addAction(ok)
        self.alertController!.addAction(cancel)
        
        present(self.alertController!, animated: true, completion: nil)
        
    }
    
    
    @IBAction func logOut(_ sender: Any) {
        self.fbManager.logOut()
    }
    
}
