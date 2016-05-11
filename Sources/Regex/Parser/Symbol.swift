//
//  Symbol.swift
//  Regex
//

/// A `Symbol` represents compounded `Tokens` in a way the realizes the final structure of the pattern
internal indirect enum Symbol {
	// Literal String
	case Character(Swift.Character)
	
	// Greedy Quantifiers
	case Optional(Symbol)
	case OneOrMore(Symbol)
	case ZeroOrMore(Symbol)
	
	// Non Greedy Quantifiers
	case LazyOptional(Symbol)
	case LazyOneOrMore(Symbol)
	case LazyZeroOrMore(Symbol)
	
	// Greedy Numeric Quantifiers
	case Amount(Int, Symbol)
	case AmountOrLess(Int, Symbol)
	case AmountOrMore(Int, Symbol)
	case AmountRange(Int, Int, Symbol)
	
	// Lazy Numeric Quantifiers
	case LazyAmount(Int, Symbol)
	case LazyAmountOrLess(Int, Symbol)
	case LazyAmountOrMore(Int, Symbol)
	case LazyAmountRange(Int, Int, Symbol)
	
	// Character Sets
	case CharacterSet(include: Set<Swift.Character>, exclude: Set<Swift.Character>)
	
	// Anchors
	case Start
	case End
	case WordBoundary
	case NotWordBoundary
	
	// Alternation
	case Alternation([Symbol], [Symbol])
	
	// Capture Groups
	case Group([Symbol])
	case CaptureGroup([Symbol])
	case LookAheadGroup([Symbol])
	case NegativeLookAheadGroup([Symbol])
	case LookBehindGroup([Symbol])
	case NegativeLookBehindGroup([Symbol])
	
	case BackReference(Int)
	
	// Flags
	case MultilineFlag
	case GlobalSearchFlag
	case CaseInsensitiveFlag
}

extension Symbol {
	/// - Returns: `true` if `self` is a quantifier
	internal var isQuantifier: Bool {
		switch self {
			case .Optional:                 return true
			case .OneOrMore:                return true
			case .ZeroOrMore:               return true
			case .LazyOptional:             return true
			case .LazyOneOrMore:            return true
			case .LazyZeroOrMore:           return true
			case .Amount(_, _):             return true
			case .AmountOrLess(_, _):       return true
			case .AmountOrMore(_, _):       return true
			case .AmountRange(_, _, _):     return true
			case .LazyAmount(_, _):         return true
			case .LazyAmountOrLess(_, _):   return true
			case .LazyAmountOrMore(_, _):   return true
			case .LazyAmountRange(_, _, _): return true
			
			default: return false
		}
	}
}
