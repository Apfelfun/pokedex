//
//  Pokemon.swift
//  pokedex
//
//  Created by Yousef on 19.07.17.
//  Copyright © 2017 Yousef. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    fileprivate var _name: String!
    fileprivate var _pokedexId: Int!
    private var _description: String!
    private var _typ: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionText: String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionID: String!
    private var _nextEvolutionLevel: String!
    private var _pokemonURL: String!
    
    var nextEvolutionName: String {
        if _nextEvolutionName == nil {
            _nextEvolutionName = ""
        }
        return _nextEvolutionName
    }
    
    var nextEvolutionID: String {
        if _nextEvolutionID == nil {
            _nextEvolutionID = ""
        }
        return _nextEvolutionID
    }
    
    var nextEvolutionLevel: String {
        if _nextEvolutionLevel == nil {
            _nextEvolutionLevel = ""
        }
        return _nextEvolutionLevel
    }
    
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    
    var typ: String {
        if _typ == nil {
            _typ = ""
        }
        return _typ
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    
    var height: String {
        if _height == nil{
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    
    var nextEvolutionText: String {
        if _nextEvolutionText == nil {
            _nextEvolutionText = ""
        }
        
        return _nextEvolutionText
    }
    
    
    
    var name: String! {
        return _name
    }
    
    var pokedexId: Int! {
        return _pokedexId
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        
        self._pokemonURL = "\(URL_BASE)\(URL_Pokemon)\(self._pokedexId!)"
    }
    
    func downloadPokemonDetail(completed:  @escaping DownloadComplete) {
        
        Alamofire.request(_pokemonURL).responseJSON { (respose) in
            
           if let dict = respose.result.value as? Dictionary<String, AnyObject>{
                
            if let weight = dict["weight"] as? String {
                self._weight = weight
            }
            
            if let height = dict["height"] as? String {
                self._height = height
            }
            
            if let attack = dict["attack"] as? Int {
                self._attack = "\(attack)"
            }
            
            if let defense = dict["defense"] as? Int {
                self._defense = "\(defense)"
            }
            
//            print(self._weight)
//            print(self._height)
//            print(self._attack)
//            print(self._defense)
         
            if let types = dict["types"] as? [Dictionary<String, AnyObject>] , types.count > 0 {
                
                if let name = types[0]["name"] {
                    self._typ = name.capitalized
                }
                
                if types.count > 1 {
                    
                    for x in 1..<types.count {
                    
                    if let name = types[x]["name"] {
                        self._typ! += "/\(name.capitalized!)"
                    }
                }
                    
                    
                print(self._typ)
                }
                
            } else {
                self._typ = ""
            }
            
            if let descArr = dict["descriptions"] as? [Dictionary<String, AnyObject>], descArr.count > 0 {
                
                if let url = descArr[0]["resource_uri"] {
                    let curruntUrl = "\(URL_BASE)\(url)"
                    
                    Alamofire.request(curruntUrl).responseJSON(completionHandler: { (respose) in
                        
                        if let descDict = respose.result.value as? Dictionary<String, AnyObject> {
                            
                            if let descripion = descDict["description"] as? String {
                                
                                let newDescription = descripion.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                
                                self._description = newDescription
                            }
                        }
                        completed()
                    })
                    
                }
                
            } else {
                return self._description = ""
            }
            
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>], evolutions.count > 0 {
                
                    if let nextEvo = evolutions[0]["to"] as? String {
                        if nextEvo.range(of: "mega") == nil {
                        self._nextEvolutionName = nextEvo
                        
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                let nextEvoId = newStr.replacingOccurrences(of: "/", with: "")
                            
                                self._nextEvolutionID = nextEvoId
                        
                                    if let lvlExist = evolutions[0]["level"] {
                                        if let lvl = lvlExist as? Int {
                                            self._nextEvolutionLevel = "\(lvl)"
                                }
                            
                            } else {
                                self._nextEvolutionLevel = ""
                                }
                            }
                
                        }
                
                    }
                    
                    print(self.nextEvolutionName)
                    print(self.nextEvolutionLevel)
                    print(self.nextEvolutionID)
        
                }
            
            }
            completed()
        }
        
    }
}
