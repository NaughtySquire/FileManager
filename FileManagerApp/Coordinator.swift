//
//  Coordinator.swift
//  FileManagerApp
//
//  Created by Роман Олегович on 10.11.2022.
//

import UIKit

struct Coordinator {
    private let navigationController = UINavigationController()
    private let window = UIWindow(frame: UIScreen.main.bounds)

    func start() {
        window.rootViewController = navigationController
        showPassword()
        window.makeKeyAndVisible()
    }

    private func showPassword() {
        let passwordVC = PasswordViewController()
        passwordVC.passwordChecked = {
            navigationController.viewControllers.removeAll()
            showMain()
        }
        navigationController.pushViewController(passwordVC, animated: false)
    }

    private func presentPasswordFrom(_ viewController: UIViewController) {
        let passwordVC = PasswordViewController(updatePassword: true)
        passwordVC.passwordChecked = {
            viewController.dismiss(animated: true)
        }
        viewController.present(passwordVC, animated: true)
    }

    private func showMain() {
        navigationController.navigationBar.prefersLargeTitles = true
        let settingsVC = getSettingsVC()
        let directoryVC = getDirectoryVC()
        let tabBar = UITabBarController()
        tabBar.viewControllers = [directoryVC, settingsVC]
        navigationController.pushViewController(tabBar, animated: true)
    }

    private func getSettingsVC() -> SettingsViewController {
        let settingsVC = SettingsViewController()
        settingsVC.changePasswordButtonTapped = {
            presentPasswordFrom(settingsVC)
        }
        return settingsVC
    }

    private func getDirectoryVC() -> DirectoryViewController {
        do {
            let documentsURL = try FileManager.default.url(for: .documentDirectory,
                                                           in: .userDomainMask,
                                                           appropriateFor: nil,
                                                           create: false)
            let fileManagerService = FileManagerService()
            let directoryVC = DirectoryViewController(fileManagerService, documentsURL)
            return directoryVC
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }

}
