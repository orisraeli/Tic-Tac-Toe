//
//  Model.swift
//  Tic-Tac-Toe
//
//  Created by Or Israeli on 30/07/2023.
//

import Foundation

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
