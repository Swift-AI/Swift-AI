//
//  Genetic.swift
//  Swift-AI-OSX
//
//  Created by Andrea Tullis on 07/12/15.
//  Copyright © 2015 Appsidian. All rights reserved.
//

import Foundation

typealias FitnessFunction = (Vector) -> Double

public class Genetic{


    let populationSize : Int
    let selectionRate : Double
    let mutationRate : Double
    let mutationSize : Double
    let crossRate : Double
    let function : FitnessFunction
    let generations : Int
    
    var currentPopulation : [Vector]
    var bestFitness : Double = DBL_MAX
    init(populationSize: Int, selectionRate : Double, mutationRate : Double, mutationSize: Double, crossRate : Double, function : FitnessFunction, generations: Int, initialPopulation: [Vector]){
        
        self.populationSize = populationSize
        
        //  TODO: - Check that are [0 1]
        self.selectionRate = selectionRate
        self.mutationRate = mutationRate
        self.crossRate = crossRate
        self.mutationSize = mutationSize
        self.function = function
        
        self.currentPopulation = initialPopulation
        self.generations = generations
    }
    
    
    func cross(father : Vector, mother: Vector ) -> Vector {
        let child  = father.copy()
        for (index, _) in father.flat.enumerate() {
            if randomOne() > self.crossRate {
                child[index] = mother[index]
                continue
            }
        }
        return child
    }
    
    func mutate(father : Vector) -> Vector {
        let child  = father.copy()
        for (index, value) in father.flat.enumerate() {
            if randomOne() > self.mutationRate {
                child[index] = randomBounded(value * self.mutationSize)
            }
        }
        return child
    }
    
    func randomOne() -> Double{
         return Double(arc4random_uniform(UInt32.max))/Double(UInt32.max)
    }
    
    func random(max: Int) -> Double {
       return  Double(arc4random_uniform(UInt32(max)))
        
    }
    
    func randomBounded(max: Double) -> Double{

        
        return  Double(max) * ( 1 - 2 * randomOne())
    }
    
    func evolve(){
        var generation = 0
        repeat{
            
            /*
            1st: selection of
            */
            var ordered = currentPopulation.map({ element in
                return (element,self.function(element))
            })
            ordered = ordered.sort({ (first, second) -> Bool in
                return first.1 < second.1
            })
            var size = Int(self.selectionRate * Double(self.populationSize))
            if size > ordered.count {
            
                size = ordered.count
            
            }
            let selection = ordered[0 ..< size]
            
            currentPopulation.removeAll()
            for (e,_) in selection {
                currentPopulation.append(e)
            }
            
            repeat{
                
                let father = selection[Int(random(selection.count))].0
                let mother = selection[Int(random(selection.count))].0
                
                var child = self.cross(father, mother: mother)
                child = self.mutate(child)
                
                self.currentPopulation.append(child)

            
            } while (currentPopulation.count < self.populationSize)
        
            generation++
            print("Generation \(generation) - best: \(ordered[0].1)")
        if ordered[0].1 == 0 {
            break
            }
        }while(generation < self.generations)
        
            print(currentPopulation[0].flat)
        
    }
    
}