//
//  MainScreenView.swift
//  getninjas_mobile_test
//
//  Created by Lucas de Brito on 27/09/2018.
//  Copyright © 2018 Lucas de Brito. All rights reserved.
//

import UIKit

class MainScreenView: UIView {
    
    //MARK: - Properties
    var changeTableAction: (() -> Void)?
    
    //MARK: - View Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View components
    let segmentedControl:UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Disponíveis","Aceitos"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.addTarget(self, action: #selector(changeTable), for: .valueChanged)
        return sc
    }()
    
    var tableView: UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableview.backgroundView = view
        tableview.separatorStyle = .none
        return tableview
    }()
    
    var activityIN = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    //MARK: - View setup and constraints
    func setupView(){
        addSubview(segmentedControl)
        addSubview(tableView)
        addConstraintsWithVisualFormat(format: "V:|-[v0]-8-[v1]-|", views: segmentedControl, tableView)
        addConstraintsWithVisualFormat(format: "H:|-8-[v0]-8-|", views: segmentedControl)
        addConstraintsWithVisualFormat(format: "H:|-8-[v0]-8-|", views: tableView)
    }
    
    //MARK: - Auxiliar functions
    func startActivityIndicator(){
        tableView.alpha = 0
        activityIN.color = UIColor.blue
        activityIN.center = CGPoint(x: center.x, y: center.y)
        activityIN.startAnimating()
        addSubview(activityIN)
    }
    
    func stopActivityIndicator(){
        tableView.alpha = 1
        activityIN.stopAnimating()
        activityIN.removeFromSuperview()
    }
    
    @objc func changeTable(){
        changeTableAction?()
    }
    
}

    //MARK: - Custom cell class and setup
class MainCell: UITableViewCell{
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let bgView:UIView = {
        var bgview = UIView()
        bgview.layer.cornerRadius = 35
        bgview.backgroundColor = UIColor.white
        bgview.translatesAutoresizingMaskIntoConstraints = false
        return bgview
    }()
    
    let readedView:UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor(white: 0.95, alpha: 1).cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 15
        view.layer.backgroundColor = UIColor(red: 3/255, green: 104/255, blue: 226/255, alpha: 1).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupCell(){
        addSubview(bgView)
        self.contentView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        self.backgroundView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        addConstraintsWithVisualFormat(format: "H:|[v0]|", views: bgView)
        addConstraintsWithVisualFormat(format: "V:|-5-[v0(70)]-5-|", views: bgView)
        bgView.addSubview(readedView)
        bgView.addSubview(nameLabel)
        bgView.addConstraintsWithVisualFormat(format: "H:|-8-[v0(30)]-8-[v1]-|", views: readedView,nameLabel)
        bgView.addConstraintsWithVisualFormat(format: "V:|-20-[v0(30)]-20-|", views: readedView)
        bgView.addConstraintsWithVisualFormat(format: "V:|[v0]|", views: nameLabel)
    }
    
}



