//
//  ContentView.swift
//  HackingWithSwift-TapSudoku
//
//  Created by Michael Jones on 03/04/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var board = Board(difficulty: .testing)
    let spacing = 2.0
    
    @State private var selectedRow = -1
    @State private var selectedCol = -1
    @State private var selectedNum = 0
    
    @State private var solved = false
    @State private var showingNewGame = false
    
    @State private var counts = [Int: Int]()
    
    var body: some View {
        NavigationStack {
            VStack {
                Grid(horizontalSpacing: 1, verticalSpacing: 1) {
                    ForEach(0..<9) { row in
                        GridRow {
                            ForEach(0..<9) { col in
                                CellView(number: board.playerBoard[row][col], selectedNumber: selectedNum, highlightState: highlightState(for: row, col: col), isCorrect: board.playerBoard[row][col] == board.fullBoard[row][col]) {
                                    selectedRow = row
                                    selectedCol = col
                                    selectedNum = board.playerBoard[row][col]
                                }
                                
                                if col == 2 || col == 5 {
                                    Spacer()
                                        .frame(width: spacing, height: 1)
                                }
                            }
                        }
                        .padding(.bottom, row == 2 || row == 5 ? spacing : 0)
                    }
                }
                .padding(5)
                
                // Columns of selectable numbers to place onto the sudoku board.
                HStack {
                    ForEach(1..<10) { i in
                        Button(String(i)) {
                            enter(i)
                        }
                        .frame(maxWidth: .infinity)
                        .font(.largeTitle)
                        .opacity(counts[i, default: 0] == 9 ? 0 : 1)
                    }
                }
                .padding()
                
            }
            .navigationTitle("Tap Sudoku")
            .toolbar {
                Button {
                    showingNewGame = true
                } label: {
                    Label("Start a new Game", systemImage: "plus")
                }
            }
        }
        .preferredColorScheme(ColorScheme.dark)
        .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
        .alert("Start a new game", isPresented: $showingNewGame) {
            ForEach(Board.Difficulty.allCases, id: \.self) { difficulty in
                Button(String(describing: difficulty).capitalized) {
                    newGame(difficulty: difficulty)
                }
            }
            
            Button("Cancel", role: .cancel) { }
        } message: {
            if solved {
                Text("You solved the board correctly!")
            }
        }
        .onAppear(perform: updateCounts)
        .onChange(of: board) { _, _ in
            updateCounts()
        }
        
    }
    
    /// Takes in the row and column, reads it and identifies if the type of state of the cell, then updates the colour of the cell.
    /// - Parameters:
    ///   - row: selected row.
    ///   - col: selected columns
    /// - Returns: Returns the colour of the cell, depending on the highlight state.
    func highlightState(for row: Int, col: Int) -> CellView.HighlightState {
        if row == selectedRow {
            if col == selectedCol {
                return .selected
            } else {
                return .highlighted
            }
        } else if col == selectedCol {
            return .highlighted
        } else {
            return .standard
        }
    }
    
    /// Takes an Int value, and compares the playersBoard row and column location to the Int passed in.
    /// - Parameter number: Int value passed in to be placed onto the Sudoku board.
    func enter(_ number: Int) {
        if board.playerBoard[selectedRow][selectedCol] == number {
            board.playerBoard[selectedRow][selectedCol] = 0
            selectedNum = 0
        } else {
            board.playerBoard[selectedRow][selectedCol] = number
            selectedNum = number
        }
    }
    
    /// Resets the game parameters once the game has ended.
    /// - Parameter difficulty: Selects a difficulty for the new game.
    func newGame(difficulty: Board.Difficulty) {
        board = Board(difficulty: difficulty)
        selectedRow = -1
        selectedCol = -1
        selectedNum = 0
    }
    
    func updateCounts() {
        solved = false
        var newCounts = [Int: Int]()
        var correctCount = 0
        
        for row in 0..<board.size {
            for col in 0..<board.size {
                let value = board.playerBoard[row][col]
                if value == board.fullBoard[row][col] {
                    newCounts[value, default: 0] += 1
                    correctCount += 1
                }
            }
        }
        
        counts = newCounts
        
        if correctCount == board.size * board.size {
            Task {
                try await Task.sleep(for: .seconds(0.5))
                showingNewGame = true
                solved = true
            }
        }
        
    }
    
}

#Preview {
    ContentView()
}
