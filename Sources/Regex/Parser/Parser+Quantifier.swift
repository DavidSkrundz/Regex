//
//  Parser+Quantifier.swift
//  Regex
//

extension Parser {
	/// Converts a `Token` to a `Symbol` if it is a quantifier
	///
	/// - Precondition: `token` is a quantifier
	///
	/// - Returns: The `Symbol` representation of `token` applied to
	///            `lastSymbol`
	internal mutating func parseQuantifier(_ lastSymbol: Symbol,
	                                                    _ token: Token) throws {
		let symbol: Symbol
		switch token {
			case .Optional:       symbol = .Optional(lastSymbol)
			case .OneOrMore:      symbol = .OneOrMore(lastSymbol)
			case .ZeroOrMore:     symbol = .ZeroOrMore(lastSymbol)
			case .LazyOptional:   symbol = .LazyOptional(lastSymbol)
			case .LazyOneOrMore:  symbol = .LazyOneOrMore(lastSymbol)
			case .LazyZeroOrMore: symbol = .LazyZeroOrMore(lastSymbol)
			
			case let .Amount(amount):
				symbol = .Amount(amount, lastSymbol)
			case let .AmountOrMore(amount):
				symbol = .AmountOrMore(amount, lastSymbol)
			case let .AmountOrLess(amount):
				symbol = .AmountOrLess(amount, lastSymbol)
			case let .LazyAmount(amount):
				symbol = .LazyAmount(amount, lastSymbol)
			case let .LazyAmountOrMore(amount):
				symbol = .LazyAmountOrMore(amount, lastSymbol)
			case let .LazyAmountOrLess(amount):
				symbol = .LazyAmountOrLess(amount, lastSymbol)
			
			case let .AmountRange(startAmount, endAmount):
				symbol = .AmountRange(startAmount, endAmount, lastSymbol)
			case let .LazyAmountRange(startAmount, endAmount):
				symbol = .LazyAmountRange(startAmount, endAmount, lastSymbol)
			
			default: fatalError("Token is not a quantifier")
		}
		self.symbols.append(symbol)
	}
}
