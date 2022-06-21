//
//  ViewController.swift
//  VideoArchive
//
//  Created by Alina Kasianova on 18.06.2022.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let lableView = UILabel(frame: CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: 50))
        
        lableView.text = "MY VIDEO ARCHIVE"
        lableView.textColor = .yellow
        lableView.textAlignment = .center
        lableView.font = UIFont(name: "Futura-Bold", size: 32)
        
        return lableView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "videocell", for: indexPath)
        
        let videoName = videoArray[indexPath.row]
        let nameComponent = videoName.components(separatedBy: "-")
        
        cell.textLabel?.text = nameComponent[0]
        cell.textLabel?.textColor = .yellow
        cell.textLabel?.font = UIFont(name: "Futura-Medium", size: 30)
        cell.imageView?.image = UIImage(named: "play-button")
        cell.imageView?.contentMode = .scaleAspectFit
        
        return cell
    }
    
    
    var videoArray = [String]()

    @IBOutlet weak var videoTableView: UITableView!
    @IBOutlet weak var videoView: UIView!
    
    let videoVC = AVPlayerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        videoTableView.delegate = self
        videoTableView.dataSource = self
        
        videoView.addSubview(videoVC.view)
        videoVC.view.frame = videoView.bounds
        videoVC.showsPlaybackControls = false
    
        let filemanager = FileManager.default
        let path = Bundle.main.resourcePath!
        
        let allItems = try? filemanager.contentsOfDirectory(atPath: path)
        
        for singleItem in allItems!
        {
            if singleItem.hasSuffix("mp4")
            {
                videoArray.append(singleItem)
            }
        }
        if videoArray.count > 0
        {
            let nameComponent = videoArray[0].components(separatedBy: ".")
            let name = nameComponent[0]
            
            let path = Bundle.main.path(forResource: name, ofType: "mp4")!
            let url = URL(fileURLWithPath: path)
            
            videoVC.player = AVPlayer(url: url)
            
            videoVC.player?.play()
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "Play Video", message: "How do you want to play video", preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction(title: "Play at the top", style: .default) { (action) in
            
            let nameComponent = self.videoArray[indexPath.row].components(separatedBy: ".")
            let name = nameComponent[0]
            
            let path = Bundle.main.path(forResource: name, ofType: "mp4")!
            let url = URL(fileURLWithPath: path)
            
            self.videoVC.showsPlaybackControls = false
            self.videoVC.player = AVPlayer(url: url)
            
            self.videoView.addSubview(self.videoVC.view)
            self.videoVC.view.frame = self.videoView.bounds
            
            self.videoVC.player?.play()
            
        }
        let action2 = UIAlertAction(title: "Play in full screen", style: .default) { (action) in
            
            let playerVC = self.storyboard?.instantiateViewController(withIdentifier: "player") as! AVPlayerViewController
            let videoName = self.videoArray[indexPath.row]
            let nameComponent = videoName.components(separatedBy: ".")
            
            let path = Bundle.main.path(forResource: nameComponent[0], ofType: "mp4")
            
            if let path = path
            {
                let url = URL(fileURLWithPath: path)
                playerVC.player = AVPlayer(url: url)
                playerVC.player?.play()
            }
            
            self.present(playerVC, animated: true)
        
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(cancel)
        
        present(alert, animated: true)
        
    }


}

