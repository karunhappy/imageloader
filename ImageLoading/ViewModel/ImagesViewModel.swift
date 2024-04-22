//
//  ImagesViewModel.swift
//  ImageLoading
//
//  Created by Karun Aggarwal on 22/04/24.
//

import UIKit
import Combine

protocol ImagesDelegate {
    func success()
    func fail()
}

class ImagesViewModel: NSObject {
    private var cancellables = Set<AnyCancellable>()
    private var adapterList = [UICollectionViewCell: APIManager]()
    
    var imageDataObjects = [ImageModel]()
    var delegate: ImagesDelegate?
    
    func requestImages() {
        APIManager().request()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    self.delegate?.fail()
                }
            } receiveValue: { dataModel in
                self.imageDataObjects = dataModel
                self.delegate?.success()
            }
            .store(in: &cancellables)
    }
    
    func getReusableAdapter(forReusableCell cell: UICollectionViewCell) -> APIManager {
        if let adapter = adapterList[cell] {
            return adapter
        } else {
            let adapter = APIManager()
            adapterList[cell] = adapter
            return adapter
        }
    }
}
