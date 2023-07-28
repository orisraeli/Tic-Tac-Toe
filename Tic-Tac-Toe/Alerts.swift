//
//  Alerts.swift
//  Tic-Tac-Toe
//
//  Created by Or Israeli on 28/07/2023.
//

import SwiftUI

struct AlertItem: Identifiable {
	let id = UUID()
	var title: Text
	var message: Text
	var buttonTitle: Text
}

struct AlertContext {
	static let humanWin = AlertItem(title: Text("You win!"),
							 message: Text("You are so smart. You beat your own AI."),
							 buttonTitle: Text("Hell Yeah"))
	
	static let pcWin = AlertItem(title: Text("You lost..."),
							 message: Text("What a battle of wits we have here..."),
							 buttonTitle: Text("Rematch"))
	
	static let draw = AlertItem(title: Text("Draw"),
							 message: Text("You are so smart. You beat your own AI."),
							 buttonTitle: Text("Try Again"))
}
