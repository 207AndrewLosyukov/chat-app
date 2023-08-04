//
//  PhotoCollectionViewOutputProtocol.swift
//  Messenger
//
//  Created by Андрей Лосюков on 11.05.2023.
//

import Foundation

protocol PhotoCollectionViewOutputProtocol: AnyObject {

    var cellsCount: Int {
        get
    }

    func fetchImage(at index: Int, for model: PhotoCollectionCellModel)

    func didChangedColumnsCount(with columnsCount: Int)

    func configure(cell: PhotoCollectionCell, index: Int)

    func update(with avatars: [PhotoCollectionCellModel])

    func updateCell(at index: Int, with model: PhotoCollectionCellModel)

    func loadImageList()

    func didImagePicked(at index: Int)
}
