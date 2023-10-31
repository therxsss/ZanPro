import UIKit

extension UIImage {
    var isPortrait: Bool { size.height > size.width }
    var breadth: CGFloat { min(size.width, size.height) }
    var breadthSize: CGSize { CGSize(width: breadth, height: breadth) }
    var breadthRect: CGRect { CGRect(origin: .zero, size: breadthSize) }
    var circleMasked: UIImage? {
        UIGraphicsBeginImageContextWithOptions(breadthSize, false, scale)
        
        defer { UIGraphicsEndImageContext() }
        
        guard let cgImage = cgImage?.cropping(to: CGRect(origin: CGPoint(
            x: isPortrait ? 0 : floor((size.width - size.height) / 2),
            y: isPortrait ? floor((size.height - size.width) / 2) : 0), size: breadthSize))
        else { return nil }
        UIBezierPath(ovalIn: breadthRect).addClip()
        UIImage(cgImage: cgImage).draw(in: breadthRect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
