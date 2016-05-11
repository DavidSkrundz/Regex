//
//  Lexer+CharacterSet.swift
//  Regex
//

import Util

extension Lexer {
	/// Tokenizes character sets. Parses the whole block from `[` to `]` and
	/// returns a `Token` representing the whole set
	///
	/// - Returns: A `Token` that represents the character set
	internal mutating func processCharacterSet() throws {
		guard self.state.generator.peek() != nil else {
			throw RegexError.UnmatchedOpeningBracket
		}
		
		let isNegateSet: Bool
		if self.state.generator.peek() == "^" {
			isNegateSet = true
			self.state.generator.advance()
		} else {
			isNegateSet = false
		}
		
		var includeSet = Set<Character>()
		var excludeSet = Set<Character>()
		var lastCharacter: Character?
		while let character = self.state.generator.next() {
			// Process `x-y`
			if character == "-" && lastCharacter != nil {
				if let nextCharacter = self.state.generator.peek(),
					                                      nextCharacter != "]" {
					self.state.generator.advance()
					let nextCharacter = self.state.isCaseInsensitive
						? nextCharacter.lowercase
						: nextCharacter
					guard let
						lastCharacter = lastCharacter,
						lastCharacter < nextCharacter
						else { throw RegexError.ReversedSetRange }
					let startValue = lastCharacter.unicodeValue
					let endValue = nextCharacter.unicodeValue
					let unicodeRange = startValue...endValue
					for unicodeValue in unicodeRange {
						let character = Character(UnicodeScalar(unicodeValue)!)
						includeSet.insert(character)
					}
					continue
				}
			}
			
			if lastCharacter != nil {
				includeSet.insert(lastCharacter!)
				lastCharacter = nil
			}
			
			// Process everything else
			switch character {
				case "]":
					if let lastCharacter = lastCharacter {
						includeSet.insert(lastCharacter)
					}
					if isNegateSet {
						self.tokens.append(.CharacterSet(
							include: excludeSet,
							exclude: includeSet
						))
					} else {
						self.tokens.append(.CharacterSet(
							include: includeSet,
							exclude: excludeSet
						))
					}
					return
				case "\\":
					let token = try self.processEscapedCharacter()
					switch token {
						case let .Character(character),
						     let .OctalCharacter(character):
							lastCharacter = character
						case let .CharacterSet(include, exclude):
							includeSet = includeSet.union(include)
							excludeSet = excludeSet.union(exclude)
						case .WordBoundary, .NotWordBoundary:
							() // Do nothing
						default:
							fatalError("Invalid token: \(token)")
					}
				default:
					lastCharacter = self.state.isCaseInsensitive
						? character.lowercase
						: character
			}
		}
		throw RegexError.UnmatchedOpeningBracket
	}
}
