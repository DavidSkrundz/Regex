//
//  Token+Parser.swift
//  Regex
//

extension Token {
	/// - Returns: `true` if `self` is a quantifier
	internal var isQuantifier: Bool {
		switch self {
			case .Optional:              return true
			case .OneOrMore:             return true
			case .ZeroOrMore:            return true
			case .LazyOptional:          return true
			case .LazyOneOrMore:         return true
			case .LazyZeroOrMore:        return true
			case .Amount(_):             return true
			case .AmountOrLess(_):       return true
			case .AmountOrMore(_):       return true
			case .AmountRange(_, _):     return true
			case .LazyAmount(_):         return true
			case .LazyAmountOrLess(_):   return true
			case .LazyAmountOrMore(_):   return true
			case .LazyAmountRange(_, _): return true
			
			default: return false
		}
	}
}