import DependencyFoundation
import DependencyMacrosFoundation
import LoggedInFeatureInterface
import LoggedInFeatureInterface
import LoggedOutFeatureInterface
import UserSessionServiceInterface
import UserServiceInterface
import UIKit
import WindowServiceInterface

// TODO: Generate with @Injectable macro.
public typealias LoggedInFeatureViewControllerDependencies
    = DependencyProvider
    & LoggedOutFeatureBuilderProvider
    & UserSessionServiceProvider
    & UserSessionStorageServiceProvider
    & UserStorageServiceProvider
    & WindowServiceProvider

// @Injectable
@ViewControllerBuilder(arguments: LoggedInFeature.self)
final class LoggedInFeatureViewController: UIViewController {

    // @Arguments
    private let loggedInFeature: LoggedInFeature

    // @Inject
    private let userSessionService: UserSessionService

    // @Inject
    private let userSessionStorageService: UserSessionStorageService

    // @Inject
    private let userStorageService: UserStorageService

    // @Inject
    private let windowService: WindowService

    // @Inject
    private let loggedOutFeatureBuilder: any Builder<LoggedOutFeature, UIViewController>

    private let label = UILabel()
    private let labelContainerView = UIView()
    private let logOutButton = UIButton()

    // TODO: Generate with @Injectable macro.
    init(dependencies: LoggedInFeatureViewControllerDependencies, arguments: LoggedInFeature) {
        self.loggedInFeature = arguments
        self.userStorageService = dependencies.userStorageService
        self.userSessionService = dependencies.userSessionService
        self.userSessionStorageService = dependencies.userSessionStorageService
        self.windowService = dependencies.windowService
        self.loggedOutFeatureBuilder = dependencies.loggedOutFeatureBuilder
        super.init(nibName: nil, bundle: nil)
    }

    // TODO: Generate with @Injectable macro.
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure the view:
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.backgroundColor = .systemBackground
        
        // Configure the text field:
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.textColor = .label
        self.label.textAlignment = .center
        self.label.font = .preferredFont(forTextStyle: .headline)
        self.label.adjustsFontForContentSizeCategory = true
        self.label.backgroundColor = .systemGroupedBackground
        self.label.clipsToBounds = true
        self.label.layer.cornerRadius = 16
        self.label.text = "Logged in as \(self.loggedInFeature.user.username)"

        // Configure the text field container view:
        self.labelContainerView.translatesAutoresizingMaskIntoConstraints = false

        // Configure the log out button:
        self.logOutButton.translatesAutoresizingMaskIntoConstraints = false
        var logOutButtonConfiguration = UIButton.Configuration.borderless()
        logOutButtonConfiguration.attributedTitle = AttributedString("Log Out", attributes: .init([
            .font : UIFont.preferredFont(forTextStyle: .headline),
            .foregroundColor : UIColor.darkText
        ]))
        logOutButtonConfiguration.background.backgroundColor = .systemYellow
        logOutButtonConfiguration.background.cornerRadius = 16
        self.logOutButton.configuration = logOutButtonConfiguration

        // Create the view hierarchy:
        self.labelContainerView.addSubview(self.label)
        self.view.addSubview(self.labelContainerView)
        self.view.addSubview(self.logOutButton)

        // Create the constraints:
        NSLayoutConstraint.activate([
            self.label.heightAnchor.constraint(greaterThanOrEqualToConstant: 48),
            self.labelContainerView.centerYAnchor.constraint(equalTo: self.label.centerYAnchor),
            self.labelContainerView.leadingAnchor.constraint(equalTo: self.label.leadingAnchor, constant: -24),
            self.labelContainerView.trailingAnchor.constraint(equalTo: self.label.trailingAnchor, constant: 24),

            self.view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: self.labelContainerView.topAnchor),
            self.view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: self.labelContainerView.leadingAnchor),
            self.view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: self.labelContainerView.trailingAnchor),
            self.logOutButton.topAnchor.constraint(equalTo: self.labelContainerView.bottomAnchor),

            self.logOutButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 48),
            self.view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: self.logOutButton.leadingAnchor, constant: -24),
            self.view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: self.logOutButton.trailingAnchor, constant: 24),
            self.view.keyboardLayoutGuide.topAnchor.constraint(equalTo: self.logOutButton.bottomAnchor, constant: 24),
        ])

        // Add the button action:
        self.logOutButton.addTarget(self, action: #selector(logOutButtonTapped), for: .touchUpInside)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.label.becomeFirstResponder()
    }

    // MARK: Private

    @objc
    private func logOutButtonTapped() {
        Task.detached {
            do {
                try await self.userSessionService.deleteSession(id: self.loggedInFeature.userSession.id)
            } catch {
                print(error)
            }

            await self.buildLoggedOutFeature()
        }
    }

    @MainActor
    private func buildLoggedOutFeature() {
        self.userStorageService.user = nil
        self.userSessionStorageService.userSession = nil
        let builder = self.loggedOutFeatureBuilder
        self.windowService.register {
            let arguments = LoggedOutFeature()
            return builder.build(arguments: arguments)
        }
    }
}
