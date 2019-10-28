import XRouter

/**
 Routes
 */
enum Route: RouteType {
    
    /// Tab 1 home
    case tab1Home
    
    /// Tab 2 home
    case tab2Home
    
    /// Example pushed view controller
    case pushedVC
    
    /// Example modal view controller
    case modalVC
    
    // MARK: - Helper
    
    /// Register URLs
    static func registerURLs() -> URLMatcherGroup<Route>? {
        return .group("hubr.io") {
            $0.map("tab2/home") { .tab2Home }
        }
    }
    
}
