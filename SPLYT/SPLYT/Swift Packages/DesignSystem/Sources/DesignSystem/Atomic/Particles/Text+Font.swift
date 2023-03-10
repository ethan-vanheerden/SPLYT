import SwiftUI

public extension Text {
    func largeTitle(style: SplytFont = .bold) -> Text {
        return self.font(.custom(style.rawValue, size: 34))
    }
    
    func title1(style: SplytFont = .bold) -> Text {
        return self.font(.custom(style.rawValue, size: 28))
    }
    
    func title2(style: SplytFont = .bold) -> Text {
        return self.font(.custom(style.rawValue, size: 22))
    }
    
    func title3(style: SplytFont = .bold) -> Text {
        return self.font(.custom(style.rawValue, size: 20))
    }
    
    func title4(style: SplytFont = .bold) -> Text {
        return self.font(.custom(style.rawValue, size: 18.5))
    }
    
    func body(style: SplytFont = .bold) -> Text {
        return self.font(.custom(style.rawValue, size: 17))
    }
    
    func subhead(style: SplytFont = .bold) -> Text {
        return self.font(.custom(style.rawValue, size: 15))
    }
    
    func footnote(style: SplytFont = .bold) -> Text {
        return self.font(.custom(style.rawValue, size: 13))
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
