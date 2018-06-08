//
//  Lexer.swift
//  Regex
//

private let NewlineCharacters = "\n\r\r\n"

/// The `Tokenizer` takes a pattern `String` and converts it to an
/// `Array<Token>` for parsing later. The goal of the `Tokenizer` is to decouple
/// the `Character` from the meaning in the expression.
///
/// - Author: David Skrundz
internal struct Lexer {
	/// A mapping from a `Character` to a `Token` for all simple conversions
	private static let characterTokens: [Character : Token] = [
		"^" : .Start,
		"$" : .End,
		"|" : .Alternation,
		")" : .EndGroup,
		"." : .CharacterSet(include: [], exclude: Set(NewlineCharacters)),
	]
	
	/// A mapping from a `String` to a `Token` for basic quantifiers
	private static let quantifierTokens: [String : Token] = [
		"?"  : .Optional,
		"??" : .LazyOptional,
		"+"  : .OneOrMore,
		"+?" : .LazyOneOrMore,
		"*"  : .ZeroOrMore,
		"*?" : .LazyZeroOrMore,
	]
	
	/// A mapping from a `String` to a `Token` for  groups
	private static let groupTokens: [String : Token] = [
		"?:"  : .StartGroup,
		"?="  : .StartLookAheadGroup,
		"?!"  : .StartNegativeLookAheadGroup,
		"?<=" : .StartLookBehindGroup,
		"?<!" : .StartNegativeLookBehindGroup,
	]
	
	internal var state: LexerState
	internal var tokens: [Token]
	
	private init() {
		self.state = LexerState()
		self.tokens = []
	}
	
	/// Converts a `pattern` to a `[Token]`
	private mutating func lex(_ pattern: String) throws -> [Token] {
		self.state.pattern = pattern
		
		try self.processFlags()
		
		while let character = self.state.generator.next() {
			try self.lex(character)
		}
		
		return self.tokens
	}
	
	/// Attempt to convert a single character into a token, falling back to
	/// reading more characters from `self.state.generator` if neccessary
	private mutating func lex(_ character: Character) throws {
		switch character {
			case let c where Lexer.characterTokens.keys.contains(c):
				self.tokens.append(Lexer.characterTokens[c]!)
			case let c where Lexer.quantifierTokens.keys.contains(String(c)):
				let string = "\(c)" + {
					guard let
						lazyModifier = self.state.generator.peek(),
						lazyModifier == "?"
						else { return "" }
					self.state.generator.advance()
					return "?"
				}()
				self.tokens.append(Lexer.quantifierTokens[string]!)
			case "\\":
				self.tokens.append(try self.processEscapedCharacter())
			case "{":
				try self.processNumericQuantifier()
			case "[":
				try self.processCharacterSet()
			case "]":
				throw RegexError.UnmatchedClosingBracket
			case "(": ()
				let string: [String] = (2...3)
					.reversed()
					.map { self.state.generator.peek($0) }
					.map { $0.reduce("") { $0 + String($1) } }
			
				let token: (Int, Token) = string
					.map { ($0.count, Lexer.groupTokens[$0]) }
					.filter { $0.1 != nil }
					.map { ($0.0, $0.1!) }
					.first ?? (0, .StartCaptureGroup)

				self.state.generator.advanceBy(token.0)
				self.tokens.append(token.1)
			default:
				tokens.append(
					.Character(self.state.isCaseInsensitive
						? character.lowercase
						: character
					)
				)
		}
	}
	
	/// The entry point to the `Lexer`. Converts a `pattern` to an
	/// `Array<Token>`
	///
	/// - Returns: An `[Token]` representing the `pattern`
	internal static func lex(_ pattern: String) throws -> [Token] {
		var lexer = Lexer()
		return try lexer.lex(pattern)
	}
}
