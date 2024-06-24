import Saber
import ProfileFeatureInterface
import LoggedOutFeatureInterface
import UserSessionServiceInterface
import UserServiceInterface
import UIKit
import WindowServiceInterface

@Injectable(UIViewController.self)
public final class ProfileViewController: UIViewController {
    @Inject private var user: User
    @Inject private var userSession: UserSession
    @Inject private var userSessionService: any UserSessionService
    @Inject private var userSessionStorageService: any UserSessionStorageService
    @Inject private var userStorageService: any UserStorageService
    @Inject private var windowService: any WindowService
    @Inject private var loggedOutViewControllerFactory: Factory<LoggedOutScopeArguments, UIViewController>

    private let logOutButton = UIButton()

    // MARK: View Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Configure the navigation item:
        self.navigationItem.title = self.user.username
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(closeButtonTapped)
        )

        // Configure the views:
        self.view.backgroundColor = .white
        self.logOutButton.translatesAutoresizingMaskIntoConstraints = false
        var logOutButtonConfiguration = UIButton.Configuration.borderless()
        logOutButtonConfiguration.attributedTitle = AttributedString("Log Out", attributes: .init([
            .font : UIFont.preferredFont(forTextStyle: .headline),
            .foregroundColor : UIColor.darkText
        ]))
        logOutButtonConfiguration.background.backgroundColor = .systemYellow
        logOutButtonConfiguration.background.cornerRadius = 16
        self.logOutButton.configuration = logOutButtonConfiguration
        self.logOutButton.addTarget(self, action: #selector(logOutButtonTapped), for: .touchUpInside)
        self.view.addSubview(self.logOutButton)

        // Create the constraints:
        NSLayoutConstraint.activate([
            self.logOutButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 48),
            self.logOutButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24),
            self.logOutButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24),
            self.logOutButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
        ])
    }

    // MARK: Private

    @objc
    private func closeButtonTapped() {
        self.dismiss(animated: true)
    }

    @objc
    private func logOutButtonTapped() {
        Task.detached {
            do {
                try await self.userSessionService.deleteSession(id: self.userSession.id)
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
        let factory = self.loggedOutViewControllerFactory
        self.windowService.register {
            let arguments = LoggedOutScopeArguments()
            return factory.build(arguments: arguments)
        }
    }
}
