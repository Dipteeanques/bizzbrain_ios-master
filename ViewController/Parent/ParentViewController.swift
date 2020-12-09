//
//  ParentViewController.swift
//  bizzbrains
//
//  Created by Kalu's mac on 28/01/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire

class ParentViewController: UIViewController {
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var collectionSelected: UICollectionView!
    
    var arrCategory = [["icon":#imageLiteral(resourceName: "attendances"),"name":"Attendances"],["icon":#imageLiteral(resourceName: "examshedule"),"name":"Date sheet"],["icon":#imageLiteral(resourceName: "notice"),"name":"Notification"],["icon":#imageLiteral(resourceName: "assignment"),"name":"Assignments"],["icon":#imageLiteral(resourceName: "examresult"),"name":"Exam Result"],["icon":#imageLiteral(resourceName: "help_desk"),"name":"Help desk"],["icon":#imageLiteral(resourceName: "events"),"name":"Events"],["icon":#imageLiteral(resourceName: "timetable"),"name":"Timetable"],["icon":#imageLiteral(resourceName: "student_info"),"name":"Student info"],["icon":#imageLiteral(resourceName: "vendors_new"),"name":"Dress vendors"],["icon":#imageLiteral(resourceName: "ic_transport"),"name":"Transport details"],["icon":#imageLiteral(resourceName: "VideoLecture"),"name":"Video Lecture"],["icon":#imageLiteral(resourceName: "documents-symbol"),"name":"Note/Exam Paper"],["icon":#imageLiteral(resourceName: "message"),"name":"Logout"]]
    
    var url: URL?
    var wc = Webservice.init()
    var mobile = String()
    var arrFilterSearchDatum = [FilterSearchDatum]()
    var id = Int()
    let appDel = UIApplication.shared.delegate as! AppDelegate
    var selectedProfile = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.StudentSelection), name: NSNotification.Name(rawValue: "StudentSelection"), object: nil)
        setdefault()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionSelected.reloadData()
    }
    
    @objc func StudentSelection(notification: NSNotification) {
        setdefault()
    }
    
    
    func setdefault() {
        let schoolLogo = loggdenUser.value(forKey: SCHOOL_LOGO)as! String
        url = URL(string: schoolLogo)
        logoImg.sd_setImage(with: url, completed: nil)
        
        lblName.text = loggdenUser.value(forKey: NAME)as? String
        
        let proimage = loggdenUser.value(forKey: PROFILE_IMAGE)as! String
        url = URL(string: proimage)
        imgProfile.sd_setImage(with: url, completed: nil)
        
        mobile = loggdenUser.value(forKey: PHONE_NUMBER) as! String
        id = loggdenUser.value(forKey: STUDENT_ID)as! Int
        getstudent()
    }
    
    func getstudent() {
        let param = ["mobile_number": mobile]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let headers: HTTPHeaders = ["Xapi": Xapi,
                                    "Authorization":token]
        
        wc.callSimplewebservice(url: STUDENT_GET, parameters: param, headers: headers, fromView: self.view, isLoading: true) { (success, response: FilterSearchStudentGetResponseModel?) in
            if success {
                let suc = response?.success
                if suc == true {
                    self.arrFilterSearchDatum = response!.data
                    self.collectionSelected.reloadData()
                }
                else {
                    print("jekil")
                }
            }
        }
    }
    
    @IBAction func btnStudentAction(_ sender: UIButton) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "StudentSelectionViewController")as! StudentSelectionViewController
        obj.arrFilterSearchDatum = arrFilterSearchDatum
        self.navigationController?.pushViewController(obj, animated: true)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension ParentViewController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionview {
            return arrCategory.count
        }
        return arrFilterSearchDatum.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionview {
            let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! IconCollectionViewCell
            cell.img.image = (self.arrCategory[indexPath.row]as AnyObject).value(forKey: "icon") as? UIImage
            cell.lblName.text = (self.arrCategory[indexPath.row]as AnyObject).value(forKey: "name")as? String
            return cell
        }
        else {
            let cell = collectionSelected.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! SelectedStudentCollectionViewCell
            if arrFilterSearchDatum[indexPath.row].name == lblName.text {
                cell.imgProfile.layer.borderWidth = 5
                cell.imgProfile.layer.borderColor = UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1).cgColor
            }
            else {
                cell.imgProfile.layer.borderWidth = 0
                cell.imgProfile.layer.borderColor = UIColor.clear.cgColor
            }
            cell.lblName.text = arrFilterSearchDatum[indexPath.row].name
            let strImage = arrFilterSearchDatum[indexPath.row].profile
            url = URL(string: strImage)
            cell.imgProfile.sd_setImage(with: url, completed: nil)
            cell.imgProfile.layer.cornerRadius = 35
            cell.imgProfile.clipsToBounds = true
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionview {
            if indexPath.row == 0 {
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "AttendanceViewController")as! AttendanceViewController
                obj.arrFilterSearchDatum = arrFilterSearchDatum
                self.navigationController?.pushViewController(obj, animated: true)
            }
            else if indexPath.row == 1 {
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "DateSheetViewController")as! DateSheetViewController
                obj.arrFilterSearchDatum = arrFilterSearchDatum
                self.navigationController?.pushViewController(obj, animated: true)
            }
            else if indexPath.row == 2 {
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "NoticeViewController")as! NoticeViewController
                obj.arrFilterSearchDatum = arrFilterSearchDatum
                self.navigationController?.pushViewController(obj, animated: true)
            }
            else if indexPath.row == 3 {
//                let obj = self.storyboard?.instantiateViewController(withIdentifier: "AssignmentViewController")as! AssignmentViewController
//                obj.arrFilterSearchDatum = arrFilterSearchDatum
//                self.navigationController?.pushViewController(obj, animated: true)
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "SubjectViewController")as! SubjectViewController
                 obj.assignment = "assignment"
                self.navigationController?.pushViewController(obj, animated: true)
            }
            else if indexPath.row == 4 {
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "ExamResultListViewController")as! ExamResultListViewController
                obj.arrFilterSearchDatum = arrFilterSearchDatum
                self.navigationController?.pushViewController(obj, animated: true)
            }
            else if indexPath.row == 5 {
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "HelpDeskViewController")as! HelpDeskViewController
                self.navigationController?.pushViewController(obj, animated: true)
            }
            else if indexPath.row == 6 {
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "UpcommingEventViewController")as! UpcommingEventViewController
                obj.arrFilterSearchDatum = arrFilterSearchDatum
                self.navigationController?.pushViewController(obj, animated: true)
            }
            else if indexPath.row == 7 {
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "TimetableViewController")as! TimetableViewController
                obj.arrFilterSearchDatum = arrFilterSearchDatum
                self.navigationController?.pushViewController(obj, animated: true)
            }
            else if indexPath.row == 8 {
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "StudentInfoViewController")as! StudentInfoViewController
                obj.arrFilterSearchDatum = arrFilterSearchDatum
                self.navigationController?.pushViewController(obj, animated: true)
            }
            else if indexPath.row == 9 {
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "DressVendorViewController")as! DressVendorViewController
                obj.arrFilterSearchDatum = arrFilterSearchDatum
                self.navigationController?.pushViewController(obj, animated: true)
            }
            else if indexPath.row == 10 {
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "TransportdetailsViewController")as! TransportdetailsViewController
                obj.arrFilterSearchDatum = arrFilterSearchDatum
                self.navigationController?.pushViewController(obj, animated: true)
            }
            else if indexPath.row == 11 {
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "SubjectViewController")as! SubjectViewController
                obj.assignment = "VideoSubject"
                self.navigationController?.pushViewController(obj, animated: true)
            }
            else if indexPath.row == 12 {
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "SubjectViewController")as! SubjectViewController
                self.navigationController?.pushViewController(obj, animated: true)
            }
            else if indexPath.row == 13 {
                let uiAlert = UIAlertController(title: "Bizzbrains", message: "Are you sure! Do you want to Logout?", preferredStyle: UIAlertController.Style.alert)
                self.present(uiAlert, animated: true, completion: nil)
                uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    loggdenUser.set(false, forKey: PARENT_ISLOGIN)
                    loggdenUser.removeObject(forKey: PHONE_NUMBER)
                    loggdenUser.removeObject(forKey: PROFILE_IMAGE)
                    loggdenUser.removeObject(forKey: SCHOOL_LOGO)
                    loggdenUser.removeObject(forKey: NAME)
                    loggdenUser.removeObject(forKey: TOKEN)
                    loggdenUser.removeObject(forKey: STUDENT_ID)
                    self.appDel.gotoLogin()
                }))
                uiAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                }))
            }
            else {
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "DateSheetViewController")as! DateSheetViewController
                obj.arrFilterSearchDatum = arrFilterSearchDatum
                self.navigationController?.pushViewController(obj, animated: true)
            }
        }
        else {
            selectedProfile = indexPath.row
            let selected = arrFilterSearchDatum[indexPath.row]
            loggdenUser.set(selected.profile, forKey: PROFILE_IMAGE)
            loggdenUser.set(selected.name, forKey: NAME)
            loggdenUser.set(selected.id, forKey: STUDENT_ID)
            setdefault()
            collectionSelected.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.size.width / 3.0
        return CGSize(width: width, height: width)
    }
}


