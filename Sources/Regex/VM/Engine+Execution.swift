//
//  Engine+Execution.swift
//  Regex
//

import Generator

extension Engine {
	/// Does all of the processing
	///
	/// - Returns: A list of threads to keep or that were created, and a list of matches that were found
	internal func executeThread(_ thread: Thread, character: Character?, stringPointer: Int, stringGenerator: Generator<String>, idGenerator: inout ThreadIDGenerator) -> (threads: [Thread], matches: [Match]) {
		var thread = thread
		let instruction = self.program[thread.instructionPointer]
		switch instruction {
			case let .Character(matchCharacter) where character != matchCharacter: return ([], [])
			case .Character(_):
				thread.instructionPointer += 1
				return ([thread], [])
				
			case let .CharacterSet(include: includeSet, exclude: excludeSet):
				guard let character = character else { return ([], []) }
				var dontMatch = false
				if !excludeSet.isEmpty { dontMatch = excludeSet.contains(character) }
				if !includeSet.isEmpty { dontMatch = !includeSet.contains(character) }
				if dontMatch {
					return ([], [])
				}
				thread.instructionPointer += 1
				return ([thread], [])
				
			case .Start where stringPointer != 0 && !(self.multilineSearch && stringGenerator.peekPrevious() == "\n"): return ([], [])
			case .End where !stringGenerator.atEnd: return ([], [])
			case .WordBoundary where (stringGenerator.peekPrevious()?.isWordCharacter ?? false) == (stringGenerator.peek()?.isWordCharacter ?? false): return ([], [])
			case .NotWordBoundary where(stringGenerator.peekPrevious()?.isWordCharacter ?? false) != (stringGenerator.peek()?.isWordCharacter ?? false): return ([], [])
				
			case .Start, .End, .WordBoundary, .NotWordBoundary:
				thread.instructionPointer += 1
				return executeThread(thread, character: character, stringPointer: stringPointer, stringGenerator: stringGenerator, idGenerator: &idGenerator)
				
			case let .Split(location, splitLocation):
				let newCurrThread = Thread(id: idGenerator.nextChildFrom(thread.id), instruction: location, startStringPointer: thread.startStringPointer, groupPointers: thread.groupPointers)
				let currentThreadResults = executeThread(newCurrThread, character: character, stringPointer: stringPointer, stringGenerator: stringGenerator, idGenerator: &idGenerator)
				let splitThreadID = idGenerator.nextChildFrom(thread.id)
				let splitThread = Thread(id: splitThreadID, instruction: splitLocation, startStringPointer: thread.startStringPointer, groupPointers: thread.groupPointers)
				let splitThreadResults = executeThread(splitThread, character: character, stringPointer: stringPointer, stringGenerator: stringGenerator, idGenerator: &idGenerator)
				return (
					currentThreadResults.threads + splitThreadResults.threads,
					currentThreadResults.matches + splitThreadResults.matches
				)
				
			case let .Jump(location):
				thread.instructionPointer = location
				return executeThread(thread, character: character, stringPointer: stringPointer, stringGenerator: stringGenerator, idGenerator: &idGenerator)
				
			case let .GroupSave(groupIndex, saveSlot):
				let previousSave = thread.groupPointers[groupIndex] ?? (-1, -1)
				switch saveSlot {
				case .Start:
					thread.groupPointers[groupIndex] = (stringPointer, previousSave.1)
				case .End:
					thread.groupPointers[groupIndex] = (previousSave.0, stringPointer)
				}
				thread.instructionPointer += 1
				return executeThread(thread, character: character, stringPointer: stringPointer, stringGenerator: stringGenerator, idGenerator: &idGenerator)
				
			case .BackReference(_): return ([], [])
			case .StartLookAhead: return ([], [])
			case .StartNegativeLookAhead: return ([], [])
			case .StartLookBehind: return ([], [])
			case .StartNegativeLookBehind: return ([], [])
			case .EndLook: return ([], [])
				
			case .Match:
				var groups = [Range<Int>]()
				if self.groupCount >= 1 {
					groups = (1...self.groupCount)
						.map { thread.groupPointers[$0] ?? (0, 0) }
						.map { $0.0..<$0.1 }
				}
				return (
					[],
					[Match(id: thread.id, range: thread.startStringPointer..<stringPointer, groups: groups)]
				)
				
			case .MultilineFlag, .CaseInsensitiveFlag, .GlobalSearchFlag: fatalError("Should have been handled in init()")
		}
	}
}
