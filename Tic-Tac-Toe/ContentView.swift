//
//  ContentView.swift
//  Tic-Tac-Toe
//
//  Created by Or Israeli on 27/07/2023.
//

import SwiftUI

struct ContentView: View {
	let columns: [GridItem] = [GridItem(.flexible()),
							   GridItem(.flexible()),
							   GridItem(.flexible())]
	
	@State private var moves: [Move?] = Array(repeating: nil, count: 9)
	@State private var isBoardDisabled = false
 
    var body: some View {
		LazyVGrid(columns: columns) {
			ForEach(0..<9) { i in
				ZStack {
					Circle()
						.foregroundColor(.indigo)
						.opacity(0.5)
					
					Image(systemName: moves[i]?.indicator ?? "")
						.resizable()
						.frame(width: 50, height: 50)
						.foregroundColor(.white)
				}
				.onTapGesture {
					if isSlotOccupied(in: moves, forIndex: i) { return }
					moves[i] = Move(player: .human, boardIndex: i)
					isBoardDisabled = true
					
					//check for win/draw
					
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
						let pcPosition = determinePcMovePosition(in: moves)
						moves[pcPosition] = Move(player: .pc, boardIndex: pcPosition)
						isBoardDisabled = false
					}
				}
			}
		}
		.disabled(isBoardDisabled)
		.padding()
    }
	
	func isSlotOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
		return moves.contains(where: {$0?.boardIndex == index})
	}
	
	func determinePcMovePosition(in moves: [Move?]) -> Int {
		var movePosition = Int.random(in: 0..<9)
		
		while isSlotOccupied(in: moves, forIndex: movePosition) {
			movePosition = Int.random(in: 0..<9)
		}
		
		return movePosition
	}
}

enum Player {
	case human, pc
}

struct Move {
	let player: Player
	let boardIndex: Int
	
	var indicator: String {
		return player == .human ? "xmark" : "circle"
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		ContentView()
    }
}
