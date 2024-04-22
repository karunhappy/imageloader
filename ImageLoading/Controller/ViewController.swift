//
//  ViewController.swift
//  ImageLoading
//
//  Created by Karun Aggarwal on 22/04/24.
//

import UIKit

enum MySection: Int {
    case items
}

class ViewController: UIViewController {
    /// IBOutlets
    @IBOutlet weak var collectionview: UICollectionView!
    
    /// Properties
    private var identifier = "ImageCollectionCell"
    private lazy var dataSource = makeDataSource()
    
    typealias collectionSource = UICollectionViewDiffableDataSource<MySection, ImageModel>
    
    private var viewmodel = ImagesViewModel()
    
    /// Intialise Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        requestImages()
        setupCollection()
    }

    func requestImages() {
        viewmodel.delegate = self
        viewmodel.requestImages()
    }

}
extension ViewController {
    func setupCollection() {
        let nib = UINib(nibName: identifier, bundle: nil)
        collectionview.register(nib, forCellWithReuseIdentifier: identifier)
        collectionview.dataSource = dataSource
        collectionview.delegate = self
        applySnapshot()
    }
    
    func makeDataSource() -> collectionSource {
        return collectionSource(collectionView: collectionview) { collectionView, indexPath, imageModel in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.identifier, for: indexPath) as! ImageCollectionCell
            
            let adapter = self.viewmodel.getReusableAdapter(forReusableCell: cell)
            cell.imageview.image = nil
            cell.startIndicator()
            
            adapter.configure(from: imageModel.thumbnail.image) { image in
                cell.stopIndicator()
                if let image = image {
                    cell.imageview.image = image
                } else {
                    cell.imageview.image = UIImage(systemName: "photo")
                }
            }
            return cell
        }
    }
    
    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<MySection, ImageModel>()
        snapshot.appendSections([.items])
        snapshot.appendItems(self.viewmodel.imageDataObjects, toSection: .items)
        dataSource.apply(snapshot)
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = (self.collectionview.bounds.width / 3) - 5
        return CGSize(width: bounds, height: bounds)
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FullImageVC") as! FullImageVC
        vc.imagemodel = self.viewmodel.imageDataObjects[indexPath.row]
        show(vc, sender: nil)
    }
}

extension ViewController: ImagesDelegate {
    func success() {
        applySnapshot()
    }
    
    func fail() {
        applySnapshot()
    }
}
