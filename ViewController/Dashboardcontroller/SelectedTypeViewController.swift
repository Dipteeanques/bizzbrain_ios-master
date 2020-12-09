//
//  SelectedTypeViewController.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 16/09/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit

class SelectedTypeViewController: UIViewController {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblNavi: UILabel!
    @IBOutlet weak var lblTitleName: UILabel!
    
    @IBOutlet weak var lbl_theory: UILabel!
    @IBOutlet weak var lbl_test: UILabel!
    @IBOutlet weak var lbl_video: UILabel!
    
    @IBOutlet weak var btn_theory: UIButton!
    @IBOutlet weak var btn_test: UIButton!
    @IBOutlet weak var btn_video: UIButton!
    
    var strnavi = String()
    var strimage = String()
    var strTitle = String()
    var url: URL?
    var subcategory_id = Int()
    var topic_id = Int()
    var is_test = Int()
    var is_document = Int()
    var is_video = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setDefault()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setDefault() {
        lblTitleName.text = strTitle
        lblNavi.text = strnavi
        url = URL(string: strimage)
        imgProfile.sd_setImage(with: url, completed: nil)
        imgProfile.layer.cornerRadius = 5
        imgProfile.clipsToBounds = true
        
        if is_test == 1{
            btn_test.isHidden = false
            lbl_test.isHidden = false
        }
        else{
            btn_test.isHidden = true
            lbl_test.isHidden = true
        }
        
        if is_video == 1{
            btn_video.isHidden = false
            lbl_video.isHidden = false
        }
        else{
            btn_video.isHidden = true
            lbl_video.isHidden = true
        }
        
        if is_document == 1{
            btn_theory.isHidden = false
            lbl_theory.isHidden = false
        }
        else{
            btn_theory.isHidden = true
            lbl_theory.isHidden = true
        }
    }
    @IBAction func btnVideoAction(_ sender: UIButton) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "VideolistViewController")as! VideolistViewController
        obj.subcategory_id = subcategory_id
        obj.strnavi = lblNavi.text!
        obj.strTitle = strTitle
        obj.topic_id = topic_id
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btnDocAction(_ sender: UIButton) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "DocumentlistViewController")as! DocumentlistViewController
        obj.subcategory_id = subcategory_id
        obj.strnavi = lblNavi.text!
        obj.strTitle = strTitle
        obj.topic_id = topic_id
        self.navigationController?.pushViewController(obj, animated: true)
    }
    @IBAction func btntestAction(_ sender: UIButton) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "TestListViewController")as! TestListViewController
        obj.subcategory_id = subcategory_id
        obj.strnavi = lblNavi.text!
        obj.strTitle = strTitle
        obj.topic_id = topic_id
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
