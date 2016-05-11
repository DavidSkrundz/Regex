//
//  String+Regex.swift
//  Regex
//

infix operator =~ : ComparisonPrecedence

/// Usage sample:
///
///		let fourLetterWords = "drink beer, it's very nice!" =~ "\\b\\w{4}\\b" ?? []
///
///		/*
///		fourLetterWords = [
///			RegexMatch(match: "beer", groups: []),
///			RegexMatch(match: "very", groups: []),
///			RegexMatch(match: "nice", groups: []),
///		]
///		*/
///
/// - Returns: An `Array<RegexMatch>` containing the matches of `rhs` found in `lhs`
public func =~(lhs: String, rhs: String) -> [RegexMatch]? {
	let regex = try? Regex(rhs)
	return regex?.match(lhs)
}
