//
//  ConversationsVC.swift
//  bizzbrains
//
//  Created by Anques on 24/12/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import UIKit
import JJFloatingActionButton
import Alamofire
import Firebase
import FirebaseCore

class ConversationsVC: UIViewController {

    var wc = Webservice.init()
    var arrTeacherListData : TeacherListRoot?
    var conversationList = [String:String]()
    var arrConversationList = [[String:String]]()
    var filteredTeacherListData : [TeacherListData]?
    
    @IBOutlet weak var transperentView: UIView!{
        didSet{
            transperentView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        }
    }
    
    @IBOutlet weak var tblConversations: UITableView!
    
    //MARK: select Teacher
    @IBOutlet weak var viewSub: UIView!{
        didSet{
            viewSub.layer.cornerRadius = 2.0
            viewSub.clipsToBounds = true
        }
    }
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblTeacher: UITableView!
    
    
    let actionButton = JJFloatingActionButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        

        searchBar.delegate = self
//        self.navigationController?.isNavigationBarHidden = true
        actionButton.buttonColor = .red
        actionButton.addItem(title: "Heart", image: UIImage(named: "plus")) { item in
            self.transperentView.isHidden = false
        }
        actionButton.display(inViewController: self)
        
        GetTeacherList()
        getConversationsList()
    }
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        // Show the navigation bar on other view controllers
//        self.navigationController?.isNavigationBarHidden = true
//    }
        
    func getConversationsList(){
        
        let  ref: DatabaseReference?
        let handle: DatabaseHandle?
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)

        ref = Database.database().reference()

        let firebaseId = loggdenUser.value(forKey:SENDER_ID)
        print(firebaseId)

       let handle1 = ref?.child("Inbox").child(firebaseId as! String).observe(.childAdded, with: { (snapshot) in
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)

            print("snapshot:",snapshot.value)
            if  let data        = snapshot.value as? [String: Any]
            {
//                print("snapshotdata:",data)
                let chatdata = data as? [String:String]
                print("date:",chatdata)
                print(chatdata?["date"])
                self.conversationList = ["date":(chatdata?["date"] ?? ""), "msg":(chatdata?["msg"] ?? ""), "name":(chatdata?["name"] ?? ""), "rid":(chatdata?["rid"] ?? ""), "status":(chatdata?["status"] ?? ""), "timestamp":(chatdata?["timestamp"] ?? "")]
                self.arrConversationList.append(self.conversationList)
                self.tblConversations.reloadData()
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                }
            }
        })
        
        
        
        
        
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
        }

    }
    
    @IBAction func btnHideTransperentView(_ sender: Any) {
        transperentView.isHidden = true
    }
    
    @IBAction func btn_backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func GetTeacherList() {
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let headers: HTTPHeaders = ["Xapi": Xapi,
                                    "Authorization":token]
       
        wc.callSimplewebservice(url: getTeacherList, parameters: [:], headers: headers, fromView: self.view, isLoading: true) { (success, response:TeacherListRoot?) in
            if success {
                print("response:",response)
                let suc = response?.success
                if suc == true {
                    self.arrTeacherListData = response!
                    self.filteredTeacherListData = self.arrTeacherListData?.data
                    self.tblTeacher.reloadData()
                }
                else {
                    print("jekil")
                }
            }
            else{

            }
        }
    }
}

extension ConversationsVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblTeacher {
            return self.filteredTeacherListData?.count ?? 0
        }
        else{
            return self.arrConversationList.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ConversationsCell
        if tableView == self.tblTeacher{
            cell.lblName.text = self.filteredTeacherListData?[indexPath.row].name
        }
        else{
            print(self.conversationList)
//            cell.lblTimeInfo.text = "test"//self.conversationList["timestamp"]
            cell.lblTimeInfo.isHidden = true
            cell.lblUserName.text = self.arrConversationList[indexPath.row]["name"]//self.conversationList["name"]
            cell.lblType.text = self.arrConversationList[indexPath.row]["msg"]//self.conversationList["msg"]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tblTeacher{
            let loadVC = ChatVC()
            loggdenUser.setValue(self.filteredTeacherListData?[indexPath.row].firebase_id, forKey: RECIEVER_ID)
            loadVC.strChatId = ((loggdenUser.value(forKey:SENDER_ID) as! String) + "-" + (self.filteredTeacherListData?[indexPath.row].firebase_id)!)
            loadVC.userName = self.filteredTeacherListData?[indexPath.row].name ?? ""
            navigationController?.pushViewController(loadVC, animated: false)
        }
        else{
            let loadVC = ChatVC()
            loggdenUser.setValue(self.arrConversationList[indexPath.row]["rid"], forKey: RECIEVER_ID)
            loadVC.strChatId = ((loggdenUser.value(forKey:SENDER_ID) as! String) + "-" + (self.arrConversationList[indexPath.row]["rid"]!))
            loadVC.userName = self.arrConversationList[indexPath.row]["name"] ?? ""
            navigationController?.pushViewController(loadVC, animated: false)
        }
    }
    

    
}

extension ConversationsVC: UISearchBarDelegate{
    // This method updates filteredData based on the text in the Search Box
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        guard !searchText.isEmpty  else { filteredTeacherListData = arrTeacherListData?.data
            tblTeacher.reloadData(); return }
        
        filteredTeacherListData = arrTeacherListData?.data.filter({ user -> Bool in
            return user.name.lowercased().contains(searchText.lowercased())
        })
        tblTeacher.reloadData()
    }
}
