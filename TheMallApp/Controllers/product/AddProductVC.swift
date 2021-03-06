//
//  AddProductVC.swift
//  TheMallApp
//
//  Created by M1 on 21/03/22.
//

import UIKit
import DropDown

class AddProductVC: UIViewController,UITextViewDelegate,UITextFieldDelegate{
    
    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var productPrice: UITextField!
    @IBOutlet weak var brandName: UITextField!
    @IBOutlet weak var productDescription: UITextView!
    @IBOutlet weak var discount: UITextField!
    @IBOutlet weak var offerValid: UITextField!
    @IBOutlet var viewsCollection: [UIView]!
    
    
    var drop = DropDown()
    let daysArray = ["1 day","2 days","3 days","4 days","5 days","6 days","7 days"]
    let sizeArray = ["S","M","L","XL","XXL"]
    let colorArray = ["s"]
    let imageArray = ["q"]
    var storeId = ""
    var key = ""
    var productData: NSDictionary!
    var productdata = [AnyObject]()
    var filterArray = [String]()
    var categoryId = [String]()
    var isdiscount = false
    var catIdtoSend = ""
    var productid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("c",storeId)
        offerValid.delegate = self
        productDescription.delegate = self
        productDescription.text = "Product description"
        productDescription.textColor = UIColor.gray
        for i in 0...viewsCollection.count-1{
            viewsCollection[i].layer.cornerRadius = 10
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setData()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
            if productDescription.text == "Product description"{
                productDescription.text = ""
                productDescription.textColor = UIColor.black
            }else{
                productDescription.textColor = UIColor.black
            }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if productDescription.text == ""{
            productDescription.text = "Product description"
            productDescription.textColor = UIColor.lightGray
        }else{
            productDescription.textColor = UIColor.black
        }
    }
    
    func setData(){
        if key == "Edit"{
            print(productData,"rrr")
            productName.text = productData.object(forKey: "name") as! String
            productPrice.text = "\(productData.object(forKey: "masterPrice") as! Int)"
            productDescription.text = productData.object(forKey: "description") as? String ?? ""
            brandName.text = productData.object(forKey: "brand") as? String ?? ""
            discount.text = productData.object(forKey: "discount") as? String ?? ""
            catIdtoSend = productData.object(forKey: "categoryId") as? String ?? ""
            storeId = productData.object(forKey: "store") as? String ?? ""
            productid = productData.object(forKey: "id") as? String ?? ""
            let offerDate = productData.object(forKey: "offerTime") as? String ?? ""
            let dateformater = DateFormatter()
            dateformater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let datt = dateformater.date(from: offerDate)
            dateformater.dateFormat = "yyyy-MM-dd"
            offerValid.text = dateformater.string(from: datt ?? Date())
            print(productid,"rrrr")
        }else{
            print("hello")
        }
    }
 ///
    //MARK: - BTN ACTIONS
    @IBAction func mallLogoTapped(_ sender: Any) {
        NavigateToHome.sharedd.navigate(naviagtionC: self.navigationController!)
    }
    ///
    @IBAction func backTaped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
 ///
    @IBAction func continueTapped(_ sender: Any) {
         if productName.text == ""{
            alert(message: "Please enter product name")
        }else if productPrice.text == ""{
            alert(message: "Please enter product price")
        }else if brandName.text == ""{
            alert(message: "Please enter product Brand name")
        }else if productDescription.text == ""{
            alert(message: "Please enter description")
        }
        else{
                addProduct()
        }
        
    }
    @IBAction func selectOfferDays(_ sender: UIButton) {

//                datePicker()
//        drop.dataSource = daysArray
//        drop.anchorView = offerValid
//        drop.show()
//        drop.selectionAction = { [unowned self] (index, item) in
//            offerValid.text = item
//
//        }
    }

}

///
extension AddProductVC{
    func addProduct(){
        let size = sizeA(value: "M", price: 0)
        let color = colors(name: "Gray", price: 0)
        let feature = feature(key: "1", value: "10")
        let price = Double("\(self.productPrice.text!)")
        print(self.storeId,"dfgdfsg")
//        var isDiscount = false
        if discount.text == ""{
            isdiscount = false
        }else{
            isdiscount = true
        }
        let model = AddProductModel(description: self.productDescription.text!, name: self.productName.text!, masterPrice: price, productUrl: "Nike", storeId: self.storeId, size: size, colors: color, features: feature,discount:discount.text, categoryId: catIdtoSend, brand: brandName.text!,isOnDiscount:isdiscount,offerTime: offerValid.text)
        print(model)
        print("sdnvkabvbakvbabvkabv")
        if key == "Edit"{
            ApiManager.shared.updateProducts(productId: self.productid, model: model) {[self] isSuccess in
                if isSuccess{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductImageUploadVC") as! ProductImageUploadVC
                    vc.productId = productid
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
//                    self.alert(message: ApiManager.shared.msg)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductImageUploadVC") as! ProductImageUploadVC
                    vc.productId = productid
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }else{
            ApiManager.shared.addProduct(model:model) { isSuccess in
                if isSuccess{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductImageUploadVC") as! ProductImageUploadVC
                    vc.productId = ApiManager.shared.dataDict.object(forKey: "_id") as! String
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    self.alert(message: ApiManager.shared.msg)
                }
            }
        }
      
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == offerValid{
            datePicker(textField: offerValid)
        }
        
//        if textField == offerValid{
//            if isdiscount == true{
//            }else{
//                self.alert(message: "Please enter discount first then select offer time period")
//            }
//        }
    }
   
}


extension AddProductVC{
        
    func datePicker(textField: UITextField){
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        textField.inputView = datePicker
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done))
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([cancel,flexibleSpace,done], animated: true)
        offerValid.inputAccessoryView = toolbar
    }
    @objc func done(){
        offerValid.resignFirstResponder()
        if let datepicker = offerValid.inputView as? UIDatePicker{
            datepicker.datePickerMode = .date
            let dateformatter  = DateFormatter()
            dateformatter.dateFormat = "yyyy-MM-dd"
            offerValid.text = dateformatter.string(from: datepicker.date)
        }
    }
    @objc func cancel(){
        offerValid.resignFirstResponder()
    }
}
