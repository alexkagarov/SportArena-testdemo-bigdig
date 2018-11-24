//
//  ThirdViewController.swift
//  SportArena
//
//  Created by Yevgen Blazhko on 8/8/18.
//  Copyright © 2018 Yevgen Blazhko. All rights reserved.
//

import UIKit
import Kingfisher

class ThirdViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var n = 1
    var title_segue = ""
    var id_segue = ""
    var categories_segue = ""
    var tags_segue = ""
    //var refresh: UIRefreshControl!
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath) as! VideoNewsCell
        //print("cell: "+(self.videonews?[indexPath.item].headline)!)
        //cell.imageView!.downloadImage(from: (self.videonews?[indexPath.item].image!)!)
        let resource = ImageResource(downloadURL: URL(string: (self.videonews?[indexPath.item].image!)!)!, cacheKey: self.videonews?[indexPath.item].image!)
        cell.imageView!.kf.setImage(with: resource)
        cell.titleVideo.text = self.videonews?[indexPath.item].headline
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Launch tableview in SecondView")
        title_segue = (self.videonews?[indexPath.item].headline)!
        id_segue = (self.videonews?[indexPath.item].id)!
        categories_segue = (self.videonews?[indexPath.item].categories)!
        tags_segue = (self.videonews?[indexPath.item].tag)!
        //print(("tableView: "+(self.news?[indexPath.item].headline)!))
        performSegue(withIdentifier: "video2newsbody", sender: self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videonews!.count
    }
    
    @IBOutlet weak var videoTableview: UITableView!
    var videonews: [VideoNews]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getJSON()
    }
    
    @objc func getJSON(){
        
        let urlRequest = URLRequest(url: URL(string: "https://sportarena.com/wp-api/wp/v2/posts/?per_page=13&page=\(n)&tags=22&_embed")!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data,response,error) in
            
            if error != nil {
                print(error as Any)
                return
            }
            self.videonews = [VideoNews]()
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSArray
                
                for arrayX in json as! [[String: Any]] {
                    let VN = VideoNews()
                    
                    var image_url = "https://sportarena.com/wp-content/uploads/2018/09/Grey_full.png"
                    
                    let tag0 = arrayX["tags"] as? NSArray
                    
                    let categories0 = arrayX["categories"] as? NSArray
                    let title0 = arrayX["title"] as? [String: Any]
                    let embedded = arrayX["_embedded"] as? [String: Any]
                    let featuredmedia0 = embedded?["wp:featuredmedia"] as? NSArray
                    let featuredmedia = featuredmedia0?[0] as? [String: AnyObject]
                    let media_details = featuredmedia?["media_details"]
                    let sizes0 = media_details?["sizes"] as? [String: AnyObject]
                    let sizes = sizes0?["video-small"]
                    if (featuredmedia0 != nil || featuredmedia != nil || media_details != nil || sizes0 != nil || sizes != nil) {
                        image_url = sizes?["source_url"] as! String
                    }

                    if let ID = arrayX["id"],
                        let date = arrayX["date"],
                        let title = title0!["rendered"] as? String,
                        let categories = categories0?[0],
                        let tags = tag0?[0] {
                        VN.headline = Html().convert(from: title)
                        VN.image = image_url
                        VN.id = "\(ID)"
                        VN.date = date as? String
                        VN.categories = "\(categories)"
                        VN.tag = "\(tags)"
                    }
                    self.videonews?.append(VN)
                }
                DispatchQueue.main.async {
                    self.videoTableview.reloadData()
                }
            } catch let error {
                print(error)
            }
        }
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "video2newsbody") {
            let NewsBodyController = segue.destination as! NewsBody
            NewsBodyController.title_news = title_segue
            NewsBodyController.id_news = id_segue
            NewsBodyController.categories_news = categories_segue
            NewsBodyController.tags_news = tags_segue
        }
    }
    
    
}

extension NSLayoutConstraint {
    
    override open var description: String {
        let id = identifier ?? ""
        return "id: \(id), constant: \(constant)" //you may print whatever you want here
    }
}
