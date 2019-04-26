//
//  SportArena
//
//

import UIKit
import Kingfisher

class VideosViewController: UIViewController {
    
    var n = 1
    var title_segue = ""
    var id_segue = ""
    var categories_segue = ""
    var tags_segue = ""
    
    @IBOutlet weak var videoTableview: UITableView!
    
    var videonews: [VideoNews]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getJSON()
    }
    
    @objc func getJSON(){
        
        let urlRequest = URLRequest(url: URL(string: "https://sportarena.com/wp-api/videoapp/page/1/num/20")!)
        
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
                    
                    if let ID = arrayX["id"],
                        let date = arrayX["datetime"],
                        let title = arrayX["title"],
                        let image_url = arrayX["img"] {
                        VN.headline = Html().convert(from: title as! String)
                        VN.image = image_url as? String
                        VN.id = "\(ID)"
                        VN.date = date as? String
                        //VN.categories = "\(categories)"
                        VN.categories = "76"
                        //VN.tag = "\(tags)"
                        VN.tag = "76"
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
        if (segue.identifier == "videoNews") {
            if let VideoNewsBodyViewController = segue.destination as? VideoNewsBodyViewController {
                VideoNewsBodyViewController.title_news = title_segue
                VideoNewsBodyViewController.id_news = id_segue
                VideoNewsBodyViewController.categories_news = categories_segue
                VideoNewsBodyViewController.tags_news = tags_segue
            }
        }
    }
}

extension VideosViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath) as! VideoNewsCell
        //let resource = ImageResource(downloadURL: URL(string: (self.videonews?[indexPath.item].image!)!)!, cacheKey: self.videonews?[indexPath.item].image!)
        
        cell.imageView!.downloadImage(from: ((self.videonews?[indexPath.item].image)!))
        
        //cell.imageView!.image = nil
        //cell.imageView!.kf.setImage(with: resource)
        cell.titleVideo.text = self.videonews?[indexPath.item].headline
        return cell
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videonews!.count
    }
}

extension VideosViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        title_segue = (self.videonews?[indexPath.item].headline)!
        id_segue = (self.videonews?[indexPath.item].id)!
        categories_segue = (self.videonews?[indexPath.item].categories)!
        tags_segue = (self.videonews?[indexPath.item].tag)!
        performSegue(withIdentifier: "videoNews", sender: self)
    }
}
