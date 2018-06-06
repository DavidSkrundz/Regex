//
//  Parser.swift
//  Regex
//

internal struct Parser {
	private var automaton = Automaton()
	private var lastState: State!
	
	private init() {
		self.lastState = self.automaton.newState()
		self.automaton.initialStates = [self.lastState]
	}
	
	internal static func parse(_ tokens: [Token]) throws -> Automaton {
		var parser = Parser()
		try tokens.generator().forEach { try parser.parse($0) }
		parser.automaton.acceptingStates = [parser.lastState]
		return parser.automaton
	}
	
	private mutating func parse(_ token: Token) throws {
		switch token {
			case .Character(let character):
				let newState = self.automaton.newState()
				self.automaton.addTransition(from: lastState, to: newState,
				                             symbol: .Character(character))
				self.lastState = newState
		}
	}
}
