import UIKit

class TabBarController: UITabBarController, BaseViewControllerProtocol {
    var onRemoveFromNavigationStack: VoidCallback?
    var onDidDismiss: VoidCallback?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setValue(CustomTabBar().self, forKey: "tabBar")
    }
}
