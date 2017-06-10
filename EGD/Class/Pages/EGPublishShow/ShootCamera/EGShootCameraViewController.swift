//
//  EGShootCameraViewController.swift
//  EGD
//
//  Created by jieku on 2017/6/10.
//
//

import UIKit

class EGShootCameraViewController: UIViewController, EGCameraViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        let cameraView = EGCameraView.init(frame: UIScreen.main.bounds, CameraPositon: .back)
        cameraView.delegate = self
        view.addSubview(cameraView)
    }
}

extension EGShootCameraViewController {
    
    func takePhotoUseCameraAction(takePhotoFinishImage: UIImage){
        
    }
    
    func clickDissmiss() {
        dismiss(animated: true, completion: nil)
    }
}
