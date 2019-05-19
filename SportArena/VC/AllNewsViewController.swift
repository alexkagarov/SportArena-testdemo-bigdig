//
//  SecondViewController.swift
//  SportArena
//
//

import UIKit

class AllNewsViewController: UIViewController {
    
    var refresh: UIRefreshControl!
    
    var newsTitle = ""
    var segueTitle = ""
    var segueID = ""
    var n = 1 // temporary value for pagination
    
    @IBOutlet weak var tableview: UITableView!
    var newsFeed: [NewsFeed]? = []
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        
        getJSON()
        
        refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "Обновление")
        refresh.addTarget(self, action: #selector(AllNewsViewController.getJSON), for: UIControl.Event.valueChanged)
        tableview.addSubview(refresh)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func getJSON(){
        let allNewsUrl = "https://sportarena.com/wp-api/wp/v2/posts/?per_page=30&page=\(n)"
        guard let request = URL(string: allNewsUrl) else { return }
        
        let task = URLSession.shared.dataTask(with: request) { (data,response,error) in
            
            self.newsFeed = [NewsFeed]()
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSArray
                
                for arrayX in json as! [[String: Any]] {
                    var newsFeedInstance = NewsFeed()
                    
                    let categories0 = arrayX["categories"] as? NSArray
                    let title0 = arrayX["title"] as? [String: Any]
                    
                    if let ID = arrayX["id"],
                        let date = arrayX["date"],
                        let title = title0!["rendered"] as? String,
                        let categories = categories0?[0] {
                        newsFeedInstance.headline = Html().convert(from: title)
                        newsFeedInstance.topic = "\(categories)"
                        //print (ID)
                        newsFeedInstance.id = "\(ID)"
                        newsFeedInstance.time = date as? String
                    }
                    self.newsFeed?.append(newsFeedInstance)
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
        if (segue.identifier == "NewsPageSegue") {
            guard let NewsBodyController = segue.destination as? NewsBodyViewController else { return }
            NewsBodyController.newsTitle = segueTitle
            NewsBodyController.newsID = segueID
        }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        print("gesture_yes")
    }
    
}

extension AllNewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        segueTitle = (self.newsFeed?[indexPath.item].headline)!
        segueID = (self.newsFeed?[indexPath.item].id)!
        //print(("tableView: "+(self.news?[indexPath.item].headline)!))
        performSegue(withIdentifier: "NewsPageSegue", sender: self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return self.newsFeed!.count
    }
}

extension AllNewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsfeedCell", for: indexPath) as! NewsFeedCell
        cell.newsFeedTitle.text = self.newsFeed?[indexPath.item].headline
        cell.newsFeedTopic.text = self.newsFeed?[indexPath.item].topic
        cell.newsFeedTime.text = TimeEditor().timeTime(from: (self.newsFeed?[indexPath.item].time)!)
        return cell
    }
}
