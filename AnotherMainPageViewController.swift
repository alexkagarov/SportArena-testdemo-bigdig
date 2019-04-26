//
//  FirstViewController.swift
//  SportArena
//
//

import UIKit

class AnotherMainPageViewController: UIViewController {
    @IBOutlet weak var mainPageTableView: UITableView!
    
    var topNewsArray: [TopNews]? = []
    var mainNewsArray: [MainNewsFeed]? = []
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "fv2newsbody") {
            let NewsBodyController = segue.destination as! NewsBodyViewController
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
            
            self.topNewsArray = [TopNews]()
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
                self.topNewsArray?.append(TN)
                
                DispatchQueue.main.async {
                    self.mainPageTableView.reloadData()
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
                    let MNF = MainNewsFeed()
                    if let ID = jarray1["id"],
                        let title = jarray1["title"] as? String,
                        let time = jarray1["datetime"] {
                        MNF.headline = Html().convert(from: title)
                        MNF.id = "\(ID)"
                        MNF.time = time as? String
                    }
                    self.mainNewsArray?.append(MNF)
                    
                    DispatchQueue.main.async {
                        self.mainPageTableView.reloadData()
                    }
                }
                
            } catch let error {
                print(error)
            }
        }
        task.resume()
    }
    
}

extension AnotherMainPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            title_segue = (self.topNewsArray?[indexPath.item].headline)!
            id_segue = (self.topNewsArray?[indexPath.item].id)!
            //print(("tableView: "+(self.news?[indexPath.item].headline)!))
            performSegue(withIdentifier: "fv2newsbody", sender: self)
        case 2:
            title_segue = (self.mainNewsArray?[indexPath.item].headline)!
            id_segue = (self.mainNewsArray?[indexPath.item].id)!
            //print(("tableView: "+(self.news?[indexPath.item].headline)!))
            performSegue(withIdentifier: "fv2newsbody", sender: self)
        default:
            break
        }
    }
}

extension AnotherMainPageViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch section {
        case 0:
            return self.topNewsArray!.count
        case 1:
            return 1
        case 2:
            return self.mainNewsArray!.count
        default:
            return 0
        }
        
//        var count: Int?
//
//        if section == 0 && section == 1{
//            count = self.topNewsArray!.count
//        } else if section == 2 {
//            count = self.mainNewsArray!.count
//        }
//
//        return count!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "TopNewsCell", for: indexPath) as? TopNewsCell {
                cell.imgTN!.downloadImage(from: (self.topNewsArray?[indexPath.item].image!)!)
                cell.titleTN!.text = self.topNewsArray?[indexPath.item].headline
                return cell
            }
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "labelDivider", for: indexPath) as? DividerTableViewCell {
                cell.divider!.text = "Главные новости"
                return cell
            }
        case 2:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "MainNewsCell", for: indexPath) as? MainNewsCell {
                cell.mainNewsTitle!.text = self.mainNewsArray?[indexPath.item].headline
                return cell
            }
        default:
            break
        }
        return UITableViewCell()
    }
}
