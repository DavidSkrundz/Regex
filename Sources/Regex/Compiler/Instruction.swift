//
//  Instruction.swift
//  Regex
//

/// `Instruction`s are consumed by the `Engine` as a program which represents the regular expression.
internal enum Instruction {
	case Character(Swift.Character)
	case CharacterSet(include: Set<Swift.Character>, exclude: Set<Swift.Character>)
	
	case Start
	case End
	case WordBoundary
	case NotWordBoundary
	
	case GroupSave(Int, SaveSlot)
	case BackReference(Int)
	
	case Split(Int, Int)
	case Jump(Int)
	
	case Match
	
	// Lookarounds
	case StartLookAhead
	case StartNegativeLookAhead
	case StartLookBehind
	case StartNegativeLookBehind
	case EndLook
	
	// Flags
	case MultilineFlag
	case GlobalSearchFlag
	case CaseInsensitiveFlag
}

extension Instruction: Equatable {}
func ==(lhs: Instruction, rhs: Instruction) -> Bool {
	switch (lhs, rhs) {
		case (.Match,                   .Match):                   return true
		case (.Start,                   .Start):                   return true
		case (.End,                     .End):                     return true
		case (.WordBoundary,            .WordBoundary):            return true
		case (.NotWordBoundary,         .NotWordBoundary):         return true
		case (.MultilineFlag,           .MultilineFlag):           return true
		case (.StartLookAhead,          .StartLookAhead):          return true
		case (.StartNegativeLookAhead,  .StartNegativeLookAhead):  return true
		case (.StartLookBehind,         .StartLookBehind):         return true
		case (.StartNegativeLookBehind, .StartNegativeLookBehind): return true
		case (.EndLook,                 .EndLook):                 return true
		case (.GlobalSearchFlag,        .GlobalSearchFlag):        return true
		case (.CaseInsensitiveFlag,     .CaseInsensitiveFlag):     return true
		
		case let (.Character(lhs),     .Character(rhs)):     return lhs == rhs
		case let (.Jump(lhs),          .Jump(rhs)):          return lhs == rhs
		case let (.BackReference(lhs), .BackReference(rhs)): return lhs == rhs
		
		case let (.CharacterSet(lhs1, lhs2), .CharacterSet(rhs1, rhs2)): return lhs1 == rhs1 && lhs2 == rhs2
		case let (.GroupSave(lhs1, lhs2),    .GroupSave(rhs1, rhs2)):    return lhs1 == rhs1 && lhs2 == rhs2
		case let (.Split(lhs1, lhs2),        .Split(rhs1, rhs2)):        return lhs1 == rhs1 && lhs2 == rhs2
		
		default: return false
	}
}
