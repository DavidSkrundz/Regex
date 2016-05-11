//
//  Parser+Group.swift
//  Regex
//

import Util

extension Parser {
	/// Handles the conversion from a group token to a group symbol
	internal mutating func parseGroup(_ groupToken: Token) throws {
		switch groupToken {
			case .StartGroup:
				try self.symbols.append(.Group(self.parseGroup()))
			case .StartCaptureGroup:
				try self.symbols.append(.CaptureGroup(self.parseGroup()))
				self.state.groupCount += 1
			case .StartLookAheadGroup:
				try self.symbols.append(.LookAheadGroup(self.parseGroup()))
				self.state.groupCount += 1
			case .StartNegativeLookAheadGroup:
				try self.symbols.append(
					.NegativeLookAheadGroup(self.parseGroup())
				)
				self.state.groupCount += 1
			case .StartLookBehindGroup:
				try self.symbols.append(.LookBehindGroup(self.parseGroup()))
				self.state.groupCount += 1
			case .StartNegativeLookBehindGroup:
				try self.symbols.append(
					.NegativeLookBehindGroup(self.parseGroup())
				)
				self.state.groupCount += 1
				
			case .EndGroup: throw RegexError.UnmatchedClosingParenthesis
			
			default: ()
		}
	}
	
	/// Parses the contents of a group
	///
	/// - Returns: The `Symbol`s contained in the group
	private mutating func parseGroup() throws -> [Symbol] {
		var subGroupCount = 0
		var tokensToParse = [Token]()
		
		while let token = self.state.generator.next() {
			switch token {
				case .StartGroup, .StartCaptureGroup:
					subGroupCount += 1
					tokensToParse.append(token)
				case .EndGroup:
					if subGroupCount == 0 {
						return try Parser.parse(
							tokensToParse,
							groupCount: self.state.groupCount
						)
					}
					guard subGroupCount >= 0 else {
						throw RegexError.UnmatchedClosingParenthesis
					}
					subGroupCount -= 1
					tokensToParse.append(token)
				default:
					tokensToParse.append(token)
			}
		}
		
		throw RegexError.UnmatchedOpeningParenthesis
	}
}
