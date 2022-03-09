//
//  ViewController.swift
//  PhotoPickerDemo
//
//  Created by Pablo De La Cruz on 3/8/22.
//

import UIKit
import Photos

class ViewController: UIViewController {

    @IBOutlet weak var imagineView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        photoAuth()
    }

    func photoAuth(){
        PHPhotoLibrary.requestAuthorization { Status in
            switch Status {
            case .notDetermined:
                print("Status not determined")
            case .restricted:
                print("Status restricted")

            case .denied:
                print("Status denied")

            case .authorized:
                print("Status authorized")
                DispatchQueue.main.async {
                    self.imagineView.image = self.loadImg()
                }

            case .limited:
                print("Status limited")
            default:
                print("Status Default")
            }
        }
    }

    func loadImg() -> UIImage? {
        let manager = PHImageManager.default()
        let fetchResult : PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions())
        
        var img : UIImage? = nil
        
        manager.requestImage(for: fetchResult.object(at: 1), targetSize: CGSize(width: 250, height: 200), contentMode: .aspectFill, options: reqOptions()) { img1, err in
            guard let im = img1 else {
                return
            }
            img = im
            }
        return img

    }
    
    func fetchOptions() -> PHFetchOptions {
        let fop = PHFetchOptions()
        fop.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        return fop
    }
    
    func reqOptions() -> PHImageRequestOptions {
        let reqOptions = PHImageRequestOptions()
        reqOptions.isSynchronous = true
        reqOptions.deliveryMode = .highQualityFormat
        return reqOptions
    }
}

