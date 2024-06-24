import Saber
import InboxFeatureInterface
import InboxServiceInterface
import MemberwiseServiceInterface
import UIKit

private let reuseIdentifier = "Cell"

@Injectable(UIViewController.self)
public final class InboxViewController: UIViewController {
    @Inject var date: Date
    @Inject var inboxService: any InboxService
    @Inject var memberwiseService: any MemberwiseService
    private let tableView = UITableView()

    public init(arguments: Arguments, dependencies: any Dependencies) {
        self._arguments = arguments
        self._dependencies = dependencies
        super.init(nibName: nil, bundle: nil)

        // Configure the tab bar item:
        self.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage.init(systemName: "tray.fill"),
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
        self.navigationItem.title = "Inbox"

        // Configure the view:
        self.view.backgroundColor = .white
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.backgroundColor = .white
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.view.addSubview(self.tableView)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
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

extension InboxViewController: UITableViewDataSource {
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

extension InboxViewController: UITableViewDelegate {

}
