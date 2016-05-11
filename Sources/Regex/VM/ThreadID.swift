//
//  ThreadID.swift
//  Regex
//

/// An identifier for a `Thread`
internal struct ThreadID {
	internal let globalID: Int
	internal let parentIDs: [Int]
	
	internal init(_ globalID: Int, _ parentIDs: [Int]) {
		self.globalID = globalID
		self.parentIDs = parentIDs
	}
}

extension ThreadID: Equatable {}
internal func ==(lhs: ThreadID, rhs: ThreadID) -> Bool {
	return lhs.globalID == rhs.globalID && lhs.parentIDs == rhs.parentIDs
}

extension ThreadID: Comparable {}
internal func <(lhs: ThreadID, rhs: ThreadID) -> Bool {
	return lhs.parentIDs.lexicographicallyPrecedes(rhs.parentIDs)
}
