//
//  GameView.swift
//  Tic-Tac-Toe
//
//  Created by Or Israeli on 27/07/2023.
//

import SwiftUI

struct GameView: View {
	@StateObject private var viewModel = GameViewModel()
	
	var body: some View {
		VStack {
			Text("Tic Tac Toe")
				.font(.largeTitle)
				.bold()
			
			LazyVGrid(columns: viewModel.columns) {
				ForEach(0..<9) { i in
					ZStack {
						GameSlotView()
						
						PlayerIndicator(imageName: viewModel.moves[i]?.indicator ?? "")
					}
					.onTapGesture {
						viewModel.processPlayerMove(for: i)
					}
				}
			}
			.disabled(viewModel.isBoardDisabled)
			.padding()
			.alert(item: $viewModel.alertItem) { alertItem in
				Alert(title: alertItem.title, message: alertItem.message, dismissButton: .default(alertItem.buttonTitle, action: viewModel.resetGame))
			}
		}
	}
}

struct GameSlotView: View {
	var body: some View {
		Circle()
			.foregroundColor(.indigo)
			.opacity(0.5)
	}
}

struct PlayerIndicator: View {
	let imageName: String
	
	var body: some View {
		Image(systemName: imageName)
			.resizable()
			.frame(width: 50, height: 50)
			.foregroundColor(.white)
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		GameView()
	}
}


