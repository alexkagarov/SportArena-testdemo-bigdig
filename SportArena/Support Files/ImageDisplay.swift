//
//  Image_display.swift
//  SportArena
//
//

import UIKit

extension UIImageView {
    func downloadImage(from url: String) {
        
        guard let request = URL(string: url) else {return}
        let urlRequest = URLRequest(url: request)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data,response,error) in
            
            if error != nil {
                print(error as Any)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
            task.resume()
    }
}
