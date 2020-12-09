//
//  StudentZoneViewController.swift
//  bizzbrains
//
//  Created by Kalu's mac on 14/02/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import UIKit

class StudentZoneViewController: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    var arrCategory = [["icon":#imageLiteral(resourceName: "ProfileMenu"),"name":"Student Profile"],["icon":#imageLiteral(resourceName: "event"),"name":"Upcoming Events"],["icon":#imageLiteral(resourceName: "assign"),"name":"Assignments"],["icon":#imageLiteral(resourceName: "calendar"),"name":"Timetable"],["icon":#imageLiteral(resourceName: "calendar"),"name":"Date Sheet"],["icon":#imageLiteral(resourceName: "exam-1"),"name":"Exam Results"],["icon":#imageLiteral(resourceName: "exam"),"name":"Attendences"],["icon":#imageLiteral(resourceName: "documents-symbol"),"name":"Note/Exam Paper"],["icon":#imageLiteral(resourceName: "fashion"),"name":"Dress Vendors"],["icon":#imageLiteral(resourceName: "ic_transport"),"name":"Transport details"],["icon":#imageLiteral(resourceName: "VideoLecture"),"name":"Video Lecture"]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
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

extension StudentZoneViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! tblstudentZoneCell
        cell.icon.image = (arrCategory[indexPath.row]as AnyObject).value(forKey: "icon") as? UIImage
        cell.lblTitle.text = (arrCategory[indexPath.row]as AnyObject).value(forKey: "name") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "StudentInfoViewController")as! StudentInfoViewController
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 1 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "UpcommingEventViewController")as! UpcommingEventViewController
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 2 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "SubjectViewController")as! SubjectViewController
            obj.assignment = "assignment"
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 3 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "TimetableViewController")as! TimetableViewController
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 4 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "DateSheetViewController")as! DateSheetViewController
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 5 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "ExamResultListViewController")as! ExamResultListViewController
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 6 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "AttendanceViewController")as! AttendanceViewController
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 7 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "SubjectViewController")as! SubjectViewController
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 8 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "DressVendorViewController")as! DressVendorViewController
            self.navigationController?.pushViewController(obj, animated: true)
        }
            else if indexPath.row == 9 {
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "TransportdetailsViewController")as! TransportdetailsViewController
                self.navigationController?.pushViewController(obj, animated: true)
            }
        else {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "SubjectViewController")as! SubjectViewController
            obj.assignment = "VideoSubject"
            self.navigationController?.pushViewController(obj, animated: true)
        }
    }
    
}

class tblstudentZoneCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var icon: UIImageView!
}
