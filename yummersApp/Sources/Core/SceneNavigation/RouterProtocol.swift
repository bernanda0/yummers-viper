import UIKit

protocol RouterProtocol {
    func setRootViewController(_ viewController: UIViewController)
    func push(_ viewController: UIViewController, animated: Bool)
    func pop(animated: Bool)
    func popToRootViewController(animated: Bool)
    func present(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?)
    func dismiss(animated: Bool, completion: (() -> Void)?)
}


