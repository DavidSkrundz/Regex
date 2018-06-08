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
	private let vm: Engine
	
	/// Compiles the prattern for later use
	public init(_ pattern: String) throws {
		let tokens = try Lexer.lex(pattern)
		let symbols = try Parser.parse(tokens)
		let program = Compiler.compile(symbols)
		self.vm = Engine(program: program)
	}
	
	/// Find matches in `string`
	///
	/// - Returns: A `[RegexMatch]` containing every found match
	public func match(_ string: String) -> [RegexMatch] {
		let matches = self.vm.match(string)
		return matches.map { (match) -> RegexMatch in
			let groups = match.groups.map { string[$0] }
			return RegexMatch(match: string[match.range], range: match.range, groups: groups, groupRanges: match.groups)
		}
	}
}
