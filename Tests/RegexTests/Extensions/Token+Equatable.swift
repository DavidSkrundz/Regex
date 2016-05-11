//
//  Token+Equatable.swift
//  Regex
//

@testable import Regex

extension Token: Equatable {}
public func ==(lhs: Token, rhs: Token) -> Bool {
		switch (lhs, rhs) {
		case (.Optional,                     .Optional):                     return true
		case (.OneOrMore,                    .OneOrMore):                    return true
		case (.ZeroOrMore,                   .ZeroOrMore):                   return true
		case (.LazyOptional,                 .LazyOptional):                 return true
		case (.LazyOneOrMore,                .LazyOneOrMore):                return true
		case (.LazyZeroOrMore,               .LazyZeroOrMore):               return true
		case (.Start,                        .Start):                        return true
		case (.End,                          .End):                          return true
		case (.WordBoundary,                 .WordBoundary):                 return true
		case (.NotWordBoundary,              .NotWordBoundary):              return true
		case (.Alternation,                  .Alternation):                  return true
		case (.StartGroup,                   .StartGroup):                   return true
		case (.StartCaptureGroup,            .StartCaptureGroup):            return true
		case (.StartLookAheadGroup,          .StartLookAheadGroup):          return true
		case (.StartNegativeLookAheadGroup,  .StartNegativeLookAheadGroup):  return true
		case (.StartLookBehindGroup,         .StartLookBehindGroup):         return true
		case (.StartNegativeLookBehindGroup, .StartNegativeLookBehindGroup): return true
		case (.EndGroup,                     .EndGroup):                     return true
		case (.MultilineFlag,                .MultilineFlag):                return true
		case (.GlobalSearchFlag,             .GlobalSearchFlag):             return true
		case (.CaseInsensitiveFlag,          .CaseInsensitiveFlag):          return true
			
		case let (.Character(lhs),        .Character(rhs)):        return lhs == rhs
		case let (.OctalCharacter(lhs),   .OctalCharacter(rhs)):   return lhs == rhs
		case let (.Amount(lhs),           .Amount(rhs)):           return lhs == rhs
		case let (.AmountOrLess(lhs),     .AmountOrLess(rhs)):     return lhs == rhs
		case let (.AmountOrMore(lhs),     .AmountOrMore(rhs)):     return lhs == rhs
		case let (.LazyAmount(lhs),       .LazyAmount(rhs)):       return lhs == rhs
		case let (.LazyAmountOrLess(lhs), .LazyAmountOrLess(rhs)): return lhs == rhs
		case let (.LazyAmountOrMore(lhs), .LazyAmountOrMore(rhs)): return lhs == rhs
			
		case let (.CharacterSet(lhs1, lhs2),    .CharacterSet(rhs1, rhs2)):    return lhs1 == rhs1 && lhs2 == rhs2
		case let (.AmountRange(lhs1, lhs2),     .AmountRange(rhs1, rhs2)):     return lhs1 == rhs1 && lhs2 == rhs2
		case let (.LazyAmountRange(lhs1, lhs2), .LazyAmountRange(rhs1, rhs2)): return lhs1 == rhs1 && lhs2 == rhs2
			
		default: return false
	}
}
