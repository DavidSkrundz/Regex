//
//  Engine+Matching.swift
//  Regex
//

import Util

extension Engine {
	/// Called to run the program agains the `string`
	///
	/// - Returns: A `[Match]` containing every found match
	internal func match(_ string: String) -> [Match] {
		let input = self.caseInsensitiveSearch ? string.lowercased() : string
		
		var idGenerator = ThreadIDGenerator()
		var stringGenerator = input.generator()
		
		var threads: [Thread] = [Thread(id: idGenerator.next(), instruction: 0, startStringPointer: 0)]
		var matches = [Match]()
		
		var stringPointer = 0
		while let character = stringGenerator.peek() {
			
			let tempThreads = threads
			threads.removeAll(keepingCapacity: true)
			for thread in tempThreads {
				let results = executeThread(thread, character: character, stringPointer: stringPointer, stringGenerator: stringGenerator, idGenerator: &idGenerator)
				if !results.matches.isEmpty { matches += results.matches }
				
				for thread in results.threads {
					if self.program[thread.instructionPointer] == .Match {
						let results = executeThread(thread, character: nil, stringPointer: stringPointer + 1, stringGenerator: stringGenerator, idGenerator: &idGenerator)
						if !results.matches.isEmpty { matches += results.matches }
					} else {
						threads.append(thread)
					}
				}
			}
			threads.append(Thread(id: idGenerator.next(), instruction: 0, startStringPointer: stringPointer + 1))
			
			if !self.globalSearch && !matches.isEmpty { break }
			
			stringGenerator.advance()
			stringPointer += 1
		}
		
		for thread in threads {
			let results = executeThread(thread, character: nil, stringPointer: stringPointer, stringGenerator: stringGenerator, idGenerator: &idGenerator)
			if !results.matches.isEmpty { matches += results.matches }
		}
		
		var lastMatchParentIndex = -1
		var lastRangeMax = -1
		return matches
			.sorted { $0.id < $1.id }
			.filter { match in
				if match.range.lowerBound < lastRangeMax { return false }
				if match.id.parentIDs.first ?? -1 <= lastMatchParentIndex { return false }
				lastMatchParentIndex = match.id.parentIDs.dropLast().first ?? -1
				lastRangeMax = match.range.upperBound
				return true
			}
	}
}
