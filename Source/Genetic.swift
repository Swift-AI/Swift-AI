//
//  Genetic.swift
//  Swift-AI-OSX
//
//  Created by Andrea Tullis on 07/12/15.
//  Copyright © 2015 Appsidian. All rights reserved.
//

import Foundation



public class Genetic{


    let populationSize : Int
    let selectionRate : Double
    let mutationRate : Double
    let mutationSize : Double
    let crossRate : Double
    let function : ([Double]) -> Double
    let generations : Int
    let integerProblem : Bool
    var currentPopulation : [[Double]]
    var bestFitness : Double = DBL_MAX
    public init(populationSize: Int, selectionRate : Double, mutationRate : Double, mutationSize: Double, crossRate : Double, function : ([Double]) -> Double, generations: Int, initialPopulation: [[Double]], integerProblem: Bool){
        
        self.populationSize = populationSize
        
        self.selectionRate = selectionRate
        self.mutationRate = mutationRate
        self.crossRate = crossRate
        self.mutationSize = mutationSize
        self.function = function
        
        self.currentPopulation = initialPopulation
        self.generations = generations
        self.integerProblem = integerProblem
    }
    
    
    func cross(father : [Double], mother: [Double] ) -> [Double] {
        var child : [Double] = []
        for (index,element) in father.enumerate() {
            
            if self.randomOne() < self.crossRate{
                child.append(element)
            }else{
                child.append(mother[index])
            }
            
        }
        return child
    }
    

    
    func mutate(father : [Double]) -> [Double] {
        var child : [Double] = []
        var mutated = false
        for (_,element) in father.enumerate() {
            mutated = false
            if self.randomOne() < self.mutationRate {
                child.append(element)
            }else{
                mutated = true
                child.append(randomBalanced(element))
            }
        }
        if mutated {
           // print("Mutated \(father) into \(child)")
        }
        return child
    }
    
    func randomOne() -> Double {
         return Double(Double(arc4random_uniform(UInt32.max))/Double(UInt32.max))
    }
    
    func random(max: Double) -> Double {
        
        return  randomOne() * max
        
    }
    
    func randomBalanced(max: Double) -> Double {
        var r = random(max * self.mutationSize) - max
        if self.integerProblem {
            r = round(r)
        }
        return  r
    }
    

    public func evolve() -> [Double]{
        var generation = 0
        let step = self.generations / 100
        repeat{
            
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
                
                let father = selection[Int(random(Double(selection.count)))].0
                let mother = selection[Int(random(Double(selection.count)))].0
                
                var child = self.cross(father, mother: mother)
                child = self.mutate(child)
                
                self.currentPopulation.append(child)
                
                
            } while (currentPopulation.count < self.populationSize)
            
            
            generation = generation + 1
            if((generation) % step == 0){
                //print("Generation \(generation) - best: \(ordered[0].1)")
            }
        }while(generation < self.generations )
        
        /*
        last reorder
        */
        var ordered = currentPopulation.map({ element in
            return (element,self.function(element))
        })
        ordered = ordered.sort({ (first, second) -> Bool in
            return first.1 < second.1
        })
        
        return ordered[0].0
    }
    
}