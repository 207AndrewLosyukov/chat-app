//
//  PhotoCollectionViewController.swift
//  Messenger
//
//  Created by Андрей Лосюков on 26.04.2023.
//

import UIKit

protocol PhotoCollectionViewControllerDelegate: AnyObject {

    func didPickImageFromNetwork(imageData: Data?)
}

class PhotoCollectionViewController: UIViewController {

    enum Constants {
        static let lowerBound = 0.8
        static let upperBound = 2.0
        static let spacing = 10.0
    }

    private var currentScale = 1.0

    private let pinchGesture = UIPinchGestureRecognizer()

    private var output: PhotoCollectionViewOutputProtocol

    private var theme: Theme?

    private let countInRow: CGFloat = 3

    weak var delegate: PhotoCollectionViewControllerDelegate?

    var activityIndicatorView = UIActivityIndicatorView()

    private lazy var titleLabel: UILabel = {
        let title = UILabel()
        view.addSubview(title)
        title.text = "Select photo"
        title.textAlignment = .center
        title.textColor = .black
        title.font = .systemFont(ofSize: 17.0, weight: .semibold)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()

    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PhotoCollectionCell.self,
            forCellWithReuseIdentifier: PhotoCollectionCell.Constants.reuseIdentifier)
        return collectionView
    }()

    init(output: PhotoCollectionViewOutputProtocol) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        navigationItem.backButtonTitle = "Cancel"
        view.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.addSubview(activityIndicatorView)
        activityIndicatorView.color = .gray
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.center = view.center
        setupConstraints()
        setupTheme()
        setupTitle()
        setupCancelButton()
        output.loadImageList()
        pinchGesture.addTarget(self, action: #selector(pinchHandler))
        collectionView.addGestureRecognizer(pinchGesture)
    }

    private func setupTitle() {
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 17),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
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
            cancel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 17),
            cancel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16)
        ])
        cancel.addTarget(
            self,
            action: #selector(close),
            for: .touchUpInside
        )
    }

    @objc private func close() {
        dismiss(animated: true)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupTheme() {
        collectionView.backgroundColor = (theme ?? .day).mainColors.backgroundColor
    }

    @objc private func pinchHandler() {
        if pinchGesture.state == .changed {
            var newScale = currentScale * pinchGesture.scale
            if newScale < Constants.lowerBound {
                newScale = Constants.lowerBound
            }
            if newScale > Constants.upperBound {
                newScale = Constants.upperBound
            }
            currentScale = newScale
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
}

extension PhotoCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return output.cellsCount
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PhotoCollectionCell.Constants.reuseIdentifier,
            for: indexPath) as? PhotoCollectionCell else {
            return UICollectionViewCell()
        }
        output.configure(cell: cell, index: indexPath.item)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        output.didImagePicked(at: indexPath.item)
        dismiss(animated: true, completion: nil)
    }
}

extension PhotoCollectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let scaledWidth = 50 * currentScale
        let columnsCount = Int(floor(320 / scaledWidth))
        output.didChangedColumnsCount(with: columnsCount)
        let totalSpacingSize = Constants.spacing * (CGFloat(columnsCount) - 1)
        let fittedWidth = (320 - totalSpacingSize) / CGFloat(columnsCount)
        return CGSize(width: fittedWidth, height: fittedWidth)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: Constants.spacing, left: Constants.spacing, bottom: 0, right: Constants.spacing)
    }
}

extension PhotoCollectionViewController: PhotoCollectionViewInputProtocol {
    func setupTheme(theme: Theme) {
    }

    func reloadData() {
        collectionView.reloadData()
    }

    func animatingIndicator(enabled: Bool) {
        if enabled {
            activityIndicatorView.startAnimating()
        } else {
            activityIndicatorView.stopAnimating()
        }
    }

    func reloadItem(at index: Int) {
        collectionView.reloadItems(at: [.init(item: index, section: 0)])
    }

    func showErrorAlert(_ message: String) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self?.present(alert, animated: true, completion: nil)
        }
    }
}
