//
//  SecondViewController.swift
//  SportArena
//
//

import UIKit

class AllNewsViewController: UIViewController {
    
    var refresh: UIRefreshControl!
    
    var titlenews = ""
    var title_segue = ""
    var id_segue = ""
    var n = 1
    
    
    @IBOutlet weak var tableview: UITableView!
    var newsFeed: [NewsFeed]? = []
    
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
        refresh.addTarget(self, action: #selector(AllNewsViewController.getJSON), for: UIControl.Event.valueChanged)
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
            self.newsFeed = [NewsFeed]()
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSArray
                
                for arrayX in json as! [[String: Any]] {
                    let NF = NewsFeed()
                    
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
                    self.newsFeed?.append(NF)
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
            let NewsBodyController = segue.destination as! NewsBodyViewController
            NewsBodyController.title_news = title_segue
            NewsBodyController.id_news = id_segue
        }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        print("gesture_yes")
    }
    
}

extension AllNewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        title_segue = (self.newsFeed?[indexPath.item].headline)!
        id_segue = (self.newsFeed?[indexPath.item].id)!
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
