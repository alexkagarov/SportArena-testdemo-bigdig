//
//  Time_editor.swift
//  SportArena
//
//  Created by Yevgen Blazhko on 8/27/18.
//  Copyright © 2018 Yevgen Blazhko. All rights reserved.
//

import UIKit

class Time_editor: NSObject {
    
    func timetime(from time: String) -> String {
        //let string = "2017-07-11T06:52:15"
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = dateFormatter.date(from: time)!
        dateFormatter.dateFormat = "HH:mm" ; //"dd-MM-yyyy HH:mm:ss"
        dateFormatter.locale = tempLocale // reset the locale --> but no need here
        let dateString = dateFormatter.string(from: date)
        return dateString
    }

}
