//
//  Symbol+Equatable.swift
//  Regex
//

@testable import Regex

extension Symbol: Equatable {}
public func ==(lhs: Symbol, rhs: Symbol) -> Bool {
	switch (lhs, rhs) {
		case (.Start,               .Start):               return true
		case (.End,                 .End):                 return true
		case (.WordBoundary,        .WordBoundary):        return true
		case (.NotWordBoundary,     .NotWordBoundary):     return true
		case (.MultilineFlag,       .MultilineFlag):       return true
		case (.GlobalSearchFlag,    .GlobalSearchFlag):    return true
		case (.CaseInsensitiveFlag, .CaseInsensitiveFlag): return true
			
		case let (.Character(lhs),               .Character(rhs)):               return lhs == rhs
		case let (.Optional(lhs),                .Optional(rhs)):                return lhs == rhs
		case let (.OneOrMore(lhs),               .OneOrMore(rhs)):               return lhs == rhs
		case let (.ZeroOrMore(lhs),              .ZeroOrMore(rhs)):              return lhs == rhs
		case let (.LazyOptional(lhs),            .LazyOptional(rhs)):            return lhs == rhs
		case let (.LazyOneOrMore(lhs),           .LazyOneOrMore(rhs)):           return lhs == rhs
		case let (.LazyZeroOrMore(lhs),          .LazyZeroOrMore(rhs)):          return lhs == rhs
		case let (.Group(lhs),                   .Group(rhs)):                   return lhs == rhs
		case let (.CaptureGroup(lhs),            .CaptureGroup(rhs)):            return lhs == rhs
		case let (.LookAheadGroup(lhs),          .LookAheadGroup(rhs)):          return lhs == rhs
		case let (.NegativeLookAheadGroup(lhs),  .NegativeLookAheadGroup(rhs)):  return lhs == rhs
		case let (.LookBehindGroup(lhs),         .LookBehindGroup(rhs)):         return lhs == rhs
		case let (.NegativeLookBehindGroup(lhs), .NegativeLookBehindGroup(rhs)): return lhs == rhs
		case let (.BackReference(lhs),           .BackReference(rhs)):           return lhs == rhs
			
		case let (.CharacterSet(lhs1, lhs2),     .CharacterSet(rhs1, rhs2)):     return lhs1 == rhs1 && lhs2 == rhs2
		case let (.Amount(lhs1, lhs2),           .Amount(rhs1, rhs2)):           return lhs1 == rhs1 && lhs2 == rhs2
		case let (.AmountOrLess(lhs1, lhs2),     .AmountOrLess(rhs1, rhs2)):     return lhs1 == rhs1 && lhs2 == rhs2
		case let (.AmountOrMore(lhs1, lhs2),     .AmountOrMore(rhs1, rhs2)):     return lhs1 == rhs1 && lhs2 == rhs2
		case let (.LazyAmount(lhs1, lhs2),       .LazyAmount(rhs1, rhs2)):       return lhs1 == rhs1 && lhs2 == rhs2
		case let (.LazyAmountOrLess(lhs1, lhs2), .LazyAmountOrLess(rhs1, rhs2)): return lhs1 == rhs1 && lhs2 == rhs2
		case let (.LazyAmountOrMore(lhs1, lhs2), .LazyAmountOrMore(rhs1, rhs2)): return lhs1 == rhs1 && lhs2 == rhs2
		case let (.Alternation(lhs1, lhs2),      .Alternation(rhs1, rhs2)):      return lhs1 == rhs1 && lhs2 == rhs2
			
		case let (.AmountRange(lhs1, lhs2, lhs3),     .AmountRange(rhs1, rhs2, rhs3)):     return lhs1 == rhs1 && lhs2 == rhs2 && lhs3 == rhs3
		case let (.LazyAmountRange(lhs1, lhs2, lhs3), .LazyAmountRange(rhs1, rhs2, rhs3)): return lhs1 == rhs1 && lhs2 == rhs2 && lhs3 == rhs3
			
		default: return false
	}
}
