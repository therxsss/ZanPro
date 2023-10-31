import SwiftUI

enum NavBarPosition {
    case left
    case right
}

public protocol BaseViewControllerProtocol: UIViewController {
    var onRemoveFromNavigationStack: VoidCallback? { get set }
    var onDidDismiss: VoidCallback? { get set }
}

open class BaseViewController: UIViewController, BaseViewControllerProtocol {
    public var onRemoveFromNavigationStack: (() -> Void)?
    public var onDidDismiss: (() -> Void)?
    var bag = Bag()
    override public func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if parent == nil {
            onRemoveFromNavigationStack?()
        }
    }
    
    open override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag) { [weak self] in
            completion?()
            self?.onDidDismiss?()
        }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

extension BaseViewController {
    func addNavBarButton(at position: NavBarPosition, with title: String = "") {
        let button = UIButton(type: .system)
        button.tintColor = .label
        
        switch position {
        case .left:
            button.addTarget(self, action: #selector(navBarLeftButtonHandler), for: .primaryActionTriggered)
            button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        case .right:
            button.addTarget(self, action: #selector(navBarRightButtonHandler), for: .primaryActionTriggered)
            button.setTitle(title, for: .normal)
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        }
    }
    
    func setTitleForNavBarButton(_ title: String, at position: NavBarPosition) {
        switch position {
        case .left:
            (navigationItem.leftBarButtonItem?.customView as? UIButton)?.setTitle(title, for: .normal)
        case .right:
            (navigationItem.rightBarButtonItem?.customView as? UIButton)?.setTitle(title, for: .normal)
        }
        view.layoutIfNeeded()
    }
}

@objc extension BaseViewController {
    func setupViews() {
        view.backgroundColor = .zpGreyBG
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func navBarLeftButtonHandler() {
        navigationController?.popViewController(animated: true)
    }
    func navBarRightButtonHandler() {}
}
