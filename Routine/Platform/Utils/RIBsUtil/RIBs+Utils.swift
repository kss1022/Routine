import UIKit
import ModernRIBs


public enum DismissButtonType {
    case back, close
    
    public var iconSystemName: String {
        switch self {
        case .back:
            return "chevron.backward"
        case .close:
            return "xmark.circle"
        }
    }
}

public final class NavigationControllerable: ViewControllable {
    
    public var uiviewController: UIViewController { self.navigationController }
    public let navigationController: UINavigationController
    
    public init(root: ViewControllable) {
        let navigation = UINavigationController(rootViewController: root.uiviewController)
        //navigation.navigationBar.isTranslucent = false
        //navigation.navigationBar.backgroundColor = .systemBackground
        //navigation.navigationBar.scrollEdgeAppearance = navigation.navigationBar.standardAppearance
        navigation.navigationBar.tintColor = .label
        
        self.navigationController = navigation
    }
}

public extension ViewControllable {
    
    func present(_ viewControllable: ViewControllable, animated: Bool, completion: (() -> Void)?) {
        self.uiviewController.present(viewControllable.uiviewController, animated: animated, completion: completion)
    }
    
    func dismiss(animated: Bool = true,  completion: (() -> Void)?) {
        self.uiviewController.dismiss(animated: animated, completion: completion)
    }
    
    func pushViewController(_ viewControllable: ViewControllable, animated: Bool) {
        if let nav = self.uiviewController as? UINavigationController {
            nav.pushViewController(viewControllable.uiviewController, animated: animated)
        } else {
            self.uiviewController.navigationController?.pushViewController(viewControllable.uiviewController, animated: animated)
        }
    }
    
    func popViewController(animated: Bool) {
        if let nav = self.uiviewController as? UINavigationController {
            nav.popViewController(animated: animated)
        } else {
            self.uiviewController.navigationController?.popViewController(animated: animated)
        }
    }
    
    func popToRoot(animated: Bool) {
        if let nav = self.uiviewController as? UINavigationController {
            nav.popToRootViewController(animated: animated)
        } else {
            self.uiviewController.navigationController?.popToRootViewController(animated: animated)
        }
    }
    
    func setViewControllers(_ viewControllerables: [ViewControllable]) {
        if let nav = self.uiviewController as? UINavigationController {
            nav.setViewControllers(viewControllerables.map(\.uiviewController), animated: true)
        } else {
            self.uiviewController.navigationController?.setViewControllers(viewControllerables.map(\.uiviewController), animated: true)
        }
    }
    
    var topViewControllable: ViewControllable {
        var top: ViewControllable = self
        
        while let presented = top.uiviewController.presentedViewController as? ViewControllable {
            top = presented
        }
        
        return top
    }
}


public extension ViewControllable{
    
        
    func setLargeTitle(){
        if let nav = self.uiviewController as? UINavigationController {
            nav.navigationBar.prefersLargeTitles = true
            nav.navigationItem.largeTitleDisplayMode = .always
        } else if let nav = self.uiviewController.navigationController{
            nav.navigationBar.prefersLargeTitles = true
            nav.navigationItem.largeTitleDisplayMode = .always
        }
    }
    
    func setTransparent(){
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
                         
        if let nav = self.uiviewController as? UINavigationController {
            nav.navigationBar.standardAppearance  = appearance
            nav.navigationBar.scrollEdgeAppearance = nav.navigationBar.standardAppearance
        } else if let nav = self.uiviewController.navigationController{
            nav.navigationBar.standardAppearance  = appearance
            nav.navigationBar.scrollEdgeAppearance = nav.navigationBar.standardAppearance
        }
    }
    
}
