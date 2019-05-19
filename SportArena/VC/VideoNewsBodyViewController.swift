//
//  NewsBody.swift
//  SportArena
//
//

import UIKit
import WebKit

class VideoNewsBodyViewController: UIViewController {
    
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var videoNewsTopic: UILabel!
    @IBOutlet weak var videoContent: WKWebView!
    
    var newsTitle = ""
    var newsID = ""
    var newsCategory = ""
    var newsTags = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoNewsTopic.text = newsTitle
        getJSONnews(from: newsID)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getJSONnews (from requestNewsID: String) {
        let videoNewsUrl = "https://sportarena.com/wp-api/wp/v2/posts/"+requestNewsID+("?_embed")
        guard let request = URL(string: videoNewsUrl) else { return }
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
                    self.videoImage.downloadImage(from: image_url)
                    self.videoContent.loadHTMLString(self.stringCorrection(from: content_text), baseURL: nil)
                }
                
            } catch let error {
                print(error)
            }
        }
        task.resume()
    }
    
    func stringCorrection(from text: String) -> String {
        var newString = text.replacingOccurrences(of: "//embed.megogo.net", with: "https://embed.megogo.net", options: .literal, range: nil)
        newString = newString.replacingOccurrences(of: "//footballua.tv", with: "https://footballua.tv", options: .literal, range: nil)
        newString = newString.replacingOccurrences(of: "//streamable.com", with: "https://streamable.com", options: .literal, range: nil)
        newString = newString.replacingOccurrences(of: "iframe width='800' height='500'", with: "iframe width='100%' height='700'", options: .literal, range: nil)
        newString = newString.replacingOccurrences(of: "<html><body><p>", with: "<html><body><p><font size='10px'>", options: .literal, range: nil)
        
        return newString
    }
}
