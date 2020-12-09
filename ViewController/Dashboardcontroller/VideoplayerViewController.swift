//
//  VideoplayerViewController.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 14/03/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import UIKit
import AVKit
import Alamofire

class VideoplayerViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var playerset: UIView!
    
    var videoUrl = ""
    var titlevideo = ""
    var descripVideo = ""
    var Subject_id = Int()
    var playerItem:AVPlayerItem?
    var player:AVPlayer?
    var wc = Webservice.init()
    var arrVideo = [DatumVideo]()
    var url: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getVideoSub()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
           self.tabBarController?.tabBar.isHidden = true
       }
       
       override func viewWillDisappear(_ animated: Bool) {
           self.tabBarController?.tabBar.isHidden = false
       }
    
    func getVideoSub() {
                
        if Subject_id != nil {
            let param = ["s_subject_id": Subject_id] as [String : Any]
            let token = loggdenUser.value(forKey: TOKEN)as! String
            let headers: HTTPHeaders = ["Xapi": Xapi,
                                    "Authorization":token]
            
            wc.callSimplewebservice(url: exam_videos, parameters: param, headers: headers, fromView: self.view, isLoading: true) { (success, response: VideoResponsModel?) in
                if success {
                    let suc = response?.success
                    if suc == true {
                        let data = response?.data
                        self.arrVideo = data!.data
                        print(self.arrVideo)
                        let strurl = self.arrVideo[0].teacherNoteFiles
                        let urlVideo = strurl[0]
                        let url = URL(string: urlVideo)
                        self.player = AVPlayer(url: url!)
                        let playerLayer = AVPlayerLayer(player: self.player)
                        playerLayer.frame = self.playerset.bounds
                        self.playerset.layer.addSublayer(playerLayer)
                        self.player?.play()
                        self.lblTitle.text = self.arrVideo[0].name
                        self.descripVideo = self.arrVideo[0].datumDescription
                        //self.tblMain.reloadData()
                    }
                    else {
                    }
                }
            }
        }
        else {
            let url : URL = URL(string: videoUrl)!
            player = AVPlayer(url: url)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = self.playerset.bounds
            self.playerset.layer.addSublayer(playerLayer)
            player?.play()
            lblTitle.text = titlevideo
        }
        
    }
    

    @IBAction func btnbackAction(_ sender: UIButton) {
        player?.pause()
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

extension VideoplayerViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let lbldesc = cell.viewWithTag(101)as! UILabel
        lbldesc.text = descripVideo
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}
