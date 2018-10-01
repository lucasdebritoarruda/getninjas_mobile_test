//
//  ViewController.swift
//  getninjas_mobile_test
//
//  Created by Lucas de Brito on 27/09/2018.
//  Copyright © 2018 Lucas de Brito. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class MainScreenController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: - Properties
    let cellId = "cellId"
    var mainview = MainScreenView()
    var responseJson = JSON()
    var offersStatesArray: [String] = []

    //MARK: - View Life Cycle and setup
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        mainview.startActivityIndicator()
        getJsonData(url:"https://testemobile.getninjas.com.br/offers") { (response) in
            self.responseJson = JSON(response)
            if UserDefaultsManager.shared.readed {
                self.offersStatesArray = UserDefaultsManager.shared.offersStatesArray
            }else{
                self.offersStatesArray = self.responseJson["offers"].arrayValue.map({$0["state"].stringValue})
            }
            self.mainview.tableView.reloadData()
            print(self.responseJson["offers"])
        }
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mainview.tableView.reloadData()
        if UserDefaultsManager.shared.accepted{
            mainview.segmentedControl.setEnabled(true, forSegmentAt: 1)
        }else{
            mainview.segmentedControl.setEnabled(false, forSegmentAt: 1)
        }
    }

    func setup(){
        self.view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        mainview = MainScreenView(frame: self.view.frame)
        mainview.segmentedControl.selectedSegmentIndex = 0
        mainview.tableView.delegate = self
        mainview.tableView.dataSource = self
        mainview.changeTableAction = handleSegmentedControlChanged
        mainview.tableView.register(MainCell.self, forCellReuseIdentifier: cellId)
        self.view.addSubview(mainview)
    }
    
    func setupNavigationBar(){
        navigationItem.title = "Pedidos"
        navigationController?.navigationBar.barTintColor = UIColor(red: 3/255, green: 104/255, blue: 226/255, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white,NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 20)]
    }
    
    //MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var x = 0
        
        switch self.mainview.segmentedControl.selectedSegmentIndex {
        case 0:
            x = responseJson["offers"].arrayValue.count
        case 1:
            x = UserDefaultsManager.shared.ofertas.count
        default:
            break
        }
        return x
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! MainCell
        cell.readedView.layer.backgroundColor = setStateColor(state: offersStatesArray[indexPath.row]).cgColor
        cell.selectionStyle = .none
        
        
        switch self.mainview.segmentedControl.selectedSegmentIndex {
        case 0:
            cell.nameLabel.attributedText = setCellText(
                oferta: self.responseJson["offers"][indexPath.row]["_embedded"]["request"]["title"].stringValue,
                quem: self.responseJson["offers"][indexPath.row]["_embedded"]["request"]["_embedded"]["user"]["name"].stringValue,
                quando: self.responseJson["offers"][indexPath.row]["_embedded"]["request"]["created_at"].stringValue,
                onde: self.responseJson["offers"][indexPath.row]["_embedded"]["request"]["_embedded"]["address"]["neighborhood"].stringValue)
        case 1:
            cell.nameLabel.attributedText = setCellText(
                oferta: UserDefaultsManager.shared.ofertas[indexPath.row],
                quem: UserDefaultsManager.shared.quens[indexPath.row],
                quando: "2016-01-29T13:00:53.000+00:00",
                onde: UserDefaultsManager.shared.onde[indexPath.row])
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    //MARK: - Navigation
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.mainview.startActivityIndicator()
        self.offersStatesArray[indexPath.row] = "read"
        UserDefaultsManager.shared.readed = true
        UserDefaultsManager.shared.offersStatesArray = self.offersStatesArray
        tableView.allowsSelection = false
        getJsonData(url: self.responseJson["offers"][indexPath.row]["_links"]["self"]["href"].stringValue) { (response) in
            let offerDetailController = OfferDetailController()
            offerDetailController.offerJsonResponse = JSON(response)
            //offerDetailController.data = self.dateFormatter(date: self.responseJson["offers"][indexPath.row]["_embedded"]["request"]["created_at"].stringValue)
            let iniciaisButton = UIBarButtonItem()
            iniciaisButton.title = "Voltar"
            iniciaisButton.tintColor = .white
            self.navigationItem.backBarButtonItem = iniciaisButton
            self.mainview.stopActivityIndicator()
            self.navigationController?.pushViewController(offerDetailController, animated: true)
            tableView.allowsSelection = true
        }
    }
    
    
    //MARK: - Auxiliar functions
    func setCellText(oferta:String, quem:String, quando:String, onde:String) -> NSMutableAttributedString {
        let attributedText = NSMutableAttributedString(string: oferta + "\n", attributes:[NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 14)] )
        
        let whoImage = NSTextAttachment()
        whoImage.image = UIImage(named: "who")
        whoImage.bounds = CGRect(x: 0, y: 0, width: 12, height: 12)
        attributedText.append(NSAttributedString(attachment: whoImage))
        attributedText.append(NSAttributedString(string: " " + quem + "\n", attributes: [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 14),NSAttributedStringKey.foregroundColor:UIColor(red: 155/255, green: 161/255, blue: 171/255, alpha: 1)]))
        
        let whereImage = NSTextAttachment()
        whereImage.image = UIImage(named: "where")
        whereImage.bounds = CGRect(x: 0, y: 0, width: 12, height: 12)
        attributedText.append(NSAttributedString(attachment: whereImage))
        attributedText.append(NSAttributedString(string: onde + "\t", attributes: [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 14),NSAttributedStringKey.foregroundColor:UIColor(red: 155/255, green: 161/255, blue: 171/255, alpha: 1)]))
        
        let whenImage = NSTextAttachment()
        whenImage.image = UIImage(named: "when")
        whenImage.bounds = CGRect(x: 0, y: 0, width: 12, height: 12)
        attributedText.append(NSAttributedString(attachment: whenImage))
        attributedText.append(NSAttributedString(string: " " + dateFormatter(date: quando), attributes: [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 14),NSAttributedStringKey.foregroundColor:UIColor(red: 155/255, green: 161/255, blue: 171/255, alpha: 1)]))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attributedText.addAttributes([NSAttributedStringKey.paragraphStyle : paragraphStyle], range: NSMakeRange(0, attributedText.string.characters.count))
        
        return attributedText
    }
    
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
    
    func setStateColor(state:String) -> UIColor{
        if state == "unread"{
            return UIColor(red: 3/255, green: 104/255, blue: 226/255, alpha: 1)
        }else{
            return UIColor(white: 0.95, alpha: 1)
        }
    }
    
    func dateFormatter(date: String) -> String{
        let format = "yyyy-MM-dd'T'HH:mm:ss.SZ"
        let format2 = "MM/dd/yyyy"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let y = dateFormatter.date(from: date)!
        dateFormatter.dateFormat = format2
        return dateFormatter.string(from: y)
    }
    
    func handleSegmentedControlChanged(){
        self.mainview.tableView.reloadData()
    }
    
}

