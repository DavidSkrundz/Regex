//
//  Thread.swift
//  Regex
//

/// A data structure that helps simulate threads in the Regex VM
internal struct Thread {
	internal let id: ThreadID
	
	internal var instructionPointer: Int
	
	internal let startStringPointer: Int
	internal var groupPointers = [Int : (Int, Int)]()
	
	internal init(id: ThreadID, instruction instructionPointer: Int, startStringPointer: Int, groupPointers: [Int : (Int, Int)] = [:]) {
		self.id = id
		self.instructionPointer = instructionPointer
		self.startStringPointer = startStringPointer
		self.groupPointers = groupPointers
	}
}

/// - Note: Only cares about `instructionPointer` and `startStringPointer`
extension Thread: Hashable {
	var hashValue: Int {
		return Int(Double((instructionPointer + startStringPointer) * (instructionPointer + startStringPointer + 1)) / 2.0) + startStringPointer
	}
}

/// - Note: Only cares about `instructionPointer` and `startStringPointer`
extension Thread: Equatable {}
internal func ==(lhs: Thread, rhs: Thread) -> Bool {
	return lhs.hashValue == rhs.hashValue
}
