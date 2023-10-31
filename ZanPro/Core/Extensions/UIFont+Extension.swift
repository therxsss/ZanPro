import SwiftUI

enum Montserrat: String {
    case regular = "Montserrat-Regular"
    case bold = "Montserrat-Bold"
    case semibold = "Montserrat-SemiBold"
    case medium = "Montserrat-Medium"
}

enum OpenSans: String {
    case regular = "OpenSans-Regular"
    case bold = "OpenSans-Bold"
    case semibold = "OpenSans-SemiBold"
    case medium = "OpenSans-Medium"
}

extension UIFont {
    static func openSans(size: CGFloat, weight: OpenSans = .regular) -> UIFont {
        UIFont(name: weight.rawValue, size: size) ?? .systemFont(ofSize: size)
    }
}

extension Font {
    static func openSans(size: CGFloat, weight: OpenSans = .regular) -> Font {
        Font.custom(weight.rawValue, size: size)
    }
    
    static func montserrat(size: CGFloat, weight: Montserrat = .bold) -> Font {
        Font.custom(weight.rawValue, size: size)
    }
}
