# XRouter

A simple routing library for iOS projects.

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/d0ef88b70fc843adb2944ce0d956269d)](https://app.codacy.com/app/hubrioAU/XRouter?utm_source=github.com&utm_medium=referral&utm_content=hubrioAU/XRouter&utm_campaign=Badge_Grade_Dashboard)
[![CodeCov Badge](https://codecov.io/gh/hubrioAU/XRouter/branch/master/graph/badge.svg)](https://codecov.io/gh/hubrioau/XRouter)
[![Build Status](https://travis-ci.org/hubrioAU/XRouter.svg?branch=master)](https://travis-ci.org/hubrioAU/XRouter)
[![Docs Badge](https://raw.githubusercontent.com/hubrioAU/XRouter/master/docs/badge.svg?sanitize=true)](https://hubrioau.github.io/XRouter)
[![Version](https://img.shields.io/cocoapods/v/XRouter.svg?style=flat)](https://cocoapods.org/pods/XRouter)
[![License](https://img.shields.io/cocoapods/l/XRouter.svg?style=flat)](https://cocoapods.org/pods/XRouter)
[![Platform](https://img.shields.io/cocoapods/p/XRouter.svg?style=flat)](https://cocoapods.org/pods/XRouter)

<p align="center">
<img src="https://raw.githubusercontent.com/hubrioau/XRouter/master/XRouter.jpg" alt="XRouter" width="625" style="max-width:625px;width:auto;height:auto;"/>
</p>

## Usage
### Basic Usage

#### Define Routes
```swift
enum Route: RouteType {
    case homeTab
    case login
    case profile(withID: Int)
}
```

#### Create your Router
```swift
class Router: XRouter<Route> {

    /* ... */

    /// Configure the destination view controller for the route
    override func prepareForTransition(to route: Route) throws -> UIViewController {
        switch route {
        case .homeTab:
            return container.resolve(HomeTabCoordinator.self)?.rootViewController
        case .login:
            return container.resolve(LoginFlowCoordinator.self)?.startFlow()
        case .profile(let id):
            return ProfileViewController(withID: id)
        }
    }

}
```

#### Using a Router
```swift
// Create a router
let router = Router()

// Navigate to a route
router.navigate(to: .loginFlow)

// ... or open a route from a URL
router.openURL(url)
```

### RxSwift Support
XRouter also implements reactive bindings for the RxSwift framework. Bindings exist for `navigate(to:)`, which returns a `Completable`, and `openURL(_:)`, which returns a `Single<Bool>`.
```swift
router.rx.navigate(to: .loginFlow) // -> Completable
router.rx.openURL(url) // -> Single<Bool>
```

### Advanced Usage

#### URL Support

- Note: XRouter supports deep links and universal links.

You only need to do one thing to add URL support for your routes.
Implement the static method `registerURLs`:
```swift
enum Route: RouteType {

    /* ... */

    /// Register URLs
    static func registerURLs() -> URLMatcherGroup<Route>? {
        return .group("store.example.com") {
            $0.map("products") { .allProducts }
            $0.map("user/*/logout") { .logout }

            $0.map("products/{category}/view") {
              try .products(category: $0.param("category"))
            }

            $0.map("user/{id}/profile") {
              try .viewProfile(withID: $0.param("id"))
            }
        }
    }

}
```

Here is an example with multiple hosts:
```swift
enum Route: RouteType {

    /* ... */

    /// Register URLs
    static func registerURLs() -> URLMatcherGroup<Route>? {
        return .init(matchers: [
            .group(["example.com", "store.example.com"]) {
                $0.map("products/") { .allProducts }
                $0.map("products/{category}/view") { try .products(category: $0.param("category")) }
                $0.map("user/{id}/profile") { try .viewProfile(withID: $0.param("id")) }
                $0.map("user/*/logout") { .logout }
            },
            .group("affiliate.website.net.au") {
                $0.map("*/referral/") { .openReferralProgram(for: $0.rawURL) }
            }
        ])
    }

}
```

Then you can call the `openURL(_:animated:completion:)` and/or `continue(_ userActivity:)` methods, e.g. from in your AppDelegate:
```swift
extension AppDelegate {

    /// Open URL
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return router.openURL(url, animated: false)
    }

    /// Continue user activity (universal links)
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return router.continue(userActivity)
    }

}
```

#### Handling errors

If you handle all navigation errors in the same way, you can override the `received(unhandledError:)` method.

```swift
class Router: XRouter<Route> {

    /* ... */

    /// Received an error during
    override func received(unhandledError error: Error) {
        log.error("Oh no! An error occured: \(error)")
    }

}

```

Or you can set a custom completion handler for some individual navigation action:

```swift
router.navigate(to: .profilePage(withID: 24)) { (optionalError) in
    if let error = optionalError {
        print("Oh no, we couldn't go here because there was an error!")
    }
}
```

#### Custom Transitions
Here is an example using the popular [Hero Transitions](https://github.com/HeroTransitions/Hero) library.

Set the `customTransitionDelegate` for the `Router`:
```swift
router.customTransitionDelegate = self
```

(Optional) Define your custom transitions in an extension so you can refer to them statically
```swift
extension RouteTransition {
    static var heroCrossFade: RouteTransition {
        return .custom(identifier: "HeroCrossFade")
    }
}
```

Implement the delegate method `performTransition(...)`:
```swift

extension Router: RouterCustomTransitionDelegate {

    /// Handle custom transitions
    func performTransition(to viewController: UIViewController,
                           from sourceViewController: UIViewController,
                           transition: RouteTransition,
                           animated: Bool,
                           completion: ((Error?) -> Void)?) {
        if transition == .heroCrossFade {
            sourceViewController.hero.isEnabled = true
            destViewController.hero.isEnabled = true
            destViewController.hero.modalAnimationType = .fade

            // Creates a container nav stack
            let containerNavController = UINavigationController()
            containerNavController.hero.isEnabled = true
            containerNavController.setViewControllers([newViewController], animated: false)

            // Present the hero animation
            sourceViewController.present(containerNavController, animated: animated) {
                completion?(nil)
            }
        } else {
            completion?(nil)
        }
    }

}
```

And override the transition to your custom in your Router:
```swift
    override func transition(for route: Route) -> RouteTransition {
        switch route {
            case .profile:
                return .heroCrossFade
            default:
                return super.transition(for: route)
        }
    }
```

## Documentation

Complete [documentation is available here](https://reececomo.github.io/XRouter).

## Example

To run the example project, clone the repo, and run it in Xcode 10.

## Requirements

## Installation

### CocoaPods

XRouter is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'XRouter'
```

## Author

Reece Como, reece@hubr.io

## License

XRouter is available under the MIT license. See the LICENSE file for more info.
