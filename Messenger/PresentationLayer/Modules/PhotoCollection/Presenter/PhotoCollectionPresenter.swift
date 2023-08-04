//
//  PhotoCollectionPresenter.swift
//  Messenger
//
//  Created by Андрей Лосюков on 11.05.2023.
//

import UIKit

final class PhotoCollectionPresenter {

    weak var viewInput: PhotoCollectionViewInputProtocol?

    private var cellsModels: [PhotoCollectionCellModel] = []

    private var countOfInfected = 0

    private var columnsCount = 6

    var delegate: PhotoCollectionViewControllerDelegate?

    private let imageLoaderService: ImageLoaderServiceProtocol?

    private let themeService: GetThemeServiceProtocol?

    init(serviceAssembly: PhotoCollectionServiceAssembly) {
        self.imageLoaderService = serviceAssembly.imageLoaderService
        self.themeService = serviceAssembly.themeService
    }
}

extension PhotoCollectionPresenter: PhotoCollectionViewOutputProtocol {

    var cellsCount: Int {
        cellsModels.count
    }

    func configure(cell: PhotoCollectionCell, index: Int) {
        let imageModel = cellsModels[index]
        cell.configure(with: imageModel)
        if imageModel.image == nil && !imageModel.isFetching {
            fetchImage(at: index, for: imageModel)
        }
    }

    func fetchImage(at index: Int, for model: PhotoCollectionCellModel) {
        var copyModel = model
        copyModel.isFetching = true
        cellsModels[index] = copyModel
        imageLoaderService?.loadImageByURL(url: model.url) { [weak self] (result) in
            switch result {
            case .success(let imageData):
                guard let image = UIImage(data: imageData) else {
                    return
                }
                copyModel.isFetching = false
                copyModel.image = image
                self?.updateCell(at: index, with: copyModel)
            case .failure(let error):
                self?.viewInput?.showErrorAlert(error.localizedDescription)
            }
        }
    }

    func loadImageList() {
        viewInput?.animatingIndicator(enabled: true)
        imageLoaderService?.loadImageListByAPI(handler: { [weak self] (result) in
            DispatchQueue.main.async {
                self?.viewInput?.animatingIndicator(enabled: false)
            }
            print(result)
            switch result {
            case .success(let imageLinkList):
                let cellsModels = imageLinkList.map {
                    PhotoCollectionCellModel(image: nil, url: $0)
                }
                self?.update(with: cellsModels)
            case .failure(let error):
                self?.viewInput?.showErrorAlert(error.localizedDescription)
            }
        })
    }

    func updateCell(at index: Int, with model: PhotoCollectionCellModel) {
        DispatchQueue.main.async { [weak self] in
            self?.cellsModels[index] = model
            self?.viewInput?.reloadItem(at: index)
        }
    }

    func update(with models: [PhotoCollectionCellModel]) {
        DispatchQueue.main.async { [weak self] in
            self?.cellsModels = models
            self?.viewInput?.reloadData()
        }
    }

    func didChangedColumnsCount(with columnsCount: Int) {
        self.columnsCount = columnsCount
    }

    func didImagePicked(at index: Int) {
        let imageModel = cellsModels[index]
        guard let image = imageModel.image else {
            return
        }
        delegate?.didPickImageFromNetwork(imageData: image.pngData())
    }
}
