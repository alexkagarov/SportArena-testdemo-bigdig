//
//  SportArena
//
//

import UIKit

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
    
    func getJSON(){
        let newsUrl = "https://sportarena.com/wp-api/videoapp/page/1/num/20"
        
        guard let request = URL(string: newsUrl) else { return }
        
        let task = URLSession.shared.dataTask(with: request) { (data,response,error) in
            
            self.videonews = [VideoNews]()
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSArray
                
                for arrayX in json as! [[String: Any]] {
                    var videoNewsInstance = VideoNews()
                    
                    if let ID = arrayX["id"],
                        let date = arrayX["datetime"],
                        let title = arrayX["title"],
                        let image_url = arrayX["img"] {
                        videoNewsInstance.headline = Html().convert(from: title as! String)
                        videoNewsInstance.image = image_url as? String
                        videoNewsInstance.id = "\(ID)"
                        videoNewsInstance.date = date as? String
                        videoNewsInstance.categories = "76"
                        videoNewsInstance.tag = "76"
                    }
                    self.videonews?.append(videoNewsInstance)
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
                VideoNewsBodyViewController.newsTitle = title_segue
                VideoNewsBodyViewController.newsID = id_segue
                VideoNewsBodyViewController.newsCategory = categories_segue
                VideoNewsBodyViewController.newsTags = tags_segue
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
        
        /* NOTE: !!!Kingfisher CocoaPod for this method is removed from project!!!
        //cell.imageView!.kf.setImage(with: resource)
         */
        
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
