//
//  SecondViewController.swift
//  SportArena
//
//  Created by Yevgen Blazhko on 8/8/18.
//  Copyright © 2018 Yevgen Blazhko. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var refresh: UIRefreshControl!
    
    var titlenews = ""
    var title_segue = ""
    var id_segue = ""
    var n = 1
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsfeedCell", for: indexPath) as! NewsFeedCell
        cell.newsfeed_title.text = self.news?[indexPath.item].headline
        cell.newsfeed_topic.text = self.news?[indexPath.item].topic
        cell.newsfeed_time.text = Time_editor().timetime(from: (self.news?[indexPath.item].time)!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        title_segue = (self.news?[indexPath.item].headline)!
        id_segue = (self.news?[indexPath.item].id)!
        //print(("tableView: "+(self.news?[indexPath.item].headline)!))
        performSegue(withIdentifier: "newsbodysegue", sender: self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    } 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.news!.count
    } //number of rows

//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let lastItem = self.news!.count - 1
//        //print(self.news!.count)
//        print(indexPath.row)
//        if indexPath.row == lastItem {
//            n = n+1
//            getJSON()
//        }
//    }


    @IBOutlet weak var tableview: UITableView!
    var news: [Newsfeed]? = []
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
//        imageView.contentMode = .scaleAspectFit
//        let image = UIImage(named: "arrow_up")
//        imageView.image = image
//        navigationItem.titleView = imageView
        
        getJSON()
        refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "Обновление")
        refresh.addTarget(self, action: #selector(SecondViewController.getJSON), for: UIControlEvents.valueChanged)
        tableview.addSubview(refresh)    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func getJSON(){
        
        let urlRequest = URLRequest(url: URL(string: "https://sportarena.com/wp-api/wp/v2/posts/?per_page=30&page=\(n)")!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data,response,error) in
    
            if error != nil {
                print(error as Any)
                return
            }
            self.news = [Newsfeed]()
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSArray
            
                for arrayX in json as! [[String: Any]] {
                    let NF = Newsfeed()
                    
                    let categories0 = arrayX["categories"] as? NSArray
                    let title0 = arrayX["title"] as? [String: Any]
                    
                    if let ID = arrayX["id"],
                        let date = arrayX["date"],
                        let title = title0!["rendered"] as? String,
                        let categories = categories0?[0] {
                            NF.headline = Html().convert(from: title)
                            NF.topic = "\(categories)"
                            //print (ID)
                            NF.id = "\(ID)"
                            NF.time = date as? String
                    }
                    self.news?.append(NF)
                 }
                DispatchQueue.main.async {
                    self.refresh.endRefreshing()
                    self.tableview.reloadData()
                }
            } catch let error {
                print(error)
            }
        }
        task.resume()
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "newsbodysegue") {
            let NewsBodyController = segue.destination as! NewsBody
            NewsBodyController.title_news = title_segue
            NewsBodyController.id_news = id_segue
        }
    }
    
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        print("gesture_yes")
    }

}





