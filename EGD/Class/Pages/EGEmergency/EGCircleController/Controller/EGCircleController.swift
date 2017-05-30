//
//  EGCircleController.swift
//  EGD
//
//  Created by jieku on 2017/5/30.
//
//

import UIKit

class EGCircleController: UIViewController {
    
    var picURL :String?
    var imageShow :UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        imageShow = UIImageView.init()
        imageShow?.isUserInteractionEnabled = true
        imageShow?.image = UIImage(named:(picURL)!)
     
        let photoView = EGPhotoPreviewer()
        photoView.preview(fromImageView: imageShow!, container: self.view)
        
    }
   
}
