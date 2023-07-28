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
	@State private var alertItem: AlertItem?
	
	var body: some View {
		VStack {
			Text("Tic Tac Toe")
				.font(.largeTitle)
				.bold()
			
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
						
						//check for human win/draw
						if checkForWin(for: .human, in: moves) {
							alertItem = AlertContext.humanWin
							return
						}
						
						if checkForDraw(in: moves) {
							alertItem = AlertContext.draw
							return
						}
						
						isBoardDisabled = true
						
						//delay pc move by 0.5s to make it realistic
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
							let pcPosition = determinePcMovePosition(in: moves)
							moves[pcPosition] = Move(player: .pc, boardIndex: pcPosition)
							isBoardDisabled = false
							
							//check for pc win/draw
							if checkForWin(for: .pc, in: moves) {
								alertItem = AlertContext.pcWin
								return
							}
							
							if checkForDraw(in: moves) {
								alertItem = AlertContext.draw
								return
							}
						}
					}
				}
			}
			.disabled(isBoardDisabled)
			.padding()
			.alert(item: $alertItem) { alertItem in
				Alert(title: alertItem.title, message: alertItem.message, dismissButton: .default(alertItem.buttonTitle, action: resetGame))
		}
		}
	}
	
	func isSlotOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
		return moves.contains(where: {$0?.boardIndex == index})
	}
	
	func determinePcMovePosition(in moves: [Move?]) -> Int {
		//1 - if AI can win, then win.
		let winPatterns: Set<Set<Int>> = [
			[0, 1, 2], [3, 4, 5], [6, 7, 8],
			[0, 3, 6], [1, 4, 7], [2, 5, 8],
			[0, 4, 8], [2, 4, 6]
		]
		
		let activeMoves = moves.compactMap { $0 }
		let pcActiveMoves = activeMoves.filter { $0.player == .pc }
		let pcPositions = Set(pcActiveMoves.map { $0.boardIndex })
		
		for pattern in winPatterns {
			let winPositions = pattern.subtracting(pcPositions)
			
			if winPositions.count == 1 {
				let isAvailable = !isSlotOccupied(in: moves, forIndex: winPositions.first!)
				if isAvailable { return  winPositions.first!}
			}
		}
		
		//2 - if AI can't win, then block human.
		let humanActiveMoves = activeMoves.filter { $0.player == .human }
		let humanPositions = Set(humanActiveMoves.map { $0.boardIndex })
		
		for pattern in winPatterns {
			let winPositions = pattern.subtracting(humanPositions)
			
			if winPositions.count == 1 {
				let isAvailable = !isSlotOccupied(in: moves, forIndex: winPositions.first!)
				if isAvailable { return  winPositions.first!}
			}
		}
		
		//3 - if AI can't block, then take middle pos.
		let centerPos = 4
		if !isSlotOccupied(in: moves, forIndex: centerPos) {
			return centerPos
		}
		
		//4 - if AI can't take middle pos, take random pos.
		var movePosition = Int.random(in: 0..<9)
		
		while isSlotOccupied(in: moves, forIndex: movePosition) {
			movePosition = Int.random(in: 0..<9)
		}
		
		return movePosition
	}
	
	func checkForWin(for player: Player, in moves: [Move?]) -> Bool {
		let winPatterns: Set<Set<Int>> = [
			[0, 1, 2], [3, 4, 5], [6, 7, 8],
			[0, 3, 6], [1, 4, 7], [2, 5, 8],
			[0, 4, 8], [2, 4, 6]
		]
		
		let activeMoves = moves.compactMap { $0 }
		let playerActiveMoves = activeMoves.filter { $0.player == player }
		let playerPositions = Set(playerActiveMoves.map { $0.boardIndex })
		
		for pattern in winPatterns where pattern.isSubset(of: playerPositions) {
			return true
		}
		
		return false
	}
	
	func checkForDraw(in moves: [Move?]) -> Bool {
		return moves.compactMap { $0 }.count == 9
	}
	
	func resetGame() {
		moves = Array(repeating: nil, count: 9)
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
