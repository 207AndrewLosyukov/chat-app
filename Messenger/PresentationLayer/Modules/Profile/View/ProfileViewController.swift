import UIKit
import AVFoundation
import Combine

class ProfileViewController: UIViewController {

    enum Constants {
        static var whiteViewHeight = 402.0
        static var editButtonHeight = 50.0
        static var editButtonBottomConstraint = 16.0
        static var animationDuration = 0.3
    }

    private var output: ProfileViewOutput
    private var theme: Theme?
    private var editingConstraints: [NSLayoutConstraint] = []
    private var isButtonAnimating = false

    var photoCollectionModuleOutput: ModuleAvailableToOpenPhotoCollection?

    private var editButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hexString: "#007AFF")
        button.tintColor = .white
        button.setTitle("Edit Profile", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 14
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var addPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Photo", for: .normal)
        button.setTitleColor(Resources.Colors.active, for: .normal)
        button.setTitleColor(Resources.Colors.inactive, for: .disabled)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.addTarget(self, action: #selector(addPhotoButtonHandler), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var profileIconView: UserProfileIconView = {
        let profileIconView = UserProfileIconView(image: Resources.Images.noNameImage)
        profileIconView.translatesAutoresizingMaskIntoConstraints = false
        profileIconView.layer.masksToBounds = true
        return profileIconView
    }()

    private lazy var editingView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.backgroundColor = .white
        whiteView.layer.cornerRadius = 10
        whiteView.translatesAutoresizingMaskIntoConstraints = false
        return whiteView
    }()

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "No name"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "No bio specified"
        label.textAlignment = .center
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.sizeToFit()
        return label
    }()

    init(output: ProfileViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print(view.frame)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "My Profile"
        editButton.addTarget(self, action: #selector(editButtonOnTapHandler), for: .touchUpInside)
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(onPressed(_:)))
        editButton.addGestureRecognizer(longPressRecognizer)
        setupSubviews()
        setupConstraints()
        overrideUserInterfaceStyle = .light
    }

    override func viewWillAppear(_ animated: Bool) {
        output.loadTheme()
        output.loadNameLabel()
        output.loadDescriptionLabel()
        output.loadProfileImage()
    }

    func setupSubviews() {
        view.addSubview(whiteView)
        whiteView.addSubview(profileIconView)
        whiteView.addSubview(addPhotoButton)
        whiteView.addSubview(descriptionLabel)
        whiteView.addSubview(nameLabel)
        whiteView.addSubview(editButton)

        profileIconView.accessibilityIdentifier = "profileIconView"
        addPhotoButton.accessibilityIdentifier = "addPhotoButton"
        nameLabel.accessibilityIdentifier = "nameLabel"
    }

    func setupConstraints() {
        setupWhiteViewConstraints()
        setupProfileIconViewConstraints()
        setupAddPhotoButtonConstraints()
        setupNameLabelConstraints()
        setupDescriptionLabelConstraints()
        setupEditButtonConstraints()
    }

    func setupWhiteViewConstraints() {
        NSLayoutConstraint.activate([
            whiteView.topAnchor.constraint(equalTo: view.topAnchor),
            whiteView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            whiteView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            whiteView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            whiteView.heightAnchor.constraint(equalToConstant: Constants.whiteViewHeight)
        ])
    }

    func setupProfileIconViewConstraints() {
        NSLayoutConstraint.activate([
            profileIconView.centerXAnchor.constraint(equalTo: whiteView.centerXAnchor),
            profileIconView.topAnchor.constraint(equalTo: whiteView.topAnchor, constant: 32),
            profileIconView.heightAnchor.constraint(equalToConstant: 150),
            profileIconView.widthAnchor.constraint(equalToConstant: 150)
        ])
    }

    func setupAddPhotoButtonConstraints() {
        NSLayoutConstraint.activate([
            addPhotoButton.centerXAnchor.constraint(equalTo: whiteView.centerXAnchor),
            addPhotoButton.topAnchor.constraint(equalTo: profileIconView.bottomAnchor, constant: 24),
            addPhotoButton.heightAnchor.constraint(equalToConstant: 22)
        ])
    }

    func setupNameLabelConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: whiteView.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: addPhotoButton.bottomAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: whiteView.leadingAnchor, constant: 5),
            nameLabel.trailingAnchor.constraint(equalTo: whiteView.trailingAnchor, constant: -5),
            nameLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }

    func setupDescriptionLabelConstraints() {
        NSLayoutConstraint.activate([
            descriptionLabel.centerXAnchor.constraint(equalTo: whiteView.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 55),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -55),
            descriptionLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 44)
        ])
    }

    func setupEditButtonConstraints() {
        NSLayoutConstraint.activate([
            editButton.heightAnchor.constraint(equalToConstant: Constants.editButtonHeight),
            editButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editButton.leadingAnchor.constraint(equalTo: whiteView.leadingAnchor, constant: 16),
            editButton.trailingAnchor.constraint(equalTo: whiteView.trailingAnchor, constant: -16),
            editButton.bottomAnchor.constraint(equalTo: whiteView.bottomAnchor,
                constant: -Constants.editButtonBottomConstraint)
        ])
    }

    func setProfileIconView(image: UIImage) {
        profileIconView.image = image
    }

    @objc func editButtonOnTapHandler() {
        output.didTapEditProfile()
    }

    @objc func addPhotoButtonHandler() {
        let alert = UIAlertController()
        alert.addAction(UIAlertAction(title: "Сделать фото", style: .default, handler: { [weak self] (_) in
            self?.output.openPickerIfPossible(for: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Выбрать из галереи", style: .default, handler: { [weak self] (_) in
            self?.output.openPickerIfPossible(for: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Загрузить", style: .default, handler: { [weak self] (_) in
            if let self = self {
                self.photoCollectionModuleOutput?.openPhotoCollection(from: self) { [weak self] viewController in
                    self?.present(viewController, animated: true)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { (_) in
        }))
        self.present(alert, animated: true)
    }
}

extension ProfileViewController: ButtonPressedAnimateProtocol {

    @objc func onPressed(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .ended {
            if !isButtonAnimating {
                isButtonAnimating = true
                animateButton(with: Constants.animationDuration)
            } else {
                isButtonAnimating = false
                if let presentationLayer = editButton.layer.presentation() {
                    editButton.layer.transform = presentationLayer.transform
                    editButton.layer.removeAnimation(forKey: "shake")
                }
                UIView.animate(withDuration: Constants.animationDuration, animations: {
                    self.editButton.transform = .identity
                }, completion: { _ in
                    self.editButton.layer.removeAllAnimations()
                })
            }
        }
    }

    func animateButton(with duration: Double) {

        let translationAnimation = CABasicAnimation(keyPath: "position")
        let yPosition = Constants.whiteViewHeight -
        Constants.editButtonHeight / 2 - Constants.editButtonBottomConstraint
        translationAnimation.autoreverses = true
        translationAnimation.fromValue = CGPoint(x: view.frame.width / 2.0 - 5, y: yPosition - 5)
        translationAnimation.toValue = CGPoint(x: view.frame.width / 2.0 + 5, y: yPosition + 5)
        translationAnimation.duration = duration / 2
        translationAnimation.repeatCount = .infinity

        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.autoreverses = true
        rotationAnimation.fromValue = -.pi / 10.0
        rotationAnimation.toValue = .pi / 10.0
        rotationAnimation.duration = duration / 2
        rotationAnimation.repeatCount = .infinity

        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [rotationAnimation, translationAnimation]
        animationGroup.autoreverses = true
        animationGroup.duration = Constants.animationDuration
        animationGroup.repeatCount = .infinity
        editButton.layer.add(animationGroup, forKey: "shake")
    }

}

extension ProfileViewController: ProfileViewInput {

    func setImageFromPickerController(data: Data) {
        profileIconView.image = UIImage(data: data)
    }

    func setupTheme(theme: Theme) {
        self.theme = theme

        // mocked
        navigationController?.navigationBar.backgroundColor = theme == .day ? UIColor(hexString: "#F2F2F7") : .white
        nameLabel.textColor = theme.mainColors.profileView.textColor
        view.backgroundColor = theme.mainColors.profileView.backgroundColor
    }

    func setNameLabel(text: String) {
        nameLabel.text = text
    }

    func setDescriptionLabel(text: String) {
        descriptionLabel.text = text
    }

    func setProfileImage(with data: Data?) {
        if let data = data {
            profileIconView.image = UIImage(data: data)
        } else {
            profileIconView.image = Resources.Images.noNameImage
        }
    }

    func showCameraWasDeniedAlert(title: String) {
        let alert = UIAlertController(title: title,
        message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    func showPickerConroller(for sourceType: UIImagePickerController.SourceType) {
        if sourceType == .photoLibrary, !UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            showCameraWasDeniedAlert(title: "No permissions")
            return
        }
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = sourceType
        navigationController?.present(pickerController, animated: true)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate,
    PhotoCollectionViewControllerDelegate {

    func didPickImageFromNetwork(imageData: Data?) {
        output.setImage(data: imageData)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        output.setImage(data: (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)?.pngData())
    }
}
