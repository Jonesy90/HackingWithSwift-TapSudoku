//
//  Board.swift
//  HackingWithSwift-TapSudoku
//
//  Created by Michael Jones on 03/04/2026.
//

import Foundation

struct Board: Equatable {
    let size = 9
    var fullBoard = [[Int]]()
    var playerBoard = [[Int]]()
    
    init() {
        create()
    }
    
    mutating private func create() {
        let numbers = Array(1...size)
        let positions = [0, 3, 6, 1, 4, 7, 2, 5, 8]
        
        let rows = Array(0..<size)
        let columns = Array(0..<size)
        
        for row in rows {
            var newRow = [Int]()
            
            for column in columns {
                let position = (positions[row] + column) % size
                newRow.append(numbers[position])
            }
            
            fullBoard.append(newRow)
            print(newRow)
        }
        
        playerBoard = fullBoard
    }
}
