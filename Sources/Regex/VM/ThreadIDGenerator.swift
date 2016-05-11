//
//  ThreadIDGenerator.swift
//  Regex
//

/// Generates a sequence of unique sequencial `ThreadID`s
///
/// - Author: David Skrundz
internal struct ThreadIDGenerator {
	private let idGenerator: () -> Int
	
	/// Create a new `ThreadIDGenerator` whose first `ThreadID` is `0, 0`
	internal init() {
		var currentID = 0
		self.idGenerator = {
			defer { currentID += 1 }
			return currentID
		}
	}
	
	/// Get the next `ThreadID` in the sequence of root ids
	internal func next() -> ThreadID {
		let nextID = self.idGenerator()
		return ThreadID(nextID, [nextID])
	}
	
	/// Get the next `ThreadID` in the sequence following a parent
	internal func nextChildFrom(_ parent: ThreadID) -> ThreadID {
		let nextID = self.idGenerator()
		return ThreadID(nextID, parent.parentIDs + [nextID])
	}
}
