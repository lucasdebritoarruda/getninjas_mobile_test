//
//  UserDefaults Service.swift
//  getninjas_mobile_test
//
//  Created by Lucas de Brito on 30/09/2018.
//  Copyright © 2018 Lucas de Brito. All rights reserved.
//

import Foundation

struct Keys {
    struct offersStates {
        static let cellStates = "cellStates"
        static let offersAcceptedArray = "offersAcceptedArray"
        static let someOfferWasAccepted = "someOfferWasAccepted"
        static let someOfferWasReaded = "someOfferWasReaded"
        static let asOfertas = "asOfertas"
        static let osQuens = "osQuens"
        static let osQuandos = "osQuandos"
        static let osOndes = "osOndes"
    }
    
    private init(){}
}

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private init(){}
    
    var offersStatesArray: Array<String>{
        get {
            return UserDefaults.standard.array(forKey: Keys.offersStates.cellStates) as! Array<String>
        }
        set{
            return UserDefaults.standard.set(newValue, forKey: Keys.offersStates.cellStates)
        }
    }
    
    var readed: Bool{
        get {
            return UserDefaults.standard.bool(forKey: Keys.offersStates.someOfferWasReaded)
        }
        set{
            return UserDefaults.standard.set(newValue, forKey:Keys.offersStates.someOfferWasReaded)
        }
    }
    
    var accepted: Bool{
        get {
            return UserDefaults.standard.bool(forKey: Keys.offersStates.someOfferWasAccepted)
        }
        set{
            return UserDefaults.standard.set(newValue, forKey: Keys.offersStates.someOfferWasAccepted)
        }
    }
    
    var ofertas: Array<String>{
        get {
            return UserDefaults.standard.array(forKey: Keys.offersStates.asOfertas) as! Array<String>
        }
        set{
            return UserDefaults.standard.set(newValue, forKey: Keys.offersStates.asOfertas)
        }
    }
    
    var quens: Array<String>{
        get {
            return UserDefaults.standard.array(forKey: Keys.offersStates.osQuens) as! Array<String>
        }
        set{
            return UserDefaults.standard.set(newValue, forKey: Keys.offersStates.osQuens)
        }
    }
    
    var quando: Array<String>{
        get {
            return UserDefaults.standard.array(forKey: Keys.offersStates.osQuandos) as! Array<String>
        }
        set{
            return UserDefaults.standard.set(newValue, forKey: Keys.offersStates.osQuandos)
        }
    }
    
    var onde: Array<String>{
        get {
            return UserDefaults.standard.array(forKey: Keys.offersStates.osOndes) as! Array<String>
        }
        set{
            return UserDefaults.standard.set(newValue, forKey: Keys.offersStates.osOndes)
        }
    }
    
    var links: Array<String>{
        get {
            return UserDefaults.standard.array(forKey: Keys.offersStates.offersAcceptedArray) as! Array<String>
        }
        set{
            return UserDefaults.standard.set(newValue, forKey: Keys.offersStates.offersAcceptedArray)
        }
    }
    
}
