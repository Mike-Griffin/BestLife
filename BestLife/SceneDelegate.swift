//
//  SceneDelegate.swift
//  BestLife
//
//  Created by Mike Griffin on 4/1/20.
//  Copyright © 2020 Mike Griffin. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene

        let homeScreenVC = HomeScreenVC()
        let homeNavigationController = UINavigationController(rootViewController: homeScreenVC)
        homeNavigationController.navigationBar.barTintColor = .lightGray
        let app = UINavigationBarAppearance()
        app.configureWithOpaqueBackground()

        app.backgroundColor = .white
        homeNavigationController.navigationBar.scrollEdgeAppearance = app
        homeNavigationController.navigationBar.standardAppearance = app
        
        let homeNavItem = UITabBarItem()
        homeNavItem.image = UIImage(systemName: "house")
        homeNavItem.title = "Home"
        homeNavigationController.tabBarItem = homeNavItem
        
        let createHabitScreenVC = CreateHabitScreenVC()
        let createHabitNavigationController = UINavigationController(rootViewController: createHabitScreenVC)
        createHabitNavigationController.navigationBar.barTintColor = .lightGray
        let createHabitItem = UITabBarItem()
        createHabitItem.title = "Create"
        createHabitItem.image = UIImage(systemName: "lightbulb")
        createHabitNavigationController.tabBarItem = createHabitItem


        let createGoalScreenVC = CreateGoalScreenVC()
        let createGoalNavigationController = UINavigationController(rootViewController: createGoalScreenVC)
        createGoalNavigationController.navigationBar.barTintColor = .lightGray
        let createGoalItem = UITabBarItem()
        createGoalItem.title = "Goal"
        createGoalItem.image = UIImage(systemName: "alarm")
        createGoalNavigationController.tabBarItem = createGoalItem
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [homeNavigationController, createHabitNavigationController, createGoalNavigationController]
        tabBarController.tabBar.barTintColor = .lightGray
        tabBarController.tabBar.tintColor = .black
        tabBarController.tabBar.unselectedItemTintColor = .gray
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()

    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
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

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

