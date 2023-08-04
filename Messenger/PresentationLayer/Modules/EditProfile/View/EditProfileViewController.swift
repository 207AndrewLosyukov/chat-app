//
//  EditProfileViewController.swift
//  Messenger
//
//  Created by Андрей Лосюков on 04.05.2023.
//

import UIKit
import AVFoundation
import Combine

enum EditProfileControllerState {
    case didEditTapped
    case saving
}

class EditProfileViewController: UIViewController {

    private var output: EditProfileViewOutput

    private var theme: Theme?

    private var editingConstraints: [NSLayoutConstraint] = []

    private var activityIndicator = UIActivityIndicatorView(style: .medium)

    var photoCollectionModuleOutput: ModuleAvailableToOpenPhotoCollection?

    private lazy var rightButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.addTarget(
            self,
            action: #selector(rightButtonHandler),
            for: .touchUpInside
        )
        return button
    }()
    private lazy var titleLabel: UILabel = {
        let title = UILabel()
        view.addSubview(title)
        title.text = "Edit profile"
        title.textAlignment = .center
        title.textColor = .black
        title.font = .systemFont(ofSize: 17.0, weight: .semibold)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
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
        return profileIconView
    }()

    private lazy var editingView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private lazy var firstWhiteView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var secondWhiteView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var nameTextView: UITextField = {
        let nameTextField = UITextField()
        nameTextField.text = "Stephen Johnson"
        nameTextField.font = UIFont.systemFont(ofSize: 17)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        return nameTextField
    }()

    lazy var bioTextView: UITextField = {
        let bioTextField = UITextField()
        bioTextField.text = "UX/UI designer, web designer Moscow, Russia"
        bioTextField.font = UIFont.systemFont(ofSize: 17)
        bioTextField.translatesAutoresizingMaskIntoConstraints = false
        bioTextField.layer.addBorder(rectEdge: .bottom, color: .red, thickness: 10)
        return bioTextField
    }()

    private lazy var nameEditingLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var bioEditingLabel: UILabel = {
        let label = UILabel()
        label.text = "Bio"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init(output: EditProfileViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
        transitioningDelegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        output.loadTheme()
        view.backgroundColor = UIColor(hexString: "#F2F2F7")
        activityIndicator.isHidden = true
        output.loadProfileImage()
        output.loadNameTextView()
        output.loadBioTextView()
        setupActivityIndicator()
        setupSubviews()
        setupEditingConstraints()
        setupConstraints()
        setupSeparators()
        setupTitle()
        setupRightButton()
        setupCancelButton()
        overrideUserInterfaceStyle = .light
    }

    private func setupCancelButton() {
        let cancel = UIButton()
        cancel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cancel)
        cancel.setTitle("Cancel", for: .normal)
        cancel.setTitleColor(.systemBlue, for: .normal)
        cancel.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        NSLayoutConstraint.activate([
            cancel.heightAnchor.constraint(equalToConstant: 20),
            cancel.topAnchor.constraint(equalTo: view.topAnchor, constant: 17),
            cancel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16)
        ])
        cancel.addTarget(
            self,
            action: #selector(close),
            for: .touchUpInside
        )
    }

    @objc func close() {
        dismiss(animated: true)
    }

    private func setupRightButton() {
        NSLayoutConstraint.activate([
            rightButton.heightAnchor.constraint(equalToConstant: 20),
            rightButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 17),
            rightButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func setupTitle() {
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 17),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    override func viewWillAppear(_ animated: Bool) {
        output.loadTheme()
    }

    func setupSubviews() {
        view.addSubview(profileIconView)
        view.addSubview(addPhotoButton)
        view.addSubview(firstWhiteView)
        view.addSubview(secondWhiteView)
        view.addSubview(rightButton)
        firstWhiteView.addSubview(nameEditingLabel)
        firstWhiteView.addSubview(nameTextView)
        secondWhiteView.addSubview(bioTextView)
        secondWhiteView.addSubview(bioEditingLabel)
    }
    func setupConstraints() {
        setupProfileIconViewConstraints()
        setupAddPhotoButtonConstraints()
    }

    func setupActivityIndicator() {
        activityIndicator.isUserInteractionEnabled = false
        activityIndicator.frame = CGRect(x: 6, y: -5, width: 30, height: 30)
        activityIndicator.isHidden = true
        rightButton.setImage(.none, for: .normal)
        rightButton.addSubview(activityIndicator)
    }
    func setupSeparators() {
        let topSeparator = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 0.5))
        topSeparator.backgroundColor = .systemGray
        firstWhiteView.addSubview(topSeparator)
        let middleSeparator = UIView(frame: CGRect(x: 16, y: 0, width: view.frame.width, height: 0.5))
        middleSeparator.backgroundColor = .systemGray
        secondWhiteView.addSubview(middleSeparator)
        let bottomSeparator = UIView(frame: CGRect(x: 0, y: 44, width: view.frame.width, height: 0.5))
        bottomSeparator.backgroundColor = .systemGray
        secondWhiteView.addSubview(bottomSeparator)
    }
    func setupProfileIconViewConstraints() {
        NSLayoutConstraint.activate([
            profileIconView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileIconView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 35),
            profileIconView.heightAnchor.constraint(equalToConstant: 150),
            profileIconView.widthAnchor.constraint(equalToConstant: 150)
        ])
    }

    func setupAddPhotoButtonConstraints() {
        NSLayoutConstraint.activate([
            addPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addPhotoButton.topAnchor.constraint(equalTo: profileIconView.bottomAnchor, constant: 24),
            addPhotoButton.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
    func setupEditingConstraints() {
        NSLayoutConstraint.activate([
            firstWhiteView.topAnchor.constraint(equalTo: addPhotoButton.bottomAnchor, constant: 24),
            firstWhiteView.heightAnchor.constraint(equalToConstant: 44),
            firstWhiteView.widthAnchor.constraint(equalTo: view.widthAnchor),
            secondWhiteView.topAnchor.constraint(equalTo: firstWhiteView.bottomAnchor),
            secondWhiteView.heightAnchor.constraint(equalToConstant: 44),
            secondWhiteView.widthAnchor.constraint(equalTo: view.widthAnchor),
            nameEditingLabel.leadingAnchor.constraint(equalTo: firstWhiteView.leadingAnchor, constant: 16),
            nameEditingLabel.centerYAnchor.constraint(equalTo: firstWhiteView.centerYAnchor),
            nameEditingLabel.widthAnchor.constraint(equalToConstant: 96),
            nameTextView.leadingAnchor.constraint(equalTo: nameEditingLabel.trailingAnchor, constant: 8),
            nameTextView.topAnchor.constraint(equalTo: firstWhiteView.topAnchor, constant: 11),
            nameTextView.widthAnchor.constraint(equalToConstant: 234),
            nameTextView.heightAnchor.constraint(equalToConstant: 22),
            bioEditingLabel.leadingAnchor.constraint(equalTo: secondWhiteView.leadingAnchor, constant: 16),
            bioEditingLabel.centerYAnchor.constraint(equalTo: secondWhiteView.centerYAnchor),
            bioEditingLabel.widthAnchor.constraint(equalToConstant: 96),
            bioTextView.leadingAnchor.constraint(equalTo: bioEditingLabel.trailingAnchor, constant: 8),
            bioTextView.topAnchor.constraint(equalTo: secondWhiteView.topAnchor, constant: 11),
            bioTextView.heightAnchor.constraint(equalToConstant: 22),
            bioTextView.widthAnchor.constraint(equalToConstant: 234)
        ])
    }

    func setProfileIconView(image: UIImage) {
        profileIconView.image = image
    }

    @objc func rightButtonHandler() {
        output.changeState()
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

extension EditProfileViewController: EditProfileViewInput {

    func setImageFromPickerController(data: Data) {
        profileIconView.image = UIImage(data: data)
    }

    func setupTheme(theme: Theme) {
        self.theme = theme
//        view.backgroundColor = theme.mainColors.backgroundColor
    }

    func setBioTextView(text: String) {
        bioTextView.text = text
    }

    func setNameTextView(text: String) {
        nameTextView.text = text
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
        print(pickerController)
        present(pickerController, animated: true)
    }

    func setState(state: EditProfileControllerState) {
        switch state {
        case .didEditTapped:
            setupDidEditTappedState()
        case .saving:
            setupSavingState()
        }
    }
}

extension EditProfileViewController {

    func setupDidEditTappedState() {
        view.backgroundColor = UIColor(hexString: "#F2F2F7")
        title = "Edit Profile"
        activityIndicator.stopAnimating()
        nameTextView.isUserInteractionEnabled = true
        bioTextView.isUserInteractionEnabled = true
        addPhotoButton.isUserInteractionEnabled = true
        rightButton.isUserInteractionEnabled = true
        rightButton.setTitle("Save", for: .normal)
    }

    func setupSavingState() {
        nameTextView.isUserInteractionEnabled = false
        bioTextView.isUserInteractionEnabled = false
        addPhotoButton.isUserInteractionEnabled = false
        rightButton.isUserInteractionEnabled = false
        rightButton.setTitle("", for: .normal)
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        var data: Data?
        if profileIconView.image == Resources.Images.noNameImage || profileIconView.image == nil {
            data = nil
        } else {
            data = profileIconView.image?.pngData()
        }
        output.saveProfile(with: ProfileModel(name: nameTextView.text,
        description: bioTextView.text, imageData: data))
    }
}

extension EditProfileViewController:
    UIImagePickerControllerDelegate & UINavigationControllerDelegate, PhotoCollectionViewControllerDelegate {

    func didPickImageFromNetwork(imageData: Data?) {
        output.setImage(data: imageData)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        output.setImage(data: (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)?.pngData())
    }
}
