//
//  NewsBody.swift
//  SportArena
//
//  Created by Yevgen Blazhko on 8/19/18.
//  Copyright © 2018 Yevgen Blazhko. All rights reserved.
//

import UIKit
import WebKit

class NewsBody: UIViewController {
    
    
    @IBOutlet weak var titleNews: UILabel!
    @IBOutlet weak var imageNews: UIImageView!
    @IBOutlet weak var contentNews: WKWebView!
    @IBOutlet weak var subtitleNews: UILabel!
    
    var title_news = ""
    var id_news = ""
    var categories_news = ""
    var tags_news = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentNews.scrollView.isScrollEnabled = false
        
//        if (tags_news == "22") {
//            imageNews.isHidden = false
//        }
        //print(categories_news)
        titleNews.text = title_news
        getJSONnews(from: id_news)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getJSONnews (from idfornews: String) {
        
        let urlRequest = URLRequest(url: URL(string: ("https://sportarena.com/wp-api/wp/v2/posts/")+idfornews+("?_embed"))!)
        print(urlRequest)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data,response,error) in

            if error != nil {
                print(error as Any)
                return
            }
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
                        self.contentNews.loadHTMLString(self.string_correction(from: content_text), baseURL: nil)
                        self.subtitleNews.text = subtitle_text
                    }

            } catch let error {
                print(error)
            }
        }
        task.resume()
    }
    
    func string_correction(from text: String) -> String {
        var newString = text.replacingOccurrences(of: "//embed.megogo.net", with: "https://embed.megogo.net", options: .literal, range: nil)
        newString = newString.replacingOccurrences(of: "//footballua.tv", with: "https://footballua.tv", options: .literal, range: nil)
        newString = newString.replacingOccurrences(of: "//streamable.com", with: "https://streamable.com", options: .literal, range: nil)
        newString = newString.replacingOccurrences(of: "iframe width='800' height='500'", with: "iframe width='100%' height='700'", options: .literal, range: nil)
        newString = newString.replacingOccurrences(of: "<html><body><p>", with: "<html><body><p><font size='10px'>", options: .literal, range: nil)
        
        return newString
    }
}
