//
//  ParserState.swift
//  Regex
//

internal struct ParserState {
	internal var generator = [Token]().generator()
	internal var groupCount = 0
	internal var alternating  = false // Set to true if loop should stop
	
	var tokens = [Token]() {
		didSet {
			self.generator = self.tokens.generator()
		}
	}
}
