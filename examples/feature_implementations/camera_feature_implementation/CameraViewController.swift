import Saber
import CameraFeatureInterface
import UIKit
import PhotosUI

@Injectable(UIViewController.self)
public final class CameraViewController: UIViewController {
    private let imagePickerViewController = UIImagePickerController()

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

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Configure the view:
        self.view.backgroundColor = .black
        self.imagePickerViewController.delegate = self
        self.imagePickerViewController.sourceType = .camera
        self.imagePickerViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(self.imagePickerViewController)
        self.view.addSubview(self.imagePickerViewController.view)
        self.imagePickerViewController.didMove(toParent: self)
        NSLayoutConstraint.activate([
            self.imagePickerViewController.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.imagePickerViewController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.imagePickerViewController.view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.imagePickerViewController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
    }
}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

    }
}
