import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var coordinator: Coordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions
                     launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithDefaultBackground()
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        coordinator = Coordinator()
        coordinator?.start()
        setupUserDefaults()
        return true
    }

    private func setupUserDefaults() {
        let userDefaults = UserDefaults.standard
        if !userDefaults.bool(forKey: "isNotFirstLauch") {
            userDefaults.set(true, forKey: "isNotFirstLauch")
            userDefaults.set(true, forKey: "sortByNormalOrder")
            userDefaults.set(true, forKey: "showPhotoSize")
        }
        userDefaults.set(true, forKey: "isNotFirstLauch")

    }

}
