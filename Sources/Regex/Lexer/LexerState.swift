//
//  LexerState.swift
//  Regex
//

internal struct LexerState {
	var generator = "".generator()
	var isCaseInsensitive = false
	
	var pattern = "" {
		didSet {
			self.generator = self.pattern.generator()
		}
	}
}
