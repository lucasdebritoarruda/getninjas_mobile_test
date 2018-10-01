//
//  OfferDetailView.swift
//  getninjas_mobile_test
//
//  Created by Lucas de Brito on 28/09/2018.
//  Copyright © 2018 Lucas de Brito. All rights reserved.
//

import UIKit
import MapKit

class OfferDetailView: UIView {
    
    //MARK: - Properties
    var acceptOfferAction: (() -> Void)?
    var denyOfferAction: (() -> Void)?
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View components
    let mapView: MKMapView = {
        let mv = MKMapView()
        mv.isZoomEnabled = false
        mv.isScrollEnabled = false
        mv.translatesAutoresizingMaskIntoConstraints = false
        return mv
    }()
    
    let infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let offerNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 20)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "wytygshjklmnbvcxcvbnm"
        return lbl
    }()
    
    let quemLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let ondeLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let offerInfoLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let decoraionLine: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    let contactArea: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 204/255, alpha: 1)
        view.layer.borderColor = UIColor(red: 230/255 , green: 230/255, blue: 0, alpha: 1).cgColor
        view.layer.borderWidth = 3
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let contactLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 2
        return lbl
    }()
    
    let buttonArea: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let acceptButton: UIButton = {
        let btn = UIButton(title: "Aceitar", titleColor: .black, backGroundColor: .green, borderColor: .green)
        btn.addTarget(self, action: #selector(acceptOffer), for: .touchUpInside)
        return btn
    }()
    
    let denyButton: UIButton = {
        let btn = UIButton(title: "Recusar", titleColor: .white, backGroundColor: .red, borderColor: .red)
        btn.addTarget(self, action: #selector(denyOffer), for: .touchUpInside)
        return btn
    }()
    
    //MARK: - Setup and constraints
    func setupView() {
        addSubview(mapView)
        addSubview(infoView)
        addConstraintsWithVisualFormat(format: "H:|[v0]|", views: mapView)
        addConstraintsWithVisualFormat(format: "H:|-[v0]-|", views: infoView)
        addConstraintsWithVisualFormat(format: "V:|[v0(250)]-8-[v1]|", views: mapView, infoView)
        infoView.addSubview(offerNameLabel)
        infoView.addSubview(quemLabel)
        infoView.addSubview(ondeLabel)
        infoView.addSubview(offerInfoLabel)
        infoView.addSubview(decoraionLine)
        infoView.addSubview(contactArea)
        infoView.addSubview(buttonArea)
        contactArea.addSubview(contactLabel)
        buttonArea.addSubview(acceptButton)
        buttonArea.addSubview(denyButton)
        infoView.addConstraintsWithVisualFormat(format: "V:|-[v0][v4(2)]-16-[v1]-[v2]-16-[v3]-[v5(60)]-[v6(60)]", views: offerNameLabel,quemLabel,ondeLabel,offerInfoLabel,decoraionLine,contactArea,buttonArea)
        infoView.addConstraintsWithVisualFormat(format: "H:|-[v0]-|", views: offerNameLabel)
        infoView.addConstraintsWithVisualFormat(format: "H:|-[v0]-|", views: quemLabel)
        infoView.addConstraintsWithVisualFormat(format: "H:|-[v0]-|", views: ondeLabel)
        infoView.addConstraintsWithVisualFormat(format: "H:|-[v0]-|", views: offerInfoLabel)
        infoView.addConstraintsWithVisualFormat(format: "H:|-[v0]-|", views: decoraionLine)
        infoView.addConstraintsWithVisualFormat(format: "H:|-[v0]-|", views: contactArea)
        infoView.addConstraintsWithVisualFormat(format: "H:|-[v0]-|", views: buttonArea)
        contactArea.addConstraintsWithVisualFormat(format: "H:|-[v0]-|", views: contactLabel)
        contactArea.addConstraintsWithVisualFormat(format: "V:|-[v0]-|", views: contactLabel)
        buttonArea.addConstraintsWithVisualFormat(format: "H:|-10-[v0]-[v1(150)]-10-|", views: denyButton,acceptButton)
        buttonArea.addConstraintsWithVisualFormat(format: "V:|-10-[v0(40)]-10-|", views: denyButton)
        buttonArea.addConstraintsWithVisualFormat(format: "V:|-10-[v0(40)]-10-|", views: acceptButton)
    }
    
    //MARK: - Auxiliar functions
    @objc func acceptOffer(){
        acceptOfferAction?()
    }
    
    @objc func denyOffer(){
        denyOfferAction?()
    }
}
