import Foundation

class Html: NSObject {
    
    func convert(from sentence: String) -> String {
        var sentence_convert = sentence.replacingOccurrences(of: "&#8212;", with: "—", options: .literal, range: nil)
        sentence_convert = sentence_convert.replacingOccurrences(of: "&#171;", with: "«", options: .literal, range: nil)
        sentence_convert = sentence_convert.replacingOccurrences(of: "&#187;", with: "»", options: .literal, range: nil)
        sentence_convert = sentence_convert.replacingOccurrences(of: "&#8217;", with: "’", options: .literal, range: nil)
        return sentence_convert
    }
    
}
