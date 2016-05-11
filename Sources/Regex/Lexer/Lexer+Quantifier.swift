//
//  Lexer+Quantifier.swift
//  Regex
//

import Util

private let EMPTY_NUMBER = -1
extension Lexer {
	/// Tokenizes numeric quantifiers
	///
	///		{1,2}
	///		{1,}
	///		{,2}
	///		{2}
	///
	/// - Returns: A `Token` representing the quantifier or `nil` if it is
	///            invalid and should be treated as a literal character instead
	internal mutating func processNumericQuantifier() throws {
		var rangeLocations = [String]()
		var currentLocation = ""
		
		let generatorBackup = self.state.generator
		
		while let character = self.state.generator.next() {
			switch character {
				case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
					currentLocation.append(character)
				case "," where rangeLocations.count < 2:
					rangeLocations.append(currentLocation)
					currentLocation = ""
				case "}":
					rangeLocations.append(currentLocation)
					var isLazy: Bool = false
					if self.state.generator.peek() == "?" {
						isLazy = true
						self.state.generator.advance()
					}
					try self.addToken(rangeLocations, isLazy)
					return
				default:
					break
			}
		}
		
		self.state.generator = generatorBackup
	}
	
	/// Converts a list of numbers (from `processNumericQuantifier`) and creates
	/// the appropriate `Token`
	///
	/// - Returns: A `Token` representing the quantifier or `nil` if it is
	///            invalid and should be treated as a literal character instead
	private mutating func addToken(_ strings: [String], _ isLazy: Bool) throws {
		let values = strings.map { Int($0) ?? EMPTY_NUMBER }
		switch values.count {
			case 2 where values[0] == EMPTY_NUMBER:
				self.tokens.append(isLazy
					? .LazyAmountOrLess(values[1])
					: .AmountOrLess(values[1]))
			case 2 where values[1] == EMPTY_NUMBER:
				self.tokens.append(isLazy
					? .LazyAmountOrMore(values[0])
					: .AmountOrMore(values[0]))
			case 2 where values[0] > values[1]:
				throw RegexError.InvalidQuantifierRange
			case 2 where values[0] == values[1]:
				self.tokens.append(isLazy
					? .LazyAmount(values[0])
					: .Amount(values[0]))
			case 2 where values[0] < values[1]:
				self.tokens.append(isLazy
					? .LazyAmountRange(values[0], values[1])
					: .AmountRange(values[0], values[1]))
			case 1:
				self.tokens.append(isLazy
					? .LazyAmount(values[0])
					: .Amount(values[0]))
			default:
				return
		}
	}
}
