import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithDefaultBackground()
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance


        window = UIWindow(frame: UIScreen.main.bounds)
        do{
            let documentsURL = try FileManager.default.url(for: .documentDirectory,
                                                           in: .userDomainMask,
                                                           appropriateFor: nil,
                                                           create: false)
            let fileManagerService = FileManagerService()
            let navigationController = UINavigationController(rootViewController: DirectoryViewController(fileManagerService, documentsURL))
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
        } catch let error{
            print(error)
        }
        return true
    }

}

