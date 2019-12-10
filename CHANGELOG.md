# Change Log

Notable changes to this project will be documented in this file. See [standard-version](https://github.com/conventional-changelog/standard-version) for commit guidelines.

# [v2.0.0](https://github.com/hubrioAU/XRouter/releases/tag/2.0.0)
- ([#31](https://github.com/hubrioAU/XRouter/pull/31)): Add wildcard host/scheme matching to URL matcher, rename param to path
- ([#31](https://github.com/hubrioAU/XRouter/pull/31)): Update RouteTransitions
  - Update `RouteTransition.push` behaviour, removed `RouteTransition.set` and added `RouteTransition.replace`
  - Renamed `RouteTransition.inferred` to `RouteTransition.automatic`

# [v1.4.1](https://github.com/hubrioAU/XRouter/releases/tag/1.4.1)
- ([#29](https://github.com/hubrioAU/XRouter/pull/29)): Renamed the XRouter method `prepareForNavigation(to:)` to `viewController(for:)` to be a little more explicit about what it's role is.
- refactored `received(unhandledError:)`.

# [v1.4.0](https://github.com/hubrioAU/XRouter/releases/tag/1.4.0)
- ([#27](https://github.com/hubrioAU/XRouter/pull/27)): Changed the implementation of `RouteTransition` to remove the need for a custom transition delegate. Now create custom RouteTransitions directly.
- Renamed `RoutingHandler` to `RouteHandler`.
- All routes (conforming to `RouteType`) are unique on parameters by default. For example, prior to this change `.profile(id: 22) == .profile(id: 44)` would have equated to `true`. To override this, implement `uniqueOnParameters` in your `RouteType`.

# [v1.3.2](https://github.com/hubrioAU/XRouter/releases/tag/1.3.2)
- ([#26](https://github.com/hubrioAU/XRouter/pull/26)) [csknns](https://github.com/csknns): Dropped the minimum iOS requirement from iOS 11.0 to iOS 10.0 in Podspec.

# [v1.3.1](https://github.com/hubrioAU/XRouter/releases/tag/1.3.1)
- Added `continue(_ userActivity:)` handler for Universal Links

# [v1.3.0](https://github.com/hubrioAU/XRouter/releases/tag/1.3.0)
- Renamed `Router` to `XRouter`.
- Moved navigation transition logic to `Navigator` class.
- Renamed `RouteProvider` to `RouteType`.
- Moved `prepareForTransition(...)` to new class `RoutingHandler`.
- Added `RouteTransition.inferred` which automatically infers transition type.
- Added `received(unhandledError:)` handler to `XRouter`.
- Removed `UIApplication` specific logic. Router now manages a specific UIWindow (defaults to lazy load `UIApplication.shared.keyWindow`).

# [v1.2.6](https://github.com/hubrioAU/XRouter/releases/tag/1.2.6)
- Use the delegate method [tabBarController(_:shouldSelect:)](https://developer.apple.com/documentation/uikit/uitabbarcontrollerdelegate/1621166-tabbarcontroller) before transitioning between tabs.
- Improve the Example project/UI Tests.

# [v1.2.3 - v1.2.5](https://github.com/hubrioAU/XRouter/releases/tag/1.2.4)
- Added RxSwift extension.
- Update RxSwift extension method `openURL(_:)` to return `Single<Bool>` instead of `Completable`.
- Bugfix for [v1.2.4](https://github.com/hubrioAU/XRouter/releases/tag/1.2.4) to fix RxSwift import.

# [v1.2.1](https://github.com/hubrioAU/XRouter/releases/tag/1.2.1)
- Improve support for UITabBarController, fix issue with UINavigationController set transition.

# [v1.1.0](https://github.com/hubrioAU/XRouter/releases/tag/1.1.0)
- Added URL mapping, deep links and universal link support.
- Added `openURL(_:)` method to Router.

# [v1.0.0](https://github.com/hubrioAU/XRouter/releases/tag/1.0.0)
- Initial release.
