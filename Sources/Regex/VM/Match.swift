//
//  Match.swift
//  Regex
//

/// Hold the ID of the `Thread` that created it, and the range and group information. The output of the VM
internal struct Match {
	internal let id: ThreadID
	internal let range: Range<Int>
	internal let groups: [Range<Int>]
	
	internal init(id: ThreadID, range: Range<Int>, groups: [Range<Int>]) {
		self.id = id
		self.range = range
		self.groups = groups
	}
	
	internal init(id: ThreadID, range: Range<Int>, groups: Range<Int>...) {
		self.id = id
		self.range = range
		self.groups = groups
	}
}

/// - Note: Does not care about `id`
extension Match: Equatable {}
internal func ==(lhs: Match, rhs: Match) -> Bool {
	return lhs.range == rhs.range && lhs.groups == rhs.groups
}
