import XRouter

/**
 Router
 */
class Router: XRouter<Route> {
    
    private let container: Container
    
    // MARK: - Methods
    
    /// Constructor
    public init(container: Container) {
        self.container = container
        super.init()
    }
    
    // MARK: - RouteHandler
    
    /// Prepare the route for transition and return the view controller
    ///  to transition to on the view hierachy
    override func prepareDestination(for route: Route) throws -> UIViewController {
        switch route {
        case .tab1Home: return container.tab1Coordinator.gotoTabHome()
        case .tab2Home: return container.tab2Coordinator.navigationController.viewControllers[0]
        case .pushedVC: return container.tab2SecondViewController
        case .modalVC: return container.modalCoordinator.start()
        }
    }
}
