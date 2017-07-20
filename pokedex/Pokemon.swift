//
//  Pokemon.swift
//  pokedex
//
//  Created by Yousef on 19.07.17.
//  Copyright © 2017 Yousef. All rights reserved.
//

import Foundation

class Pokemon {
    fileprivate var _name: String!
    fileprivate var _pokedexId: Int!
    private var _description: String!
    private var _typ: String!
    private var _defense: String!
    private var _height: String!
    private var _attack: String!
    private var _nextEvolutionText: String!
    
    var name: String! {
        return _name
    }
    
    var pokedexId: Int! {
        return _pokedexId
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
    }
}
