import LoggedOutFeatureInterface
import DependencyFoundation
import DependencyMacros
import LoadingFeatureInterface
import UserSessionServiceInterface
import UIKit
import WindowServiceInterface

@ViewControllerBuilder(arguments: LoggedOutFeature.self)
@ViewControllerInjectable
public final class LoggedOutFeatureViewController: UIViewController {
    @Arguments private let arguments: LoggedOutFeature
    @Inject private let userSessionService: UserSessionService
    @Inject private let userSessionStorageService: UserSessionStorageService
    @Inject private let windowService: WindowService
    @Inject private let loadingFeatureBuilder: any Builder<LoadingFeature, UIViewController>

    private let textField = UITextField()
    private let textFieldContainerView = UIView()
    private let logInButton = UIButton()

    // MARK: View Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Configure the view:
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.backgroundColor = .systemBackground
        
        // Configure the text field:
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        self.textField.textColor = .label
        self.textField.textAlignment = .center
        self.textField.font = .preferredFont(forTextStyle: .headline)
        self.textField.adjustsFontForContentSizeCategory = true
        self.textField.placeholder = "Username"
        self.textField.backgroundColor = .systemGroupedBackground
        self.textField.layer.cornerRadius = 16

        // Configure the text field container view:
        self.textFieldContainerView.translatesAutoresizingMaskIntoConstraints = false

        // Configure the log in button:
        self.logInButton.translatesAutoresizingMaskIntoConstraints = false
        var logInButtonConfiguration = UIButton.Configuration.borderless()
        logInButtonConfiguration.attributedTitle = AttributedString("Log In", attributes: .init([
            .font : UIFont.preferredFont(forTextStyle: .headline),
            .foregroundColor : UIColor.darkText
        ]))
        logInButtonConfiguration.background.backgroundColor = .systemYellow
        logInButtonConfiguration.background.cornerRadius = 16
        self.logInButton.configuration = logInButtonConfiguration

        // Create the view hierarchy:
        self.textFieldContainerView.addSubview(self.textField)
        self.view.addSubview(self.textFieldContainerView)
        self.view.addSubview(self.logInButton)

        // Create the constraints:
        NSLayoutConstraint.activate([
            self.textField.heightAnchor.constraint(greaterThanOrEqualToConstant: 48),
            self.textFieldContainerView.centerYAnchor.constraint(equalTo: self.textField.centerYAnchor),
            self.textFieldContainerView.leadingAnchor.constraint(equalTo: self.textField.leadingAnchor, constant: -24),
            self.textFieldContainerView.trailingAnchor.constraint(equalTo: self.textField.trailingAnchor, constant: 24),

            self.view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: self.textFieldContainerView.topAnchor),
            self.view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: self.textFieldContainerView.leadingAnchor),
            self.view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: self.textFieldContainerView.trailingAnchor),
            self.logInButton.topAnchor.constraint(equalTo: self.textFieldContainerView.bottomAnchor),

            self.logInButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 48),
            self.view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: self.logInButton.leadingAnchor, constant: -24),
            self.view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: self.logInButton.trailingAnchor, constant: 24),
            self.view.keyboardLayoutGuide.topAnchor.constraint(equalTo: self.logInButton.bottomAnchor, constant: 24),
        ])

        // Add the button action:
        self.logInButton.addTarget(self, action: #selector(logInButtonTapped), for: .touchUpInside)
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.textField.becomeFirstResponder()
    }

    // MARK: Private

    @objc
    private func logInButtonTapped() {
        Task.detached {
            do {
                let userSession = try await self.userSessionService.createSession(
                    username: self.textField.text ?? "",
                    password: "1234"
                )

                await self.buildLoadingFeature(userSession: userSession)
            } catch {
                print(error)
            }
        }
    }

    @MainActor
    private func buildLoadingFeature(userSession: UserSession) {
        self.userSessionStorageService.userSession = userSession
        let builder = self.loadingFeatureBuilder
        self.windowService.register {
            let arguments = LoadingFeature(userSession: userSession)
            return builder.build(arguments: arguments)
        }
    }
}
