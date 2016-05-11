//
//  RegexError.swift
//  Regex
//

/// Possible errors that can occur while compiling or processing an expression
public enum RegexError: Error {
	case DanglingBackslash
	case ReversedSetRange
	case InvalidQuantifierRange
	case UnmatchedOpeningBracket
	case UnmatchedClosingBracket
	case InvalidFlags
	
	case InvalidTargetForQuantifier
	case UnmatchedOpeningParenthesis
	case UnmatchedClosingParenthesis
}

extension RegexError: Equatable {}
public func ==(lhs: RegexError, rhs: RegexError) -> Bool {
	switch (lhs, rhs) {
		case (.DanglingBackslash,       .DanglingBackslash):       return true
		case (.ReversedSetRange,        .ReversedSetRange):        return true
		case (.InvalidQuantifierRange,  .InvalidQuantifierRange):  return true
		case (.UnmatchedOpeningBracket, .UnmatchedOpeningBracket): return true
		case (.UnmatchedClosingBracket, .UnmatchedClosingBracket): return true
		case (.InvalidFlags,            .InvalidFlags):            return true
		
		case (.InvalidTargetForQuantifier,  .InvalidTargetForQuantifier):  return true
		case (.UnmatchedOpeningParenthesis, .UnmatchedOpeningParenthesis): return true
		case (.UnmatchedClosingParenthesis, .UnmatchedClosingParenthesis): return true
		
		default: return false
	}
}

extension RegexError: CustomStringConvertible {
	public var description: String {
		switch self {
			case .DanglingBackslash:       return "Dangling backslash"
			case .ReversedSetRange:        return "Reversed range for set"
			case .InvalidQuantifierRange:  return "Quantifier minimum is greater than maximum"
			case .UnmatchedOpeningBracket: return "Unmatched openning bracket"
			case .UnmatchedClosingBracket: return "Unmatched closing bracket"
			case .InvalidFlags:            return "Invalid flags specified"
			
			case .InvalidTargetForQuantifier:  return "Invalid target for quantifier"
			case .UnmatchedOpeningParenthesis: return "Unmatched opennning parenthesis"
			case .UnmatchedClosingParenthesis: return "Unmatched closing parenthesis"
		}
	}
}
