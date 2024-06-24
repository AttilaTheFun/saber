import Saber
import SendToFeatureInterface
import UIKit

@Injectable(UIViewController.self)
public final class PreviewViewController: UIViewController {
    @Inject var image: UIImage
    @Inject var sendToViewControllerFactory: Factory<SendToScopeArguments, UIViewController>
    private let imageView = UIImageView()
    private let closeButton = UIButton()
    private let sendButton = UIButton()

    public init(arguments: Arguments, dependencies: any Dependencies) {
        self._arguments = arguments
        self._dependencies = dependencies
        super.init(nibName: nil, bundle: nil)

        // Configure the tab bar item:
        self.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage.init(systemName: "camera.fill"),
            tag: 0
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Configure the view:
        self.view.backgroundColor = .black
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.backgroundColor = .lightGray
        self.imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.imageView.layer.cornerRadius = 48
        self.imageView.clipsToBounds = true
        self.imageView.image = self.image
        self.view.addSubview(self.imageView)
        self.closeButton.translatesAutoresizingMaskIntoConstraints = false
        self.closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        self.closeButton.tintColor = .white
        self.closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        self.view.addSubview(self.closeButton)
        self.sendButton.translatesAutoresizingMaskIntoConstraints = false
        self.sendButton.layer.cornerRadius = 32
        self.sendButton.layer.borderWidth = 8
        self.sendButton.layer.borderColor = UIColor.white.cgColor
        self.sendButton.backgroundColor = .systemBlue
        self.sendButton.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        self.sendButton.tintColor = .white
        self.sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        self.view.addSubview(self.sendButton)
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.closeButton.widthAnchor.constraint(equalToConstant: 64),
            self.closeButton.heightAnchor.constraint(equalToConstant: 64),
            self.closeButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.closeButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            self.sendButton.widthAnchor.constraint(equalToConstant: 64),
            self.sendButton.heightAnchor.constraint(equalToConstant: 64),
            self.sendButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24),
            self.sendButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: Private

    @objc
    private func closeButtonTapped() {
        self.navigationController?.popViewController(animated: false)
    }

    @objc
    private func sendButtonTapped() {
        let sendToScopeArguments = SendToScopeArguments(image: image)
        let sendToViewController = self.sendToViewControllerFactory.build(arguments: sendToScopeArguments)
        self.navigationController?.pushViewController(sendToViewController, animated: false)
    }
}
