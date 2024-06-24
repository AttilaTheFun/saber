import Saber
import OptionalServiceInterface
import UIKit

private let reuseIdentifier = "Cell"

@Injectable(UIViewController.self)
public final class SendToViewController: UIViewController {
    @Inject var image: UIImage
    @Inject var optionalService: (any OptionalService)?
    private let tableView = UITableView()
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

        // Configure the navigation item:
        self.navigationItem.title = "Send To"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(closeButtonTapped)
        )

        // Configure the view:
        self.view.backgroundColor = .white
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.backgroundColor = .white
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.view.addSubview(self.tableView)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
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
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.sendButton.widthAnchor.constraint(equalToConstant: 64),
            self.sendButton.heightAnchor.constraint(equalToConstant: 64),
            self.sendButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24),
            self.sendButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: Private

    @objc
    private func closeButtonTapped() {
        self.navigationController?.popViewController(animated: false)
    }

    @objc
    private func sendButtonTapped() {
        self.navigationController?.popToRootViewController(animated: false)
    }
}

extension SendToViewController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = "John Smith"
        return cell
    }
}

extension SendToViewController: UITableViewDelegate {

}
