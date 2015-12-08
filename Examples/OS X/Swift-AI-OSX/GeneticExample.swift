//
//  Genetic.swift
//  Swift-AI-OSX
//
//  Created by Andrea on 12/8/15.
//  Copyright © 2015 Appsidian. All rights reserved.
//

import Foundation


/*
Simple shopping function. Got 16$, Bananas cost 2$, Apple 0.5$, Orange 1$ -> wanna at least one of each and the biggest number
*/

func shop() {
    print("******** Genetic Algorithm Example ********")

    let function : ([Double]) -> Double = { elements in
        
        let bananas = elements[0]
        let apples = elements[1]
        let oranges = elements[2]
        
        guard bananas >= 1 && apples >= 1 && oranges >= 1 else {
            
            return DBL_MAX
        }
        let calc = 16.0 - ((bananas * 2) + (apples * 0.5) + (oranges * 1))
        
        return calc >= 0 ? calc : DBL_MAX
        
        
    }
    let a : [Double] = [2,2,2]
    let world = Genetic(populationSize: 1000, selectionRate : 0.25, mutationRate : 0.50, mutationSize: 2.5, crossRate : 0.50, function : function , generations: 100, initialPopulation:[a],integerProblem: true)
    print("******** Evolving Population, may take a while ********")
    let result = world.evolve()
    print("******** Result ******** \(result) - \(function(result))")
    
}