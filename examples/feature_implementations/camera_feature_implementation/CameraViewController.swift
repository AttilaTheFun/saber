import Saber
import CameraFeatureInterface
import ProfileFeatureInterface
import PreviewFeatureInterface
import UIKit
import PhotosUI

@Injectable(UIViewController.self)
public final class CameraViewController: UIViewController {
    @Inject var profileViewControllerFactory: Factory<ProfileScopeArguments, UIViewController>
    @Inject var previewViewControllerFactory: Factory<PreviewScopeArguments, UIViewController>
    private let cameraView = UIView()
    private let profileButton = UIButton()
    private let captureButton = UIButton()

    // MARK: View Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Configure the view:
        self.view.backgroundColor = .black
        self.cameraView.translatesAutoresizingMaskIntoConstraints = false
        self.cameraView.backgroundColor = .lightGray
        self.cameraView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.cameraView.layer.cornerRadius = 48
        self.cameraView.clipsToBounds = true
        self.view.addSubview(self.cameraView)
        self.profileButton.translatesAutoresizingMaskIntoConstraints = false
        self.profileButton.setImage(UIImage(systemName: "person.fill"), for: .normal)
        self.profileButton.tintColor = .white
        self.profileButton.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        self.view.addSubview(self.profileButton)
        self.captureButton.translatesAutoresizingMaskIntoConstraints = false
        self.captureButton.layer.cornerRadius = 48
        self.captureButton.layer.borderWidth = 12
        self.captureButton.layer.borderColor = UIColor.white.cgColor
        self.captureButton.addTarget(self, action: #selector(captureButtonTapped), for: .touchUpInside)
        self.view.addSubview(self.captureButton)
        NSLayoutConstraint.activate([
            self.cameraView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.cameraView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.cameraView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.cameraView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.profileButton.widthAnchor.constraint(equalToConstant: 64),
            self.profileButton.heightAnchor.constraint(equalToConstant: 64),
            self.profileButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.profileButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            self.captureButton.widthAnchor.constraint(equalToConstant: 96),
            self.captureButton.heightAnchor.constraint(equalToConstant: 96),
            self.captureButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.captureButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -32)
        ])
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: Private

    @objc
    private func profileButtonTapped() {
        let profileScopeArguments = ProfileScopeArguments()
        let profileViewController = self.profileViewControllerFactory.build(arguments: profileScopeArguments)
        let profileNavigationController = UINavigationController(rootViewController: profileViewController)
        self.present(profileNavigationController, animated: true)
    }

    @objc
    private func captureButtonTapped() {
        guard let image = UIImage(named: "Sample") else {
            return
        }

        let previewScopeArguments = PreviewScopeArguments(image: image)
        let previewViewController = self.previewViewControllerFactory.build(arguments: previewScopeArguments)
        self.navigationController?.pushViewController(previewViewController, animated: false)
    }
}
