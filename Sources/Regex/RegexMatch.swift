//
//  RegexMatch.swift
//  Regex
//

/// Contains all of the information that a match can consist of
public struct RegexMatch {
	public let match: String
	public let range: Range<Int>
	public let groups: [String]
	public let groupRanges: [Range<Int>]
	
	internal init(match: String, range: Range<Int>, groups: [String], groupRanges: [Range<Int>]) {
		self.match = match
		self.range = range
		self.groups = groups
		self.groupRanges = groupRanges
	}
}

extension RegexMatch: Equatable {}
public func ==(lhs: RegexMatch, rhs: RegexMatch) -> Bool {
	return (
		lhs.match == rhs.match &&
		lhs.range == rhs.range &&
		lhs.groups == rhs.groups &&
		lhs.groupRanges == rhs.groupRanges
	)
}
