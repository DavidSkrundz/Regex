//
//  Lexer.swift
//  Regex
//

import Generator

internal struct Lexer {
	private var tokens = [Token]()
	
	private init() {}
	
	internal static func lex(_ pattern: String) throws -> [Token] {
		var lexer = Lexer()
		lexer.tokens.reserveCapacity(pattern.count)
		try pattern.generator().forEach { try lexer.lex($0) }
		return lexer.tokens
	}
	
	private mutating func lex(_ character: Character) throws {
		switch character {
			default:
				self.tokens.append(.Character(character))
		}
	}
}
