//
//
//
// yb&ak

import UIKit
import WebKit

class NewsBodyViewController: UIViewController {
    
    @IBOutlet weak var titleNews: UILabel!
    @IBOutlet weak var imageNews: UIImageView!
    @IBOutlet weak var newsText: UILabel!
    @IBOutlet weak var subtitleNews: UILabel!
    
    var newsTitle = ""
    var newsID = ""
    var newsCategory = ""
    var newsTags = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleNews.text = newsTitle
        getJSONnews(from: newsID)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getJSONnews (from idfornews: String) {
        let newsUrl = "https://sportarena.com/wp-api/wp/v2/posts/"+idfornews+"?_embed"
        guard let request = URL(string: newsUrl) else { return }
        print(request)
        
        let task = URLSession.shared.dataTask(with: request) { (data,response,error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject]
                
                let content = json["content"] as? [String: Any]
                let content_text = content!["rendered"] as! String
                let date = json["date"] as! String
                let excerpt = json["excerpt"] as? [String: Any]
                let subtitle_text = excerpt!["rendered"] as! String
                let embed = json["_embedded"] as? [String: Any]
                let featuredmedia0 = embed!["wp:featuredmedia"] as? NSArray
                let featuredmedia = featuredmedia0![0] as? [String: AnyObject]
                let media_details = featuredmedia!["media_details"]
                let sizes0 = media_details!["sizes"] as? [String: AnyObject]
                let sizes = sizes0!["full"]
                let image_url = sizes!["source_url"] as! String
                
                DispatchQueue.main.async {
                    self.imageNews.downloadImage(from: image_url)
                    
                    self.newsText.attributedText = content_text.htmlAttributed.0
                    self.newsText.font = UIFont(name: "Helvetica", size: 16.0)
                    
                    self.subtitleNews.attributedText = subtitle_text.htmlAttributed.0
                    self.subtitleNews.font = UIFont(name: "Helvetica", size: 16.0)
                }
                
            } catch let error {
                print(error)
            }
        }
        task.resume()
    }
}
