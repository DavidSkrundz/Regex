//
//  Lexer+Escaped.swift
//  Regex
//

import UnicodeOperators
import Util

private let Numbers = "0123456789"
private let LowercaseLetters = "abcdefghijklmnopqrstuvwxyz"
private let UppercaseLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
private let WordCharacters = LowercaseLetters + UppercaseLetters + Numbers + "_"

extension Lexer {
	/// Converts a `String` of digits in the specified `base` to an `Int` in
	/// base 10
	///
	/// - Precondition: `0 < base <= 16`
	///
	/// - Returns: The base 10 value of the `String` in base `base`
	private static func StringToInt(_ string: String, base: Int) -> Int {
		precondition(base > 0)
		precondition(base <= 16)
		var value = 0
		var multiplier = 1
		for character in string.reversed() {
			value += character.hexValue * multiplier
			multiplier *= base
		}
		return value
	}
	
	/// Reads from the `stringGenerator` for Hex digits up to a max `length` and
	/// returns the associated `Character`
	///
	/// - Note: Upon success `stringGenerator` is advanced by `length`, and upon
	///         failure `stringGenerator` is unchanged
	///
	/// - Returns: The associated `Character` or nil if none was found
	private mutating func findEscapedCharacter(length: Int) -> Character? {
		var string = ""
		var advanceCount = 0
		for _ in 1...length {
			advanceCount += 1
			if let character = self.state.generator.next(),
				                                          character.isHexDigit {
				string.append(character)
			} else {
				self.state.generator.reverseBy(advanceCount)
				return nil
			}
		}
		let value = Lexer.StringToInt(string, base: 16)
		var character = Character(UnicodeScalar(value)!)
		if self.state.isCaseInsensitive {
			character = character.lowercase
		}
		return character
	}
	
	private static let escapedTokens: [Character : Token] = [
		"n" : .Character("\n"),
		"r" : .Character("\r"),
		"t" : .Character("\t"),
		"v" : .Character("\u{000B}"),
		"f" : .Character("\u{000C}"),
		
		"b" : .WordBoundary,
		"B" : .NotWordBoundary,
		"s" : .CharacterSet(
			include: Set(" \n\r\r\n\t\u{000B}\u{000C}".characters),
			exclude: Set()
		),
		"S" : .CharacterSet(
			include: Set(),
			exclude: Set(" \n\r\r\n\t\u{000B}\u{000C}".characters)
		),
		"d" : .CharacterSet(
			include: Set("0123456789".characters),
			exclude: Set()
		),
		"D" : .CharacterSet(
			include: Set(),
			exclude: Set("0123456789".characters)
		),
	]
	
	/// Tokenizes any character escaped by a `\`
	///
	/// - Returns: The `Token` representing the escaped character
	internal mutating func processEscapedCharacter() throws -> Token {
		guard let character = self.state.generator.next() else {
			throw RegexError.DanglingBackslash
		}
		
		switch character {
			case let c where Lexer.escapedTokens.keys.contains(c):
				return Lexer.escapedTokens[c]!
			case "w":
				return .CharacterSet(
					include: Set(WordCharacters.characters),
					exclude: Set()
				)
			case "W":
				return .CharacterSet(
					include: Set(),
					exclude: Set(WordCharacters.characters)
				)
			case let character where character.isOctDigit:
				return self.processOctalNumber(first: character)
			case "x":
				return self.processHexadecimalNumber()
			case "u":
				return self.processUnicodePoint()
			case "c":
				return self.processControllCode()
			default:
				var newCharacter = character
				if self.state.isCaseInsensitive {
					newCharacter = character.lowercase
				}
				return .Character(newCharacter)
		}
	}
	
	private mutating func processOctalNumber(first: Character) -> Token {
		var octalString = String(first)
		for _ in 1...2 {
			if let character = self.state.generator.peek(),
			                                              character.isOctDigit {
				let newString = octalString + String(character)
				if Lexer.StringToInt(newString, base: 8) ≤ 255 {
					octalString.append(character)
					self.state.generator.advance()
				} else {
					break
				}
			}
		}
		let value = Lexer.StringToInt(octalString, base: 8)
		return .OctalCharacter(Character(UnicodeScalar(value)!))
	}
	
	private mutating func processHexadecimalNumber() -> Token {
		let character = self.findEscapedCharacter(length: 2) ?? "x"
		return .Character(character)
	}
	
	private mutating func processUnicodePoint() -> Token {
		let character = self.findEscapedCharacter(length: 4) ?? "u"
		return .Character(character)
	}
	
	private mutating func processControllCode() -> Token {
		if let character = self.state.generator.peek(), character.isLetter {
			self.state.generator.advance()
			let char = Character(UnicodeScalar(character.alphabetIndex)!)
			return .Character(char)
		}
		return .Character("c")
	}
}
