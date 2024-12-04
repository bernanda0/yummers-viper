// SceneDelegate.swift
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var sceneNavigator: Router?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // Create the window
        window = UIWindow(windowScene: windowScene)
        
        // Create the main NavigationController
        let navigationController = UINavigationController()
        
        // Initialize SceneNavigator with the navigation controller
        let sceneNavigator = Router(navigationController: navigationController)
        self.sceneNavigator = sceneNavigator
        
        // Create RootViewController with the SceneNavigator
        let rootViewController = RootViewController(router: sceneNavigator)
        
        // Set the root view controller of the navigation controller
        navigationController.viewControllers = [rootViewController]
        
        // Set the navigation controller as the window's root view controller
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}