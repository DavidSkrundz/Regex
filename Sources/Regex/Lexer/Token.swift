//
//  Token.swift
//  Regex
//

/// A `Token` represents a single 'unit' of a reguar expression.
/// It is used to convert from a `String` to 'meaning'.
internal enum Token {
	// Literal Character
	case Character(Swift.Character)
	case OctalCharacter(Swift.Character)
	
	// Greedy Quantifiers
	case Optional
	case OneOrMore
	case ZeroOrMore
	
	// Lazy Quantifiers
	case LazyOptional
	case LazyOneOrMore
	case LazyZeroOrMore
	
	// Greedy Numeric Quantifiers
	case Amount(Int)
	case AmountOrLess(Int)
	case AmountOrMore(Int)
	case AmountRange(Int, Int)
	
	// Lazy Numeric Quantifiers
	case LazyAmount(Int)
	case LazyAmountOrLess(Int)
	case LazyAmountOrMore(Int)
	case LazyAmountRange(Int, Int)
	
	// Character Sets
	case CharacterSet(include: Set<Swift.Character>,
	                  exclude: Set<Swift.Character>)
	
	// Anchors
	case Start
	case End
	case WordBoundary
	case NotWordBoundary
	
	// Alternation
	case Alternation
	
	// Capture Groups
	case StartGroup
	case StartCaptureGroup
	case StartLookAheadGroup
	case StartNegativeLookAheadGroup
	case StartLookBehindGroup
	case StartNegativeLookBehindGroup
	case EndGroup
	
	// Flags
	case MultilineFlag
	case GlobalSearchFlag
	case CaseInsensitiveFlag
}
