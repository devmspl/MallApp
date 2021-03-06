//
//  ImageUploadVC.swift
//  TheMallApp
//
//  Created by Macbook on 01/03/22.
//

import UIKit
import AKSideMenu

class ImageUploadVC: BaseClass {

    @IBOutlet weak var backTapped: UIButton!
    @IBOutlet weak var logoImage: UIImageView!
    var key = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backTaped(_ sender: Any) {
        if key == ""{
            self.navigationController?.popViewController(animated: true)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func continueTapped(_ sender: Any) {
        ApiManager.shared.uploadStoreImage(image: self.logoImage.image!, type: "logo",
                    progressCompletion: { [weak self] percent in
                       guard let _ = self else {
                         return
                       }
                       print("Status: \(percent)")
                      if percent == 1.0{
                          let vc = self?.storyboard?.instantiateViewController(withIdentifier: "StoreVC") as! StoreVC
                          vc.key = "My"
                          let navigationController = UINavigationController.init(rootViewController: vc)
                          let leftMenuViewController = self?.storyboard?.instantiateViewController(withIdentifier: "SideMenu") as! SideMenu
                          let rightMenuViewController = self?.storyboard?.instantiateViewController(withIdentifier: "SideMenu") as! SideMenu
                          let sideMenuViewController: AKSideMenu = AKSideMenu(contentViewController: navigationController, leftMenuViewController: leftMenuViewController, rightMenuViewController: rightMenuViewController)
                          navigationController.isNavigationBarHidden = true
                          self?.navigationController?.pushViewController(sideMenuViewController, animated: true)                       }
                     },
                     completion: { [weak self] result in
                       guard let _ = self else {
                         return
                       }
                   })
        
       
    }
    
    @IBAction func logo(_ sender: Any) {
        openCameraAndPhotos(isEditImage: true) { [self] image, string in
            self.logoImage.image = image
        } failure: {Error in
            print(Error)
        }

        
    }
    
   
}
