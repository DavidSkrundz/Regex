//
//  Engine.swift
//  Regex
//

import Util

/// The `Engine` takes a program (`[Instruction]`) and runs it against an input `String` when `match()` is called.
/// The `Engine` does the final processing before outputing found matches.
///
/// - Author: David Skrundz
internal struct Engine {
	private(set) internal var program = [Instruction]()
	
	private(set) internal var globalSearch = false
	private(set) internal var caseInsensitiveSearch = false
	private(set) internal var multilineSearch = false
	
	internal let groupCount: Int
	
	internal init(program: [Instruction]) {
		self.groupCount = program.flatMap { (instruction) -> Int? in
				if case let Instruction.GroupSave(groupIndex, .Start) = instruction { return groupIndex }
				return nil
			}
			.sorted(by: >)
			.first ?? 0
		
		self.program = program.filter { (instruction) in
			switch instruction {
				case .GlobalSearchFlag:    self.globalSearch = true
				case .CaseInsensitiveFlag: self.caseInsensitiveSearch = true
				case .MultilineFlag:       self.multilineSearch = true
				default: return true
			}
			return false
		} + [.Match]
	}
}
