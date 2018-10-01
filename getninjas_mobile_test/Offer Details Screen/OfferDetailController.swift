//
//  OfferDetailController.swift
//  getninjas_mobile_test
//
//  Created by Lucas de Brito on 28/09/2018.
//  Copyright © 2018 Lucas de Brito. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON
import Alamofire

class OfferDetailController: UIViewController, MKMapViewDelegate {
    
    //MARK: - Properties
    var offerDetailView = OfferDetailView()
    var offerJsonResponse = JSON()
    var accepted = false
    var phoneNumber = ""
    var email = ""
    var data = ""
    var ofertas = [String]()
    var quens = [String]()
    var quandos = [String]()
    var onde = [String]()
    
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        setupView()
        setLocationOnTheMap()
        setupNavigationbar()
        showOfferInfo()
        setupArrays()
    }
    
    //MARK: - View Setup
    func setupView(){
        self.view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        let vf = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 750)
        offerDetailView = OfferDetailView(frame: vf)
        offerDetailView.mapView.delegate = self
        offerDetailView.acceptOfferAction = handleAcceptOffer
        offerDetailView.denyOfferAction = handleDenyOffer
        let sv = UIScrollView(frame: self.view.frame)
        self.view.addSubview(sv)
        sv.addSubview(offerDetailView)
        sv.contentSize.height = 755
    }
    
    func setupArrays(){
        if UserDefaultsManager.shared.accepted{
            self.ofertas = UserDefaultsManager.shared.ofertas
            self.quens = UserDefaultsManager.shared.quens
            self.onde = UserDefaultsManager.shared.onde
        }
    }
    
    func setupNavigationbar(){
        navigationItem.title = offerJsonResponse["title"].stringValue.capitalized
    }
    
    func setLocationOnTheMap(){
        let lat = offerJsonResponse["_embedded"]["address"]["geolocation"]["latitude"].stringValue
        let latitude = CLLocationDegrees(lat)
        let lon = offerJsonResponse["_embedded"]["address"]["geolocation"]["longitude"].stringValue
        let longitude = CLLocationDegrees(lon)
        let location = CLLocationCoordinate2DMake(latitude!, longitude!)
        let region = MKCoordinateRegionMakeWithDistance(location, 500, 500)
        let pin = MKPointAnnotation()
        pin.coordinate.latitude = latitude!
        pin.coordinate.longitude = longitude!
        pin.title = offerJsonResponse["title"].stringValue
        offerDetailView.mapView.region = region
        offerDetailView.mapView.addAnnotation(pin)
    }
    
    func showOfferInfo(){
        offerDetailView.offerNameLabel.text = offerJsonResponse["title"].stringValue.capitalized
        let attributedText = NSMutableAttributedString()
        let whoImage = NSTextAttachment()
        whoImage.image = UIImage(named: "blueWho")
        whoImage.bounds = CGRect(x: 0, y: -2, width: 16, height: 16)
        attributedText.append(NSAttributedString(attachment: whoImage))
        attributedText.append(NSAttributedString(string: "  " + offerJsonResponse["_embedded"]["user"]["name"].stringValue, attributes: [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 14),NSAttributedStringKey.foregroundColor:UIColor.black]))
        offerDetailView.quemLabel.attributedText = attributedText
        
        let attributedText2 = NSMutableAttributedString()
        let whereImage = NSTextAttachment()
        whereImage.image = UIImage(named: "blueWhere")
        whereImage.bounds = CGRect(x: 0, y: -2, width: 16, height: 16)
        attributedText2.append(NSAttributedString(attachment: whereImage))
        attributedText2.append(NSAttributedString(string: "  " + offerJsonResponse["_embedded"]["address"]["neighborhood"].stringValue, attributes: [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 14),NSAttributedStringKey.foregroundColor:UIColor.black]))
        offerDetailView.ondeLabel.attributedText = attributedText2
        
        fullFillOfferInfoLabel()
        fullFillOfferContactLabel()
    }
    
    func fullFillOfferInfoLabel(){
        
        let attributedText = NSMutableAttributedString()
        
        for rawInfo in offerJsonResponse["_embedded"]["info"].arrayValue{
            let info = JSON(rawInfo)
            let infoImage = NSTextAttachment()
            infoImage.image = UIImage(named: "blueInfo")
            infoImage.bounds = CGRect(x: 0, y: -2, width: 16, height: 16)
            attributedText.append(NSAttributedString(attachment: infoImage))
            attributedText.append(NSAttributedString(string: "  " + info["label"].stringValue + "\n", attributes: [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 14),NSAttributedStringKey.foregroundColor:UIColor.black]))
            
            switch info["value"].type{
            case .array:
                var text = ""
                for value in info["value"].arrayValue{
                    text.append(value.stringValue + ", ")
                }
                let actualText = text.dropLast()
                attributedText.append(NSAttributedString(string: "\t" + actualText + "\n", attributes: [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 12),NSAttributedStringKey.foregroundColor:UIColor.gray]))
            default:
                attributedText.append(NSAttributedString(string: "\t" + info["value"].stringValue + "\n", attributes: [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 12),NSAttributedStringKey.foregroundColor:UIColor.gray]))
            }
            
        }
        offerDetailView.offerInfoLabel.numberOfLines = offerJsonResponse["_embedded"]["info"].arrayValue.count * 2
        offerDetailView.offerInfoLabel.attributedText = attributedText
    }
    
    func fullFillOfferContactLabel(){
        let attributedText = NSMutableAttributedString()
        let mailImage = NSTextAttachment()
        mailImage.image = UIImage(named: "bluePhone")
        mailImage.bounds = CGRect(x: 0, y: -4, width: 16, height: 16)
        attributedText.append(NSAttributedString(attachment: mailImage))
        attributedText.append(NSAttributedString(string: "  " + offerJsonResponse["_embedded"]["user"]["email"].stringValue + "\n", attributes: [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 14),NSAttributedStringKey.foregroundColor:UIColor.black]))
        
        let phoneImage = NSTextAttachment()
        phoneImage.image = UIImage(named: "blueMail")
        phoneImage.bounds = CGRect(x: 0, y: -4, width: 16, height: 16)
        attributedText.append(NSAttributedString(attachment: phoneImage))
        attributedText.append(NSAttributedString(string: "  " + offerJsonResponse["_embedded"]["user"]["_embedded"]["phones"][0]["number"].stringValue + "\n", attributes: [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 14),NSAttributedStringKey.foregroundColor:UIColor.black]))
        offerDetailView.contactLabel.attributedText = attributedText
    }
    
    //MARK: - Actions
    func handleAcceptOffer(){
        if accepted{
           
            guard let url = URL(string: "telprompt://\(self.phoneNumber)") else {
                return
            }
            
            UIApplication.shared.open(url)
            self.accepted = true
            
        }else{
            getJsonData(url: offerJsonResponse["_links"]["accept"]["href"].stringValue) { (response) in
                self.offerJsonResponse = JSON(response)
                self.offerDetailView.contactArea.backgroundColor = .green
                self.offerDetailView.contactArea.layer.borderColor = UIColor.green.cgColor
                let attributedText = NSMutableAttributedString()
                let mailImage = NSTextAttachment()
                mailImage.image = UIImage(named: "blueMail")
                mailImage.bounds = CGRect(x: 0, y: -4, width: 16, height: 16)
                attributedText.append(NSAttributedString(attachment: mailImage))
                attributedText.append(NSAttributedString(string: "  " + self.offerJsonResponse["_embedded"]["user"]["email"].stringValue + "\n", attributes: [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 14),NSAttributedStringKey.foregroundColor:UIColor.black]))
                
                let phoneImage = NSTextAttachment()
                phoneImage.image = UIImage(named: "bluePhone")
                phoneImage.bounds = CGRect(x: 0, y: -4, width: 16, height: 16)
                attributedText.append(NSAttributedString(attachment: phoneImage))
                attributedText.append(NSAttributedString(string: "  " + self.offerJsonResponse["_embedded"]["user"]["_embedded"]["phones"][0]["number"].stringValue + "\n", attributes: [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 14),NSAttributedStringKey.foregroundColor:UIColor.black]))
                self.offerDetailView.contactLabel.attributedText = attributedText
                self.offerDetailView.acceptButton.backgroundColor = UIColor.green
                self.offerDetailView.acceptButton.layer.borderColor = UIColor.green.cgColor
                self.offerDetailView.denyButton.backgroundColor = UIColor.green
                self.offerDetailView.denyButton.layer.borderColor = UIColor.green.cgColor
                self.phoneNumber = self.offerJsonResponse["_embedded"]["user"]["_embedded"]["phones"][0]["number"].stringValue
                self.email = self.offerJsonResponse["_embedded"]["user"]["email"].stringValue
                self.accepted = true
            }
            self.offerDetailView.denyButton.titleLabel?.text = "Email"
            self.offerDetailView.acceptButton.titleLabel?.text = "Ligar"
            self.offerDetailView.acceptButton.isEnabled = false
            self.offerDetailView.denyButton.isEnabled = false
            UserDefaultsManager.shared.accepted = true
            self.ofertas.append(offerJsonResponse["title"].stringValue)
            self.quens.append(offerJsonResponse["_embedded"]["user"]["name"].stringValue)
            //self.quandos.append(self.data)
            self.onde.append(offerJsonResponse["_embedded"]["request"]["_embedded"]["address"]["neighborhood"].stringValue)
            UserDefaultsManager.shared.ofertas = self.ofertas
            UserDefaultsManager.shared.quens = self.quens
            UserDefaultsManager.shared.quando = self.quandos
            UserDefaultsManager.shared.onde = self.onde
        }
    }
    
    func handleDenyOffer(){
        if accepted{
            guard let url = URL(string: "mailto://\(self.email)") else {
                return
            }
            UIApplication.shared.open(url)
        }else{
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    //MARK: - Auxiliar functions
    func getJsonData(url: String, completion:@escaping (Any) -> Void){
        Alamofire.request(url).responseJSON { (response) in
            guard response.result.isSuccess,
                let value = response.result.value else {
                    print("Error while fetching tags: \(String(describing: response.result.error))")
                    return
            }
            completion(value)
        }
    }
}
