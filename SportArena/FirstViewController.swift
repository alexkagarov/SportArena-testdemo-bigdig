//
//  FirstViewController.swift
//  SportArena
//
//  Created by Yevgen Blazhko on 8/8/18.
//  Copyright © 2018 Yevgen Blazhko. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableTN: UITableView!
    @IBOutlet weak var tableMainNews: UITableView!
    
    var topnews: [TopNews]? = []
    var mainnews: [Mainnewsfeed]? = []
    
    var title_segue = ""
    var id_segue = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TopNewsJSON()
        MainNewsJSON()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell:UITableViewCell?
        
        if tableView == self.tableTN {
            let cell = tableView.dequeueReusableCell(withIdentifier: "topnewsCell", for:indexPath) as! TopNewsCell
            cell.imgTN!.downloadImage(from: (self.topnews?[indexPath.item].image!)!)
            cell.titleTN!.text = self.topnews?[indexPath.item].headline
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "mainnewsCell", for:indexPath) as! MainNewsCell
            cell.mainnews_title!.text = self.mainnews?[indexPath.item].headline
            return cell
        }
    
        //return cell!
        
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count:Int?
        
        if tableView == self.tableTN {
            count = self.topnews!.count
        }
        
        if tableView == self.tableMainNews {
            count = self.mainnews!.count
        }
        
        return count!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableTN {
            title_segue = (self.topnews?[indexPath.item].headline)!
            id_segue = (self.topnews?[indexPath.item].id)!
            //print(("tableView: "+(self.news?[indexPath.item].headline)!))
            performSegue(withIdentifier: "fv2newsbody", sender: self)
        }
        if tableView == self.tableMainNews {
            title_segue = (self.mainnews?[indexPath.item].headline)!
            id_segue = (self.mainnews?[indexPath.item].id)!
            //print(("tableView: "+(self.news?[indexPath.item].headline)!))
            performSegue(withIdentifier: "fv2newsbody", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "fv2newsbody") {
            let NewsBodyController = segue.destination as! NewsBody
            NewsBodyController.title_news = title_segue
            print (id_segue)
            NewsBodyController.id_news = id_segue
        }
    }
    
    func TopNewsJSON () {
         let urlRequest = URLRequest(url: URL(string: "https://sportarena.com/wp-api/topnews2018/top/")!)
        
         let task = URLSession.shared.dataTask(with: urlRequest) { (data,response,error) in
            
            if error != nil {
                print(error as Any)
                return
            }
            
            self.topnews = [TopNews]()
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                
                //print(json)
                let TN = TopNews()
                let jarray = json["top-news"] as! NSArray
                let jarray1 = jarray[0] as? [String: AnyObject]
                if let ID = jarray1!["ID"] as? String,
                    let title =  jarray1!["title"] as? String,
                    let img = jarray1!["img"] as? String {
                        TN.headline = Html().convert(from: title)
                        TN.image = img
                        TN.id = "\(ID)"
                    }
                    self.topnews?.append(TN)
            
                    DispatchQueue.main.async {
                        self.tableTN.reloadData()
                    }
                
            } catch let error {
                print(error)
            }
        }
        task.resume()
    }
    
    func MainNewsJSON () {
        let urlRequest = URLRequest(url: URL(string: "https://sportarena.com/wp-api/generalnews2018/general/num/10/")!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data,response,error) in
            
            if error != nil {
                print(error as Any)
                return
            }
            //self.mainnews = [MainNews]()
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                
                let jarray = json["general-news"] as! NSArray
                let jarray1 = jarray[0]
                
                for jarray1 in jarray1 as! [[String: Any]] {
                    let MNF = Mainnewsfeed()
                    if let ID = jarray1["id"],
                        let title = jarray1["title"] as? String,
                        let time = jarray1["datetime"] {
                        MNF.headline = Html().convert(from: title)
                        MNF.id = "\(ID)"
                        MNF.time = time as? String
                    }
                    self.mainnews?.append(MNF)
                    
                    DispatchQueue.main.async {
                        self.tableMainNews.reloadData()
                    }
                }
                
            } catch let error {
                print(error)
            }
        }
        task.resume()
    }
    
}

