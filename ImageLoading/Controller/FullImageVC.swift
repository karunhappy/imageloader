//
//  FullImageVC.swift
//  ImageLoading
//
//  Created by Karun Aggarwal on 22/04/24.
//

import UIKit

class FullImageVC: UIViewController {
    /// IBOutlets
    @IBOutlet weak var imageviewFull: UIImageView!
    
    /// Properties
    var imagemodel: ImageModel?
    
    /// Intialise Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        let adapter = APIManager()
        adapter.configure(from: imagemodel?.thumbnail.fullImage ?? "") { image in
            if let image = image {
                self.imageviewFull.image = image
            } else {
                self.imageviewFull.image = UIImage(systemName: "photo")
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
