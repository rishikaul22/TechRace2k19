//
//  LeaderBoardTableViewController.swift
//  TechRace 2K19
//
//  Created by Rishi Kaul on 04/09/19.
//  Copyright © 2019 Rishi Kaul. All rights reserved.
//

import UIKit
import Firebase
class LeaderBoardTableViewController: UITableViewController {
    var users = [User]()
    var index = 0
    var timer4 : Int = 0
    var timer2 : Int = 0
    var doublepoints : Int = 0
    var invisiblepoints : Int = 0
    let colourgold = UIColor(red: 252.0/255.0, green: 220.0/255.0, blue: 0, alpha: 1.0)
    let db = Firestore.firestore()
    @IBOutlet var leaderboard: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //getLeaderListFirebase()
        db.collection("Points").document("WyuDhKbYdN5G8CflfnhU").getDocument { (document, error) in
            if let document = document, document.exists {
                self.timer4 = (document.data()!["timer4"] as! Int)
                self.timer2 = (document.data()!["timer2"] as! Int)
                self.invisiblepoints = (document.data()!["invisible"] as! Int)
                self.doublepoints = (document.data()!["double trouble"] as! Int)
            }
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
        let db = Firestore.firestore()
        db.collection("User").addSnapshotListener { (querysnapshot, error) in
            if error != nil {
                print("Error")
            }
            else {
                self.users.removeAll()
                for document in querysnapshot!.documents {
                  let name = document.data()["participantnames"] as! String
                  print(name)
                  let clues = document.data()["cluescompleted"] as! Int
                  //print(clues)
                  let timerapplied = document.data()["istimerapplied"] as! Bool
                  //print(timerapplied)
                  let timeinmilliseconds = document.data()["timeinmillisecs"] as! Int
                  //print(timeinmilliseconds)
                  let invisible = document.data()["isinvisible"] as! Bool
                  //print(invisible)
                  let email = document.data()["email"] as! String
                  //print(email)
                  let contact = document.data()["contact"] as! String
                 // print(contact)
                  let currentcluenumber = document.data()["currentcluenumber"] as! Int
                 // print(currentcluenumber)
                  let hintsleft = document.data()["hintsleft"] as! Int
                 // print(hintsleft)
                  let teamnumber = document.data()["teamnumber"] as! Int
                 // print(teamnumber)
                  let isdoubletroubletroubleused = document.data()["isdoubletroubleused"] as! Bool
                 // print(isdoubletroubletroubleused)
                  
                  let position = document.data()["position"] as! Int
                  //print(position)
                  
                  let points = document.data()["points"] as! Int
                 // print(points)
                  let currentpowercardbought = document.data()["isinvisible"] as! Int
                  //print(currentpowercardbought)
                  let wildcardentry = document.data()["wildcardentry"] as! Bool
                 // print(wildcardentry)
                  
                  let randomcluesix = document.data()["randomcluesix"] as! Int
                  //print(randomcluesix)
                  
                  let randomclueseven = document.data()["randomclueseven"] as! Int
                  //print(randomclueseven)
                  
                  let uid = document.data()["uid"] as! String
                 // print(uid)
                  //let noOfCluesCompleted = document.data()["noOfCluesCompleted"] as! Int
                    self.users.insert(User(uid: uid, participantnames: name, email: email, contact: contact, cluesCompleted: clues, currentCLueNumber: currentcluenumber, hintsLeft: hintsleft, teamNumber: teamnumber, isDoubleTroubleUsed: isdoubletroubletroubleused, isTimerApplied: timerapplied, position: position, isInvisible: invisible, currentPowerCardBought: currentpowercardbought, points: points, wildcardentry: wildcardentry, randomcluesix: randomcluesix, randomclueseven: randomclueseven, timeinmilliseconds: timeinmilliseconds), at: self.index)
                    
                    self.index += 1
                    //print(self.users)
            }
                self.index = 0
                self.users.sort(by: >)
                self.leaderboard.reloadData()
        }
            
    }
    }
  

    // MARK: - Table view data source

   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
  
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "leadercell", for: indexPath)
        let name = users[indexPath.row].participantnames
        let cluescompleted = users[indexPath.row].cluesCompleted
        let timerapplied = users[indexPath.row].isTimerApplied
        let invisible = users[indexPath.row].isInvisible
        if invisible == false {
        
            cell.textLabel?.text = String(indexPath.row + 1) + ". " + name
            cell.detailTextLabel?.text = String(cluescompleted)
            cell.backgroundColor = .black
            if timerapplied == true {
                cell.backgroundColor = .systemRed
                print("RED")
            }
        }
        else {
            cell.textLabel?.text = "I'm Invisible :))"
            cell.detailTextLabel?.text = ""
            cell.backgroundColor = colourgold
            print("GOLD")
        }
            // Configure the cell...

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if users[indexPath.row].isInvisible == true || users[indexPath.row].isTimerApplied == true {
            let cannotselect = UIAlertController(title: "Cannot add Timer", message: "", preferredStyle: .alert)
            cannotselect.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(cannotselect, animated: true, completion: nil)
        }
        else if users[indexPath.row].uid == Auth.auth().currentUser?.uid {
            displayAlertForUser(indexPath: indexPath)
        }
        else {
            displayAlertForOthers(uid: users[indexPath.row].uid)
        }
        
    }
    func displayAlertForUser(indexPath : IndexPath) {
        let alert = UIAlertController(title: "Select a Powercard", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Invisible", style: .default, handler: { (alertaction) in
            if userpoints >= self.invisiblepoints
            {
            userpoints -= self.invisiblepoints
            self.db.collection("User").document((Auth.auth().currentUser?.uid)!).updateData(["points" : userpoints
            ]) { (error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("Update Successful")
                }
            }
            self.db.collection("User").document((Auth.auth().currentUser?.uid)!).updateData(["isinvisible" : true]) { (error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("Update Successful")
                }
            }
            }
            else {
                self.lesspoints()
            }
        }))
        if users[indexPath.row].isDoubleTroubleUsed == false {
        alert.addAction(UIAlertAction(title: "Double Trouble", style: .default, handler: { (alertaction) in
           
            if userpoints >= self.doublepoints {
            userpoints -= self.doublepoints
            self.db.collection("User").document((Auth.auth().currentUser?.uid)!).updateData(["points" : userpoints
            ]) { (error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("Update Successful")
                }
            }
                self.db.collection("User").document((Auth.auth().currentUser?.uid)!).updateData(["isdoubletroubleused" : true]) { (error) in
                if let error = error  {
                    print(error)
                }
                else {
                    print("Update Successful")
                }
            }
            }
            else {
                self.lesspoints()
            }
        }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    func displayAlertForOthers(uid : String) {
        let alert = UIAlertController(title: "Add a Timer", message: "You can add a 2 or 4 minute timer", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "+2", style: .default
            , handler: { (alertaction) in
                if userpoints >= self.timer2 {
                    userpoints -= self.timer2
                    self.db.collection("User").document((Auth.auth().currentUser?.uid)!).updateData(["points" : userpoints
                    ]) { (error) in
                        if let error = error {
                            print(error)
                        }
                        else {
                            print("Update Successful")
                        }
                    }
                    self.db.collection("User").document(uid).updateData(["istimerapplied" : true]) { (error) in
                        if let error = error {
                            print(error)
                        }
                        else {
                            print("Update Successful")
                        }
                    }
                }
                else {
                    self.lesspoints()
              }
            }))
        alert.addAction(UIAlertAction(title: "+4", style: .default, handler: { (alertaction) in
            if userpoints >= self.timer4 {
                userpoints -= self.timer4
                self.db.collection("User").document((Auth.auth().currentUser?.uid)!).updateData(["points" : userpoints
                ]) { (error) in
                    if let error = error {
                        print(error)
                    }
                    else {
                        print("Update Successful")
                    }
                }
                self.db.collection("User").document(uid).updateData(["istimerapplied" : true]) { (error) in
                                       if let error = error {
                                           print(error)
                                       }
                                       else {
                                           print("Update Successful")
                                       }
                                   }
            }
            else {
                self.lesspoints()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    func lesspoints() {
        let insufficientpoints = UIAlertController(title: "Insufficient Points", message: "", preferredStyle: .alert)
        insufficientpoints.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(insufficientpoints, animated: true, completion: nil)
        
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getLeaderListFirebase() {
        let db = Firestore.firestore()
        db.collection("User").getDocuments { (querysnapshot, error) in
            if let error = error {
                print("Error getting list")
                print(error)
            }
            else {
                for document in querysnapshot!.documents {
                    
                    let name = document.data()["participantnames"] as! String
                    //print(name)
                    let clues = document.data()["cluescompleted"] as! Int
                    //print(clues)
                    let timerapplied = document.data()["istimerapplied"] as! Bool
                    //print(timerapplied)
                    let timeinmilliseconds = document.data()["timeinmillisecs"] as! Int
                    //print(timeinmilliseconds)
                    let invisible = document.data()["isinvisible"] as! Bool
                    //print(invisible)
                    let email = document.data()["email"] as! String
                    //print(email)
                    let contact = document.data()["contact"] as! String
                   // print(contact)
                    let currentcluenumber = document.data()["currentcluenumber"] as! Int
                   // print(currentcluenumber)
                    let hintsleft = document.data()["hintsleft"] as! Int
                   // print(hintsleft)
                    let teamnumber = document.data()["teamnumber"] as! Int
                    //print(teamnumber)
                    let isdoubletroubletroubleused = document.data()["isdoubletroubleused"] as! Bool
                    //print(isdoubletroubletroubleused)
                    
                    let position = document.data()["position"] as! Int
                   // print(position)
                    
                    let points = document.data()["points"] as! Int
                    //print(points)
                    let currentpowercardbought = document.data()["isinvisible"] as! Int
                    //print(currentpowercardbought)
                    let wildcardentry = document.data()["wildcardentry"] as! Bool
                    //print(wildcardentry)
                    
                    let randomcluesix = document.data()["randomcluesix"] as! Int
                    //print(randomcluesix)
                    
                    let randomclueseven = document.data()["randomclueseven"] as! Int
                    //print(randomclueseven)
                    
                    let uid = document.data()["uid"] as! String
                   // print(uid)
                    //let noOfCluesCompleted = document.data()["noOfCluesCompleted"] as! Int
                    self.users.insert(User(uid: uid, participantnames: name, email: email, contact: contact, cluesCompleted: clues, currentCLueNumber: currentcluenumber, hintsLeft: hintsleft, teamNumber: teamnumber, isDoubleTroubleUsed: isdoubletroubletroubleused, isTimerApplied: timerapplied, position: position, isInvisible: invisible, currentPowerCardBought: currentpowercardbought, points: points, wildcardentry: wildcardentry, randomcluesix: randomcluesix, randomclueseven: randomclueseven, timeinmilliseconds: timeinmilliseconds), at: self.index)
                    self.index += 1
                  
                    
                }
                self.users.sort(by: >)
                self.index = 0
            }
        }
    }
    
}

