//
//  Parser.swift
//  Regex
//

import Util

/// The `Parser` takes an `Array<Token>` and converts it to an `Array<Symbol>`
/// for compiling. The goal of the `Parser` is to convert from the linearity of
/// `Token`s to the final structure of the expression.
///
/// - Author: David Skrundz
internal struct Parser {
	internal var state: ParserState
	internal var flags: [Symbol]
	internal var symbols: [Symbol]
	
	private init() {
		self.state = ParserState()
		self.flags = []
		self.symbols = []
	}
	
	private mutating func parse(_ tokens: [Token]) throws -> [Symbol] {
		self.state.tokens = tokens
		
		while let token = self.state.generator.next() {
			try self.parse(token)
			if self.state.alternating { break }
		}
		
		return self.flags + self.symbols
	}
	
	private mutating func parse(_ token: Token) throws {
		if token.isQuantifier {
			guard self.symbols.count > 0 else {
				throw RegexError.InvalidTargetForQuantifier
			}
			let lastSymbol = self.symbols.removeLast()
			guard !lastSymbol.isQuantifier else {
				throw RegexError.InvalidTargetForQuantifier
			}
			try self.parseQuantifier(lastSymbol, token)
			return
		}
		
		try self.parseGroup(token)
		
		switch token {
			case .GlobalSearchFlag: self.flags.append(.GlobalSearchFlag)
			case .CaseInsensitiveFlag: self.flags.append(.CaseInsensitiveFlag)
			case .MultilineFlag: self.flags.append(.MultilineFlag)
			
			case .Start: self.symbols.append(.Start)
			case .End: self.symbols.append(.End)
			case .WordBoundary: self.symbols.append(.WordBoundary)
			case .NotWordBoundary: self.symbols.append(.NotWordBoundary)
			
			case let .Character(character):
				self.symbols.append(.Character(character))
			case let .CharacterSet(includeSet, excludeSet):
				self.symbols.append(
					.CharacterSet(include: includeSet, exclude: excludeSet)
				)
			
			case let .OctalCharacter(character):
				if character.unicodeValue == 0 ||
					            character.unicodeValue > self.state.groupCount {
					self.symbols.append(.Character(character))
				} else {
					self.symbols.append(
						.BackReference(character.unicodeValue - 1)
					)
				}
			
			case .Alternation:
				self.state.alternating = true
				
				let leftSymbols = self.symbols
				let remainingTokens = self.state.generator.remainingItems()
				let rightSymbols = try Parser.parse(remainingTokens)
				self.symbols = [.Alternation(leftSymbols, rightSymbols)]
			
			default: ()
		}
	}
	
	///The entry point to the `Parser`.
	internal static func parse(_ tokens: [Token], groupCount: Int = 0) throws -> [Symbol] {
		var parser = Parser()
		parser.state.groupCount = groupCount
		return try parser.parse(tokens)
	}
}
