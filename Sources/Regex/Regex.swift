//
//  Regex.swift
//  Regex
//

/// Manages an `Engine` and compiles the `pattern` into a runnable format.
///
/// Usage sample:
///
///		let regex = try! Regex(pattern: "[a-zA-Z]+")
///		let string = "RegEx is tough, but useful."
///
///		let words = regex.match(string)
///
///		/*
///		words = [
///			RegexMatch(match: "RegEx", groups: []),
///			RegexMatch(match: "is", groups: []),
///			RegexMatch(match: "tough", groups: []),
///			RegexMatch(match: "but", groups: []),
///			RegexMatch(match: "useful", groups: []),
///		]
///		*/
///
/// - Author: David Skrundz
public struct Regex {
	/// Compiles the prattern for later use
	public init(_ pattern: String) throws {
	}
	
	/// Find matches in `string`
	///
	/// - Returns: A `[RegexMatch]` containing every found match
	public func match(_ string: String) -> [RegexMatch] {
		return []
	}
}
