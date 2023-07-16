import SwiftUI

public extension Text {
    func largeTitle(style: SplytFont = .bold) -> Text {
        return self.font(.largeTitle(style: style))
    }
    
    func title1(style: SplytFont = .bold) -> Text {
        return self.font(.title1(style: style))
    }
    
    func title2(style: SplytFont = .bold) -> Text {
        return self.font(.title2(style: style))
    }
    
    func title3(style: SplytFont = .bold) -> Text {
        return self.font(.title3(style: style))
    }
    
    func title4(style: SplytFont = .bold) -> Text {
        return self.font(.title4(style: style))
    }
    
    func body(style: SplytFont = .bold) -> Text {
        return self.font(.body(style: style))
    }
    
    func subhead(style: SplytFont = .bold) -> Text {
        return self.font(.subhead(style: style))
    }
    
    func footnote(style: SplytFont = .bold) -> Text {
        return self.font(.footnote(style: style))
    }
}

extension Font {
    static func largeTitle(style: SplytFont) -> Font {
        return .custom(style.rawValue, size: 34)
    }
    
    static func title1(style: SplytFont = .bold) -> Font {
        return .custom(style.rawValue, size: 28)
    }
    
    static func title2(style: SplytFont = .bold) -> Font {
        return .custom(style.rawValue, size: 22)
    }
    
    static func title3(style: SplytFont = .bold) -> Font {
        return .custom(style.rawValue, size: 20)
    }
    
    static func title4(style: SplytFont = .bold) -> Font {
        return .custom(style.rawValue, size: 18.5)
    }
    
    static func body(style: SplytFont = .bold) -> Font {
        return .custom(style.rawValue, size: 17)
    }
    
    static func subhead(style: SplytFont = .bold) -> Font {
        return .custom(style.rawValue, size: 15)
    }
    
    static func footnote(style: SplytFont = .bold) -> Font {
        return .custom(style.rawValue, size: 13)
    }
}


/**
 Fonts used by Apple:
 
 Style                      Weight                  Size (points)    Leading (points)
 Large Title             Regular                         34                      41
 Title 1                    Regular                         28                      34
 Title 2                    Regular                         22                      28
 Title 3                    Regular                         20                      25
 Headline               Semibold                       17                      22
 Body                     Regular                          17                      22
 Callout                  Regular                          16                      21
 Subhead               Regular                          15                      20
 Footnote               Regular                          13                      18
 Caption 1              Regular                          12                      16
 Caption 2              Regular                          11                       13

 */
